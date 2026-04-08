# =============================================================================
# [Narrative] Password Policies Module — Variables
#
# Note: Entra ID handles password policies differently than Okta. There is a
# single tenant-wide password policy (not per-group). Custom banned password
# lists and smart lockout are the primary controls. Password complexity is
# enforced at the Azure AD level (minimum 8 chars, complexity always on).
# The min_length variables here map to the organizational minimum guidance
# enforced via Conditional Access + password protection, not a direct API field.
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
  description = "Recommended minimum password length (enforced via user guidance and Conditional Access; Entra ID enforces 8-char minimum natively)"
  type        = number
  default     = null
}

variable "password_max_age_days" {
  description = "Maximum password age in days before expiration (0 to disable; Entra ID default is 90 days)"
  type        = number
  default     = null
}

variable "password_history_count" {
  description = "Number of previous passwords users cannot reuse (Entra ID supports up to 24)"
  type        = number
  default     = null
}

variable "password_lockout_attempts" {
  description = "Failed sign-in attempts before smart lockout triggers"
  type        = number
  default     = null
}

variable "password_lockout_duration_seconds" {
  description = "Duration in seconds before a locked account auto-unlocks (Entra ID smart lockout)"
  type        = number
  default     = null
}

variable "enable_banned_password_list" {
  description = "Enable the custom banned password list (Azure AD Password Protection)"
  type        = bool
  default     = null
}

variable "banned_passwords" {
  description = "Custom banned password list entries (up to 1000 words)"
  type        = list(string)
  default     = []
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
      password_lockout_attempts         = 10
      password_lockout_duration_seconds = 60
      enable_banned_password_list       = true
    }
    elevated = {
      password_min_length               = 14
      password_max_age_days             = 60
      password_history_count            = 12
      password_lockout_attempts         = 5
      password_lockout_duration_seconds = 120
      enable_banned_password_list       = true
    }
    strict = {
      password_min_length               = 16
      password_max_age_days             = 0
      password_history_count            = 24
      password_lockout_attempts         = 3
      password_lockout_duration_seconds = 300
      enable_banned_password_list       = true
    }
  }

  effective = {
    password_min_length               = coalesce(var.password_min_length, local.profile_defaults[var.risk_profile].password_min_length)
    password_max_age_days             = coalesce(var.password_max_age_days, local.profile_defaults[var.risk_profile].password_max_age_days)
    password_history_count            = coalesce(var.password_history_count, local.profile_defaults[var.risk_profile].password_history_count)
    password_lockout_attempts         = coalesce(var.password_lockout_attempts, local.profile_defaults[var.risk_profile].password_lockout_attempts)
    password_lockout_duration_seconds = coalesce(var.password_lockout_duration_seconds, local.profile_defaults[var.risk_profile].password_lockout_duration_seconds)
    # Use ternary for booleans — coalesce treats false as null
    enable_banned_password_list       = var.enable_banned_password_list != null ? var.enable_banned_password_list : local.profile_defaults[var.risk_profile].enable_banned_password_list
  }
}
