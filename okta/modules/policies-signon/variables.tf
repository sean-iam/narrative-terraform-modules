# =============================================================================
# [Narrative] Sign-On Policies Module — Variables
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

variable "group_ids" {
  description = "Map of group names to IDs"
  type        = map(string)
}

variable "trusted_zone_id" {
  description = "Trusted network zone ID (from network module). If null, network restrictions are skipped."
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Employee Session Overrides
# -----------------------------------------------------------------------------

variable "employee_idle_timeout_minutes" {
  description = "Idle session timeout in minutes for employee accounts"
  type        = number
  default     = null
}

variable "max_session_lifetime_minutes" {
  description = "Maximum session lifetime in minutes before forced re-authentication"
  type        = number
  default     = null
}

variable "mfa_prompt_mode" {
  description = "MFA prompt behavior — DEVICE (remember device), SESSION (per session), or ALWAYS (every request)"
  type        = string
  default     = null
}

variable "mfa_remember_device" {
  description = "Whether to allow MFA device remembering (reduces prompt frequency)"
  type        = bool
  default     = null
}

variable "mfa_lifetime_minutes" {
  description = "How long a remembered MFA device is trusted before re-prompting (0 = every session)"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Admin Session Overrides
# -----------------------------------------------------------------------------

variable "admin_idle_timeout_minutes" {
  description = "Idle session timeout in minutes for administrator accounts"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Contractor Session Overrides
# -----------------------------------------------------------------------------

variable "contractor_idle_timeout_minutes" {
  description = "Idle session timeout in minutes for contractor accounts"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Break Glass Session Overrides
# -----------------------------------------------------------------------------

variable "break_glass_max_session_minutes" {
  description = "Maximum session lifetime in minutes for break glass emergency accounts"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      employee_idle_timeout_minutes   = 60
      admin_idle_timeout_minutes      = 30
      max_session_lifetime_minutes    = 1440
      mfa_prompt_mode                 = "DEVICE"
      mfa_remember_device             = true
      mfa_lifetime_minutes            = 43200
      contractor_idle_timeout_minutes = 30
      break_glass_max_session_minutes = 30
    }
    elevated = {
      employee_idle_timeout_minutes   = 30
      admin_idle_timeout_minutes      = 15
      max_session_lifetime_minutes    = 720
      mfa_prompt_mode                 = "ALWAYS"
      mfa_remember_device             = false
      mfa_lifetime_minutes            = 0
      contractor_idle_timeout_minutes = 30
      break_glass_max_session_minutes = 15
    }
    strict = {
      employee_idle_timeout_minutes   = 15
      admin_idle_timeout_minutes      = 10
      max_session_lifetime_minutes    = 480
      mfa_prompt_mode                 = "ALWAYS"
      mfa_remember_device             = false
      mfa_lifetime_minutes            = 0
      contractor_idle_timeout_minutes = 15
      break_glass_max_session_minutes = 15
    }
  }

  effective = {
    employee_idle_timeout_minutes   = coalesce(var.employee_idle_timeout_minutes, local.profile_defaults[var.risk_profile].employee_idle_timeout_minutes)
    admin_idle_timeout_minutes      = coalesce(var.admin_idle_timeout_minutes, local.profile_defaults[var.risk_profile].admin_idle_timeout_minutes)
    max_session_lifetime_minutes    = coalesce(var.max_session_lifetime_minutes, local.profile_defaults[var.risk_profile].max_session_lifetime_minutes)
    mfa_prompt_mode                 = coalesce(var.mfa_prompt_mode, local.profile_defaults[var.risk_profile].mfa_prompt_mode)
    # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
    mfa_remember_device             = var.mfa_remember_device != null ? var.mfa_remember_device : local.profile_defaults[var.risk_profile].mfa_remember_device
    mfa_lifetime_minutes            = coalesce(var.mfa_lifetime_minutes, local.profile_defaults[var.risk_profile].mfa_lifetime_minutes)
    contractor_idle_timeout_minutes = coalesce(var.contractor_idle_timeout_minutes, local.profile_defaults[var.risk_profile].contractor_idle_timeout_minutes)
    break_glass_max_session_minutes = coalesce(var.break_glass_max_session_minutes, local.profile_defaults[var.risk_profile].break_glass_max_session_minutes)
  }
}
