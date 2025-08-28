# ============================================================================
# TEAM Infrastructure Outputs
# ============================================================================

# ----------------------------------------------------------------------------
# Amplify Outputs
# ----------------------------------------------------------------------------

output "amplify_app_id" {
  description = "The unique ID of the Amplify app"
  value       = module.amplify.amplify_app_id
}

output "amplify_app_arn" {
  description = "The ARN of the Amplify app"
  value       = module.amplify.amplify_app_arn
}

output "amplify_app_name" {
  description = "The name of the Amplify app"
  value       = module.amplify.amplify_app_name
}

output "amplify_default_domain" {
  description = "The default domain for the Amplify app"
  value       = module.amplify.amplify_default_domain
}

output "amplify_branch_name" {
  description = "The name of the Amplify branch"
  value       = module.amplify.amplify_branch_name
}

output "amplify_branch_arn" {
  description = "The ARN of the Amplify branch"
  value       = module.amplify.amplify_branch_arn
}

output "amplify_role_arn" {
  description = "The ARN of the Amplify service role"
  value       = module.amplify.amplify_role_arn
}

output "trigger_build_lambda_arn" {
  description = "The ARN of the Lambda function that triggers Amplify builds"
  value       = module.amplify.trigger_build_lambda_arn
}

output "trigger_build_lambda_name" {
  description = "The name of the Lambda function that triggers Amplify builds"
  value       = module.amplify.trigger_build_lambda_name
}

# ----------------------------------------------------------------------------
# General Outputs
# ----------------------------------------------------------------------------

output "environment" {
  description = "Environment name"
  value       = var.env
}

output "region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}

output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "name_prefix" {
  description = "Name prefix used for resources"
  value       = local.name_prefix
}
