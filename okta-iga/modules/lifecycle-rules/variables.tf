# =============================================================================
# [Narrative] Lifecycle Rules Module — Variables
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

variable "default_access_duration_days" {
  description = "Default duration for time-bound access grants"
  type        = number
  default     = null
}

variable "max_access_duration_days" {
  description = "Maximum allowed access duration"
  type        = number
  default     = null
}

variable "enable_auto_expiration" {
  description = "Automatically expire access after duration"
  type        = bool
  default     = null
}

variable "enable_extension_workflow" {
  description = "Allow users to request access extensions"
  type        = bool
  default     = null
}

variable "extension_reminder_days" {
  description = "Days before expiration to send extension reminder"
  type        = number
  default     = null
}

variable "max_extensions" {
  description = "Maximum number of extensions per access grant"
  type        = number
  default     = null
}

locals {
  profile_defaults = {
    standard = {
      default_access_duration_days = 90
      max_access_duration_days     = 365
      enable_auto_expiration       = true
      enable_extension_workflow    = true
      extension_reminder_days      = 14
      max_extensions               = 4
    }
    elevated = {
      default_access_duration_days = 60
      max_access_duration_days     = 180
      enable_auto_expiration       = true
      enable_extension_workflow    = true
      extension_reminder_days      = 10
      max_extensions               = 2
    }
    strict = {
      default_access_duration_days = 30
      max_access_duration_days     = 90
      enable_auto_expiration       = true
      enable_extension_workflow    = true
      extension_reminder_days      = 7
      max_extensions               = 1
    }
  }

  effective = {
    default_access_duration_days = coalesce(var.default_access_duration_days, local.profile_defaults[var.risk_profile].default_access_duration_days)
    max_access_duration_days     = coalesce(var.max_access_duration_days, local.profile_defaults[var.risk_profile].max_access_duration_days)
    enable_auto_expiration       = var.enable_auto_expiration != null ? var.enable_auto_expiration : local.profile_defaults[var.risk_profile].enable_auto_expiration
    enable_extension_workflow    = var.enable_extension_workflow != null ? var.enable_extension_workflow : local.profile_defaults[var.risk_profile].enable_extension_workflow
    extension_reminder_days      = coalesce(var.extension_reminder_days, local.profile_defaults[var.risk_profile].extension_reminder_days)
    max_extensions               = coalesce(var.max_extensions, local.profile_defaults[var.risk_profile].max_extensions)
  }
}
