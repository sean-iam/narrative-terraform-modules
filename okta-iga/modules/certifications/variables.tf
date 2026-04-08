# =============================================================================
# [Narrative] Certifications Module — Variables
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

variable "certification_frequency" {
  description = "How often certification campaigns run"
  type        = string
  default     = null

  validation {
    condition     = var.certification_frequency == null || contains(["quarterly", "monthly", "weekly", "continuous"], var.certification_frequency)
    error_message = "Must be quarterly, monthly, weekly, or continuous."
  }
}

variable "certification_duration_days" {
  description = "Days reviewers have to complete a certification campaign"
  type        = number
  default     = null
}

variable "reviewer_type" {
  description = "Default reviewer assignment"
  type        = string
  default     = null

  validation {
    condition     = var.reviewer_type == null || contains(["manager", "app_owner", "custom"], var.reviewer_type)
    error_message = "Must be manager, app_owner, or custom."
  }
}

variable "auto_revoke_on_failure" {
  description = "Auto-revoke access on certification failure or non-response"
  type        = bool
  default     = null
}

variable "enable_micro_certifications" {
  description = "Enable event-driven micro-certifications on role changes"
  type        = bool
  default     = null
}

variable "reminder_days_before_deadline" {
  description = "Days before deadline to send reviewer reminder"
  type        = number
  default     = null
}

locals {
  profile_defaults = {
    standard = {
      certification_frequency       = "quarterly"
      certification_duration_days   = 14
      reviewer_type                 = "manager"
      auto_revoke_on_failure        = false
      enable_micro_certifications   = false
      reminder_days_before_deadline = 5
    }
    elevated = {
      certification_frequency       = "monthly"
      certification_duration_days   = 10
      reviewer_type                 = "manager"
      auto_revoke_on_failure        = true
      enable_micro_certifications   = true
      reminder_days_before_deadline = 3
    }
    strict = {
      certification_frequency       = "continuous"
      certification_duration_days   = 7
      reviewer_type                 = "manager"
      auto_revoke_on_failure        = true
      enable_micro_certifications   = true
      reminder_days_before_deadline = 2
    }
  }

  effective = {
    certification_frequency       = coalesce(var.certification_frequency, local.profile_defaults[var.risk_profile].certification_frequency)
    certification_duration_days   = coalesce(var.certification_duration_days, local.profile_defaults[var.risk_profile].certification_duration_days)
    reviewer_type                 = coalesce(var.reviewer_type, local.profile_defaults[var.risk_profile].reviewer_type)
    auto_revoke_on_failure        = var.auto_revoke_on_failure != null ? var.auto_revoke_on_failure : local.profile_defaults[var.risk_profile].auto_revoke_on_failure
    enable_micro_certifications   = var.enable_micro_certifications != null ? var.enable_micro_certifications : local.profile_defaults[var.risk_profile].enable_micro_certifications
    reminder_days_before_deadline = coalesce(var.reminder_days_before_deadline, local.profile_defaults[var.risk_profile].reminder_days_before_deadline)
  }
}
