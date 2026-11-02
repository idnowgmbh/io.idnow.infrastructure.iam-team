import json
import uuid
import os
import boto3
from botocore.exceptions import ClientError


def get_identity_store_id():
    client = boto3.client('sso-admin')
    return client.list_instances()['Instances'][0]['IdentityStoreId']


def resolve_caller(identity):
    """Resolve the caller's IAM Identity Center user id and group ids.

    The GraphQL arguments are client-controlled and must not be trusted.
    Eligibility is resolved per user/group, so accepting userId/groupIds from
    the caller let any authenticated user read another user's, or any group's,
    entitlements (accounts and permission sets) by passing those ids.

    The shape mirrors teamRouter: the Cognito username is the Identity Center
    userName with an `idc_` prefix.
    """
    username = (identity or {}).get("username")
    if not username:
        raise ValueError("No identity username on the request")

    user_name = username[4:] if username.startswith("idc_") else username
    identity_store_id = get_identity_store_id()
    client = boto3.client('identitystore')

    user_id = client.get_user_id(
        IdentityStoreId=identity_store_id,
        AlternateIdentifier={
            "UniqueAttribute": {
                "AttributePath": "userName",
                "AttributeValue": user_name,
            }
        },
    )['UserId']

    paginator = client.get_paginator('list_group_memberships_for_member')
    group_ids = []
    for page in paginator.paginate(
        IdentityStoreId=identity_store_id,
        MemberId={'UserId': user_id},
    ):
        group_ids.extend(g['GroupId'] for g in page['GroupMemberships'])

    return user_id, group_ids


def handler(event, context):
    identity = event.get("identity") or {}
    username = identity.get("username")

    generated_uuid = str(uuid.uuid4())

    try:
        user_id, group_ids = resolve_caller(identity)
    except (ClientError, ValueError) as e:
        # Fail closed: query with no user/group ids so the caller receives an
        # empty policy. Falling back to the client-supplied ids would restore
        # the disclosure this change removes.
        print(f"Unable to resolve caller identity, publishing empty policy: {e}")
        user_id, group_ids = None, []

    payload = {
        "id": generated_uuid,
        "userId": user_id,
        "groupIds": group_ids,
        "username": username,
    }

    print(json.dumps(payload))

    lambda_client = boto3.client('lambda')
    invoke_params = {
        'FunctionName': os.environ['FUNCTION_TEAMGETENTITLEMENT_NAME'],
        'InvocationType': 'Event',
        'Payload': json.dumps(payload)
    }

    lambda_client.invoke(**invoke_params)

    return {
        'id': generated_uuid,
        'username': username
    }
