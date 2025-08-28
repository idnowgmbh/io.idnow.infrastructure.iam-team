# ============================================================================
# TEAM Infrastructure Variables
# ============================================================================

# ----------------------------------------------------------------------------
# KMS and Security
# ----------------------------------------------------------------------------

variable "kms_key_arn" {
  description = "KMS key ARN for encryption"
  type        = string
}

# ----------------------------------------------------------------------------
# TEAM Application Configuration
# ----------------------------------------------------------------------------

variable "sso_login_url" {
  description = "IAM Identity Center Login URL"
  type        = string
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

variable "cloudtrail_audit_logs" {
  description = "Which events should be logged on the TEAM Application Cloudtrail Lake EventDataStore"
  type        = string
  default     = "read_write"
  validation {
    condition = contains(["read_write", "read", "write", "none"], var.cloudtrail_audit_logs) || can(regex("^arn:.*", var.cloudtrail_audit_logs))
    error_message = "Acceptable values are 'read', 'write', 'read_write', 'none', or an ARN of an existing Cloudtrail Lake EDS."
  }
}

# ----------------------------------------------------------------------------
# Amplify Configuration
# ----------------------------------------------------------------------------

variable "custom_amplify_domain" {
  description = "Custom domain for the TEAM application"
  type        = string
  default     = ""
}

variable "custom_repository" {
  description = "Use a custom repository for the TEAM application?"
  type        = string
  default     = "No"
  validation {
    condition     = contains(["Yes", "No"], var.custom_repository)
    error_message = "Allowed values are 'Yes' or 'No'."
  }
}

variable "repository_url" {
  description = "Custom repository URL (when custom_repository is Yes)"
  type        = string
  default     = ""
}

variable "repository_access_token" {
  description = "Access token for custom repository (when custom_repository is Yes)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "custom_repository_secret_name" {
  description = "Name of the secret in AWS Secrets Manager for custom repository"
  type        = string
  default     = ""
}
