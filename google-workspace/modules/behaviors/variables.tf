# =============================================================================
# [Narrative] Behaviors Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — controls login challenge and recovery behavior."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

variable "enable_suspicious_login_challenge" {
  description = "Enable login challenges for suspicious activity"
  type        = bool
  default     = null
}

variable "account_recovery_method" {
  description = "Account recovery method — self_service, admin_only, or admin_verification"
  type        = string
  default     = null

  validation {
    condition     = var.account_recovery_method == null || contains(["self_service", "admin_only", "admin_verification"], var.account_recovery_method)
    error_message = "Must be self_service, admin_only, or admin_verification."
  }
}

variable "enable_less_secure_apps_block" {
  description = "Block less secure app access (legacy protocols that bypass 2SV)"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      enable_suspicious_login_challenge = true
      account_recovery_method           = "self_service"
      enable_less_secure_apps_block     = false
    }
    elevated = {
      enable_suspicious_login_challenge = true
      account_recovery_method           = "admin_only"
      enable_less_secure_apps_block     = true
    }
    strict = {
      enable_suspicious_login_challenge = true
      account_recovery_method           = "admin_verification"
      enable_less_secure_apps_block     = true
    }
  }

  effective = {
    # Use ternary for booleans — coalesce treats false as null
    enable_suspicious_login_challenge = var.enable_suspicious_login_challenge != null ? var.enable_suspicious_login_challenge : local.profile_defaults[var.risk_profile].enable_suspicious_login_challenge
    account_recovery_method           = coalesce(var.account_recovery_method, local.profile_defaults[var.risk_profile].account_recovery_method)
    enable_less_secure_apps_block     = var.enable_less_secure_apps_block != null ? var.enable_less_secure_apps_block : local.profile_defaults[var.risk_profile].enable_less_secure_apps_block
  }
}
