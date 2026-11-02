import json
import os
import boto3
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")
organizations = boto3.client("organizations")

eligibility_table = dynamodb.Table(os.environ["ELIGIBILITY_TABLE_NAME"])


def get_account_parent_ou(account_id):
    """Get the parent OU ID for an account from Organizations API"""
    try:
        response = organizations.list_parents(ChildId=account_id)
        parents = response.get("Parents", [])
        
        if not parents:
            print(f"No parent found for account {account_id}")
            return None
        
        parent = parents[0]
        parent_id = parent.get("Id")
        parent_type = parent.get("Type")
        
        # If parent is root, return None (root is not an OU)
        if parent_type == "ROOT":
            return None
            
        return parent_id
    except ClientError as e:
        error_code = e.response.get("Error", {}).get("Code")
        if error_code == "AccountNotFoundException":
            print(f"Account {account_id} not found in Organizations")
            return None
        print(f"Error getting parent for account {account_id}: {e}")
        raise


def get_user_eligibility(user_id, group_ids):
    """Get all eligibility entries for user and their groups.

    Eligibility records are keyed by a policy UUID; the user/group ID lives in
    the `entityId` attribute behind the byEntityId GSI. A get_item on `id` with
    a user ID never matches, so this must query the GSI.
    """
    eligibility_entries = []

    for entity_id in [user_id] + list(group_ids or []):
        if not entity_id:
            continue
        try:
            response = eligibility_table.query(
                IndexName="byEntityId",
                KeyConditionExpression=Key("entityId").eq(entity_id),
            )
            eligibility_entries.extend(response.get("Items", []))
        except ClientError as e:
            print(f"Error querying eligibility for {entity_id}: {e}")

    return eligibility_entries


def validate_request(account_id, permission_set_id, user_id, group_ids):
    """
    Validate that the user is eligible to request access to the account/permission set.
    Returns (is_valid, reason)
    """
    # Get user's eligibility entries
    eligibility_entries = get_user_eligibility(user_id, group_ids)
    
    if not eligibility_entries:
        return False, "No eligibility entries found for user"
    
    # Check each eligibility entry
    for entry in eligibility_entries:
        # Check direct account grants
        accounts = entry.get("accounts", [])
        for account in accounts:
            if account.get("id") == account_id:
                # Check if permission set is allowed
                permissions = entry.get("permissions", [])
                for perm in permissions:
                    if perm.get("id") == permission_set_id:
                        return True, "Direct account grant"
        
        # Check OU-based grants
        ous = entry.get("ous", [])
        if ous:
            # Get account's parent OU from Organizations
            parent_ou = get_account_parent_ou(account_id)
            
            if parent_ou:
                for ou in ous:
                    if ou.get("id") == parent_ou:
                        # Check if permission set is allowed
                        permissions = entry.get("permissions", [])
                        for perm in permissions:
                            if perm.get("id") == permission_set_id:
                                return True, f"OU-based grant (OU: {parent_ou})"
    
    return False, "Account not in user's eligible accounts or OUs"


def get_identity_store_id():
    client = boto3.client("sso-admin")
    return client.list_instances()["Instances"][0]["IdentityStoreId"]


def resolve_caller(identity):
    """Resolve the caller's Identity Center user id and group ids.

    userId/groupIds are GraphQL arguments and therefore client-controlled.
    Trusting them let any authenticated user probe another user's, or any
    group's, eligibility. The shape mirrors teamRouter: the Cognito username is
    the Identity Center userName with an `idc_` prefix.
    """
    username = (identity or {}).get("username")
    if not username:
        raise ValueError("No identity username on the request")

    user_name = username[4:] if username.startswith("idc_") else username
    identity_store_id = get_identity_store_id()
    client = boto3.client("identitystore")

    user_id = client.get_user_id(
        IdentityStoreId=identity_store_id,
        AlternateIdentifier={
            "UniqueAttribute": {
                "AttributePath": "userName",
                "AttributeValue": user_name,
            }
        },
    )["UserId"]

    paginator = client.get_paginator("list_group_memberships_for_member")
    group_ids = []
    for page in paginator.paginate(
        IdentityStoreId=identity_store_id,
        MemberId={"UserId": user_id},
    ):
        group_ids.extend(g["GroupId"] for g in page["GroupMemberships"])

    return user_id, group_ids


def handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    # Extract request details from GraphQL mutation arguments
    arguments = event.get("arguments", {})

    account_id = arguments.get("accountId")
    role_id = arguments.get("roleId")

    if not account_id or not role_id:
        return {
            "valid": False,
            "reason": "Missing accountId or roleId"
        }

    # Identity is taken from the request context, never from the arguments.
    try:
        user_id, group_ids = resolve_caller(event.get("identity"))
    except Exception as e:
        print(f"Unable to resolve caller identity: {e}")
        return {
            "valid": False,
            "reason": "Unable to resolve caller identity"
        }

    # Validate the request
    is_valid, reason = validate_request(account_id, role_id, user_id, group_ids)

    print(f"Validation result for user {user_id}, account {account_id}, role {role_id}: {is_valid} - {reason}")

    return {
        "valid": is_valid,
        "reason": reason
    }
