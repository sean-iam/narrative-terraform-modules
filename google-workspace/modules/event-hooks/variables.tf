# =============================================================================
# [Narrative] Event Hooks Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — controls which alert rules are enabled by default."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

# -----------------------------------------------------------------------------
# Alert Enable Overrides
# -----------------------------------------------------------------------------

variable "enable_security_alerts" {
  description = "Enable security alert rules (suspicious logins, device compromises)"
  type        = bool
  default     = null
}

variable "enable_admin_activity_alerts" {
  description = "Enable admin activity alert rules (user/group/setting changes)"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Alert Configuration
# -----------------------------------------------------------------------------

variable "alert_notification_email" {
  description = "Email address for security alert notifications"
  type        = string
  default     = null
}

variable "audit_log_export_enabled" {
  description = "Enable audit log export to BigQuery or Cloud Storage"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      enable_security_alerts      = false
      enable_admin_activity_alerts = false
    }
    elevated = {
      enable_security_alerts      = true
      enable_admin_activity_alerts = false
    }
    strict = {
      enable_security_alerts      = true
      enable_admin_activity_alerts = true
    }
  }

  # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
  effective = {
    enable_security_alerts      = var.enable_security_alerts != null ? var.enable_security_alerts : local.profile_defaults[var.risk_profile].enable_security_alerts
    enable_admin_activity_alerts = var.enable_admin_activity_alerts != null ? var.enable_admin_activity_alerts : local.profile_defaults[var.risk_profile].enable_admin_activity_alerts
  }
}
