# =============================================================================
# [Narrative] Login Policies Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — controls session durations and login challenge behavior."
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
# Session Duration Overrides
# -----------------------------------------------------------------------------

variable "session_duration_hours" {
  description = "Web session duration in hours for employees"
  type        = number
  default     = null
}

variable "admin_session_duration_hours" {
  description = "Admin console session duration in hours"
  type        = number
  default     = null
}

variable "enable_login_challenge" {
  description = "Enable login challenges for suspicious activity"
  type        = bool
  default     = null
}

variable "require_reauth_for_sensitive" {
  description = "Require re-authentication for sensitive actions (security settings, app passwords)"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      session_duration_hours           = 12
      admin_session_duration_hours     = 8
      contractor_session_duration_hours = 8
      break_glass_session_hours        = 4
      enable_login_challenge           = true
      require_reauth_for_sensitive     = false
    }
    elevated = {
      session_duration_hours           = 8
      admin_session_duration_hours     = 4
      contractor_session_duration_hours = 4
      break_glass_session_hours        = 2
      enable_login_challenge           = true
      require_reauth_for_sensitive     = true
    }
    strict = {
      session_duration_hours           = 4
      admin_session_duration_hours     = 2
      contractor_session_duration_hours = 2
      break_glass_session_hours        = 1
      enable_login_challenge           = true
      require_reauth_for_sensitive     = true
    }
  }

  effective = {
    session_duration_hours           = coalesce(var.session_duration_hours, local.profile_defaults[var.risk_profile].session_duration_hours)
    admin_session_duration_hours     = coalesce(var.admin_session_duration_hours, local.profile_defaults[var.risk_profile].admin_session_duration_hours)
    contractor_session_duration_hours = local.profile_defaults[var.risk_profile].contractor_session_duration_hours
    break_glass_session_hours        = local.profile_defaults[var.risk_profile].break_glass_session_hours
    # Use ternary for booleans — coalesce treats false as null
    enable_login_challenge           = var.enable_login_challenge != null ? var.enable_login_challenge : local.profile_defaults[var.risk_profile].enable_login_challenge
    require_reauth_for_sensitive     = var.require_reauth_for_sensitive != null ? var.require_reauth_for_sensitive : local.profile_defaults[var.risk_profile].require_reauth_for_sensitive
  }
}
