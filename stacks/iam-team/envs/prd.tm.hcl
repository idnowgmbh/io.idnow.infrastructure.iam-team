globals "envs" "prd" {
  backend = {
    profile = "idn-eu-prd-infrastructure-identity.AWSAdministratorAccess"
    bucket = "terraform-state-718226530287"
    region = "eu-central-1"
    kms_key_id = "744f6658-b76b-435c-839a-fd940fba7617"
  }

  variables = {
    # Environment Configuration
    env = "prd"
    region = "eu-central-1"
    
    # KMS Configuration
    kms_key_id = "744f6658-b76b-435c-839a-fd940fba7617"
    kms_key_arn = "arn:aws:kms:eu-central-1:718226530287:key/744f6658-b76b-435c-839a-fd940fba7617"
    
    # TEAM Application Configuration
    sso_login_url = "https://idnow-prd.awsapps.com/start"
    team_admin_group = "TEAM-Admins-PRD"
    team_audit_group = "TEAM-Auditors-PRD"
    team_account_id = "718226530287"
    cloudtrail_audit_logs = "read_write"
    
    # Amplify Configuration
    custom_amplify_domain = ""
    custom_repository = "No"
    repository_url = ""
    repository_access_token = ""
    custom_repository_secret_name = ""
    
    # Tags
    tags = {
        owner       = "security"
        cost_center = "10001"
        stack       = "identity"
        environment = "prd"
        namespace   = "idn"
        region      = "eu"
        application = "team"
    }
  }
}
