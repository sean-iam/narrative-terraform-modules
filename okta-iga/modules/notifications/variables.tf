# =============================================================================
# [Narrative] Notifications Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

variable "enable_email_notifications" {
  description = "Enable email notifications for governance events"
  type        = bool
  default     = null
}

variable "enable_digest_notifications" {
  description = "Send digest summaries instead of individual notifications"
  type        = bool
  default     = null
}

variable "digest_frequency" {
  description = "Digest notification frequency"
  type        = string
  default     = null

  validation {
    condition     = var.digest_frequency == null || contains(["daily", "weekly"], var.digest_frequency)
    error_message = "Must be daily or weekly."
  }
}

variable "reminder_escalation_hours" {
  description = "Hours before sending escalation reminder for pending actions"
  type        = number
  default     = null
}

variable "custom_notification_templates" {
  description = "Custom notification template overrides"
  type = list(object({
    event_type = string
    subject    = string
    body       = string
  }))
  default = []
}

locals {
  profile_defaults = {
    standard = {
      enable_email_notifications  = true
      enable_digest_notifications = true
      digest_frequency            = "weekly"
      reminder_escalation_hours   = 48
    }
    elevated = {
      enable_email_notifications  = true
      enable_digest_notifications = false
      digest_frequency            = "daily"
      reminder_escalation_hours   = 24
    }
    strict = {
      enable_email_notifications  = true
      enable_digest_notifications = false
      digest_frequency            = "daily"
      reminder_escalation_hours   = 12
    }
  }

  effective = {
    enable_email_notifications  = var.enable_email_notifications != null ? var.enable_email_notifications : local.profile_defaults[var.risk_profile].enable_email_notifications
    enable_digest_notifications = var.enable_digest_notifications != null ? var.enable_digest_notifications : local.profile_defaults[var.risk_profile].enable_digest_notifications
    digest_frequency            = coalesce(var.digest_frequency, local.profile_defaults[var.risk_profile].digest_frequency)
    reminder_escalation_hours   = coalesce(var.reminder_escalation_hours, local.profile_defaults[var.risk_profile].reminder_escalation_hours)
  }
}
