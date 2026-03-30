# =============================================================================
# [Narrative] Password Policies Module — Variables
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
  description = "Map of group names to IDs from the groups module"
  type        = map(string)
}

# -----------------------------------------------------------------------------
# Password Policy Overrides
# -----------------------------------------------------------------------------

variable "password_min_length" {
  description = "Minimum password length for end users"
  type        = number
  default     = null
}

variable "password_max_age_days" {
  description = "Maximum password age in days before rotation is required (set to 0 to disable rotation)"
  type        = number
  default     = null
}

variable "password_history_count" {
  description = "Number of previous passwords users cannot reuse"
  type        = number
  default     = null
}

variable "password_lockout_attempts" {
  description = "Number of failed login attempts before account lockout"
  type        = number
  default     = null
}

variable "password_lockout_duration_minutes" {
  description = "Duration in minutes before a locked account is automatically unlocked"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Admin Password Policy Overrides
# -----------------------------------------------------------------------------

variable "admin_password_min_length" {
  description = "Minimum password length for administrator accounts"
  type        = number
  default     = null
}

variable "admin_password_max_age_days" {
  description = "Maximum password age in days for administrator accounts before rotation is required"
  type        = number
  default     = null
}

variable "enable_lockout_admin_notification" {
  description = "Send admin notification when an account is locked out"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      password_min_length               = 12
      password_max_age_days             = 90
      password_history_count            = 8
      password_lockout_attempts         = 5
      password_lockout_duration_minutes = 30
      admin_password_min_length         = 14
      admin_password_max_age_days       = 60
      enable_lockout_admin_notification = false
    }
    elevated = {
      password_min_length               = 14
      password_max_age_days             = 60
      password_history_count            = 12
      password_lockout_attempts         = 3
      password_lockout_duration_minutes = 60
      admin_password_min_length         = 16
      admin_password_max_age_days       = 45
      enable_lockout_admin_notification = false
    }
    strict = {
      password_min_length               = 16
      password_max_age_days             = 45
      password_history_count            = 24
      password_lockout_attempts         = 3
      password_lockout_duration_minutes = 60
      admin_password_min_length         = 18
      admin_password_max_age_days       = 30
      enable_lockout_admin_notification = true
    }
  }

  effective = {
    password_min_length               = coalesce(var.password_min_length, local.profile_defaults[var.risk_profile].password_min_length)
    password_max_age_days             = coalesce(var.password_max_age_days, local.profile_defaults[var.risk_profile].password_max_age_days)
    password_history_count            = coalesce(var.password_history_count, local.profile_defaults[var.risk_profile].password_history_count)
    password_lockout_attempts         = coalesce(var.password_lockout_attempts, local.profile_defaults[var.risk_profile].password_lockout_attempts)
    password_lockout_duration_minutes = coalesce(var.password_lockout_duration_minutes, local.profile_defaults[var.risk_profile].password_lockout_duration_minutes)
    admin_password_min_length         = coalesce(var.admin_password_min_length, local.profile_defaults[var.risk_profile].admin_password_min_length)
    admin_password_max_age_days       = coalesce(var.admin_password_max_age_days, local.profile_defaults[var.risk_profile].admin_password_max_age_days)
    # Use ternary for booleans — coalesce treats false as null
    enable_lockout_admin_notification = var.enable_lockout_admin_notification != null ? var.enable_lockout_admin_notification : local.profile_defaults[var.risk_profile].enable_lockout_admin_notification
  }
}
