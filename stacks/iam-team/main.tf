# ============================================================================
# TEAM (Temporary Elevated Access Management) - Main Terraform Configuration
# Deploys TEAM infrastructure using Terramate + OpenTofu
# ============================================================================

# ----------------------------------------------------------------------------
# Data Sources
# ----------------------------------------------------------------------------

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ----------------------------------------------------------------------------
# Locals
# ----------------------------------------------------------------------------

locals {
  name_prefix = "team-${var.env}"
  
  # Convert tags map to JSON string for Amplify environment variables
  tags_json = jsonencode(var.tags)
}

# ----------------------------------------------------------------------------
# Amplify Application Module
# ----------------------------------------------------------------------------

module "amplify" {
  source = "./modules/amplify"
  
  env                   = var.env
  sso_login_url        = var.sso_login_url
  cloudtrail_audit_logs = var.cloudtrail_audit_logs
  team_admin_group     = var.team_admin_group
  team_audit_group     = var.team_audit_group
  team_account_id      = var.team_account_id
  custom_amplify_domain = var.custom_amplify_domain
  tags                 = var.tags
  tags_json            = local.tags_json
}
