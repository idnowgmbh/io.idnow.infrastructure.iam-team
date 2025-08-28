output "amplify_app_id" {
  description = "The unique ID of the Amplify app"
  value       = aws_amplify_app.team_app.id
}

output "amplify_app_arn" {
  description = "The ARN of the Amplify app"
  value       = aws_amplify_app.team_app.arn
}

output "amplify_app_name" {
  description = "The name of the Amplify app"
  value       = aws_amplify_app.team_app.name
}

output "amplify_default_domain" {
  description = "The default domain for the Amplify app"
  value       = aws_amplify_app.team_app.default_domain
}

output "amplify_branch_name" {
  description = "The name of the Amplify branch"
  value       = aws_amplify_branch.main.branch_name
}

output "amplify_branch_arn" {
  description = "The ARN of the Amplify branch"
  value       = aws_amplify_branch.main.arn
}

output "amplify_role_arn" {
  description = "The ARN of the Amplify service role"
  value       = aws_iam_role.amplify_role.arn
}

output "trigger_build_lambda_arn" {
  description = "The ARN of the Lambda function that triggers Amplify builds"
  value       = aws_lambda_function.trigger_build.arn
}

output "trigger_build_lambda_name" {
  description = "The name of the Lambda function that triggers Amplify builds"
  value       = aws_lambda_function.trigger_build.function_name
}
