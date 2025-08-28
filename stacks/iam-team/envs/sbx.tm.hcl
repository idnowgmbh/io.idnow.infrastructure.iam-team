globals "envs" "sbx" {
  backend = {
    profile = "sandbox-infrastructure-identity.AdministratorAccess"
    bucket = "terraform-state-147997160594"
    region = "eu-central-1"
    kms_key_id = "597ee2a9-ed6f-44e9-bb97-60c3107d8671"
  }

  variables = {
    # Environment Configuration
    env = "sbx"
    region = "eu-central-1"
    
    # KMS Configuration
    kms_key_id = "597ee2a9-ed6f-44e9-bb97-60c3107d8671"
    kms_key_arn = "arn:aws:kms:eu-central-1:147997160594:key/597ee2a9-ed6f-44e9-bb97-60c3107d8671"
    
    # TEAM Application Configuration
    sso_login_url = "https://d-99675678f2.awsapps.com/start"
    team_admin_group = "AWS_Sandbox_TEAM_admins"
    team_audit_group = "AWS_Sandbox_TEAM_auditors"
    team_account_id = "147997160594"
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
        environment = "sbx"
        namespace   = "idn"
        region      = "eu"
        application = "team"
    }
  }
}
