variable "env" {
  description = "Environment name (sbx, prd)"
  type        = string
}

variable "sso_login_url" {
  description = "IAM IDC Login URL"
  type        = string
}

variable "cloudtrail_audit_logs" {
  description = "Which events should be logged on the TEAM Application Cloudtrail Lake EventDataStore"
  type        = string
  default     = "read_write"
  validation {
    condition = contains(["read_write", "read", "write", "none"], var.cloudtrail_audit_logs) || can(regex("^arn:.*", var.cloudtrail_audit_logs))
    error_message = "Acceptable values are 'read', 'write', 'read_write', 'none', or an ARN of an existing Cloudtrail Lake EDS."
  }
}

variable "team_admin_group" {
  description = "TEAM application Admin group"
  type        = string
}

variable "team_audit_group" {
  description = "TEAM application Auditor group"
  type        = string
}

variable "team_account_id" {
  description = "TEAM deployment account ID"
  type        = string
}

variable "custom_amplify_domain" {
  description = "Custom domain for the TEAM application"
  type        = string
  default     = ""
}

# Repository variables removed - using manual deployment approach

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "tags_json" {
  description = "Tags as JSON string for environment variables"
  type        = string
  default     = ""
}
