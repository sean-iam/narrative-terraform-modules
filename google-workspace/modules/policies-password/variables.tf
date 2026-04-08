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

variable "password_reuse_count" {
  description = "Number of previous passwords users cannot reuse"
  type        = number
  default     = null
}

variable "password_enforce_strong" {
  description = "Enforce strong password requirements (mixed case, numbers, symbols)"
  type        = bool
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
  description = "Maximum password age in days for administrator accounts"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      password_min_length         = 12
      password_max_age_days       = 90
      password_reuse_count        = 8
      password_enforce_strong     = true
      admin_password_min_length   = 14
      admin_password_max_age_days = 60
    }
    elevated = {
      password_min_length         = 14
      password_max_age_days       = 60
      password_reuse_count        = 12
      password_enforce_strong     = true
      admin_password_min_length   = 16
      admin_password_max_age_days = 45
    }
    strict = {
      password_min_length         = 16
      password_max_age_days       = 45
      password_reuse_count        = 24
      password_enforce_strong     = true
      admin_password_min_length   = 18
      admin_password_max_age_days = 30
    }
  }

  effective = {
    password_min_length         = coalesce(var.password_min_length, local.profile_defaults[var.risk_profile].password_min_length)
    password_max_age_days       = coalesce(var.password_max_age_days, local.profile_defaults[var.risk_profile].password_max_age_days)
    password_reuse_count        = coalesce(var.password_reuse_count, local.profile_defaults[var.risk_profile].password_reuse_count)
    admin_password_min_length   = coalesce(var.admin_password_min_length, local.profile_defaults[var.risk_profile].admin_password_min_length)
    admin_password_max_age_days = coalesce(var.admin_password_max_age_days, local.profile_defaults[var.risk_profile].admin_password_max_age_days)
    # Use ternary for booleans — coalesce treats false as null
    password_enforce_strong     = var.password_enforce_strong != null ? var.password_enforce_strong : local.profile_defaults[var.risk_profile].password_enforce_strong
  }
}
