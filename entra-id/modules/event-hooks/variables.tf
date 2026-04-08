# =============================================================================
# [Narrative] Event Hooks Module — Variables
# Diagnostic settings for audit and sign-in log streaming.
#
# Entra ID equivalent of Okta event hooks. Instead of webhook endpoints,
# Entra ID uses Azure Monitor diagnostic settings to stream logs to:
# - Log Analytics workspace (for querying and alerting)
# - Storage account (for long-term archival and compliance)
# - Event Hub (for SIEM integration — not managed here)
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — controls which log streams are enabled by default."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

# -----------------------------------------------------------------------------
# Log Stream Enable Overrides
# -----------------------------------------------------------------------------

variable "enable_audit_log_streaming" {
  description = "Enable audit log diagnostic settings (directory changes, policy changes, role assignments)"
  type        = bool
  default     = null
}

variable "enable_sign_in_log_streaming" {
  description = "Enable sign-in log diagnostic settings (interactive, non-interactive, service principal sign-ins)"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Log Destinations
# -----------------------------------------------------------------------------

variable "log_analytics_workspace_id" {
  description = "Azure Log Analytics workspace ID for log streaming. Required if either log stream is enabled."
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "Azure Storage Account ID for log archival. Optional — provides long-term retention."
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      enable_audit_log_streaming   = false
      enable_sign_in_log_streaming = false
    }
    elevated = {
      enable_audit_log_streaming   = true
      enable_sign_in_log_streaming = false
    }
    strict = {
      enable_audit_log_streaming   = true
      enable_sign_in_log_streaming = true
    }
  }

  # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
  effective = {
    enable_audit_log_streaming   = var.enable_audit_log_streaming != null ? var.enable_audit_log_streaming : local.profile_defaults[var.risk_profile].enable_audit_log_streaming
    enable_sign_in_log_streaming = var.enable_sign_in_log_streaming != null ? var.enable_sign_in_log_streaming : local.profile_defaults[var.risk_profile].enable_sign_in_log_streaming
  }
}
