# =============================================================================
# [Narrative] Conditional Access Policies Module — Variables
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
  description = "Map of group names to object IDs"
  type        = map(string)
}

variable "trusted_location_id" {
  description = "Trusted named location ID (from network module). If null, location-based conditions are skipped."
  type        = string
  default     = null
}

variable "ofac_location_id" {
  description = "OFAC blocked countries named location ID (from network module)"
  type        = string
  default     = null
}

variable "high_risk_location_id" {
  description = "High-risk countries named location ID (from network module)"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Employee Session Overrides
# -----------------------------------------------------------------------------

variable "employee_sign_in_frequency_hours" {
  description = "Sign-in frequency in hours for employee accounts"
  type        = number
  default     = null
}

variable "persistent_browser_session" {
  description = "Allow persistent browser sessions for employees"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Admin Session Overrides
# -----------------------------------------------------------------------------

variable "admin_sign_in_frequency_hours" {
  description = "Sign-in frequency in hours for administrator accounts"
  type        = number
  default     = null
}

variable "require_mfa_for_admins" {
  description = "Require MFA for all admin role assignments"
  type        = bool
  default     = null
}

variable "require_mfa_for_all_users" {
  description = "Require MFA for all users"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Contractor Session Overrides
# -----------------------------------------------------------------------------

variable "contractor_sign_in_frequency_hours" {
  description = "Sign-in frequency in hours for contractor accounts"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Legacy Auth
# -----------------------------------------------------------------------------

variable "block_legacy_auth" {
  description = "Block legacy authentication protocols (IMAP, POP3, SMTP basic auth, etc.)"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      employee_sign_in_frequency_hours   = 24
      admin_sign_in_frequency_hours      = 4
      persistent_browser_session         = true
      require_mfa_for_admins             = true
      require_mfa_for_all_users          = true
      contractor_sign_in_frequency_hours = 8
      block_legacy_auth                  = true
    }
    elevated = {
      employee_sign_in_frequency_hours   = 12
      admin_sign_in_frequency_hours      = 2
      persistent_browser_session         = false
      require_mfa_for_admins             = true
      require_mfa_for_all_users          = true
      contractor_sign_in_frequency_hours = 4
      block_legacy_auth                  = true
    }
    strict = {
      employee_sign_in_frequency_hours   = 8
      admin_sign_in_frequency_hours      = 1
      persistent_browser_session         = false
      require_mfa_for_admins             = true
      require_mfa_for_all_users          = true
      contractor_sign_in_frequency_hours = 2
      block_legacy_auth                  = true
    }
  }

  effective = {
    employee_sign_in_frequency_hours   = coalesce(var.employee_sign_in_frequency_hours, local.profile_defaults[var.risk_profile].employee_sign_in_frequency_hours)
    admin_sign_in_frequency_hours      = coalesce(var.admin_sign_in_frequency_hours, local.profile_defaults[var.risk_profile].admin_sign_in_frequency_hours)
    # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
    persistent_browser_session         = var.persistent_browser_session != null ? var.persistent_browser_session : local.profile_defaults[var.risk_profile].persistent_browser_session
    require_mfa_for_admins             = var.require_mfa_for_admins != null ? var.require_mfa_for_admins : local.profile_defaults[var.risk_profile].require_mfa_for_admins
    require_mfa_for_all_users          = var.require_mfa_for_all_users != null ? var.require_mfa_for_all_users : local.profile_defaults[var.risk_profile].require_mfa_for_all_users
    contractor_sign_in_frequency_hours = coalesce(var.contractor_sign_in_frequency_hours, local.profile_defaults[var.risk_profile].contractor_sign_in_frequency_hours)
    block_legacy_auth                  = var.block_legacy_auth != null ? var.block_legacy_auth : local.profile_defaults[var.risk_profile].block_legacy_auth
  }
}
