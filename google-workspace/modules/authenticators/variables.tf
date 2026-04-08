# =============================================================================
# [Narrative] Authenticators Module — Variables
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

variable "two_sv_enforcement" {
  description = "2-Step Verification enforcement level"
  type        = string
  default     = null

  validation {
    condition     = var.two_sv_enforcement == null || contains(["optional", "enforced", "enforced_keys_only"], var.two_sv_enforcement)
    error_message = "Must be optional, enforced, or enforced_keys_only."
  }
}

variable "allowed_two_sv_methods" {
  description = "Allowed 2SV methods"
  type        = string
  default     = null

  validation {
    condition     = var.allowed_two_sv_methods == null || contains(["any", "prompt_and_keys", "security_keys_only"], var.allowed_two_sv_methods)
    error_message = "Must be any, prompt_and_keys, or security_keys_only."
  }
}

variable "two_sv_grace_period_days" {
  description = "Grace period in days before 2SV is required for new users"
  type        = number
  default     = null
}

variable "enable_security_keys_only" {
  description = "Require only security keys (no phone-based 2SV)"
  type        = bool
  default     = null
}

locals {
  profile_defaults = {
    standard = {
      two_sv_enforcement       = "optional"
      allowed_two_sv_methods   = "any"
      two_sv_grace_period_days = 14
      enable_security_keys_only = false
    }
    elevated = {
      two_sv_enforcement       = "enforced"
      allowed_two_sv_methods   = "prompt_and_keys"
      two_sv_grace_period_days = 7
      enable_security_keys_only = false
    }
    strict = {
      two_sv_enforcement       = "enforced_keys_only"
      allowed_two_sv_methods   = "security_keys_only"
      two_sv_grace_period_days = 3
      enable_security_keys_only = true
    }
  }

  effective = {
    two_sv_enforcement       = coalesce(var.two_sv_enforcement, local.profile_defaults[var.risk_profile].two_sv_enforcement)
    allowed_two_sv_methods   = coalesce(var.allowed_two_sv_methods, local.profile_defaults[var.risk_profile].allowed_two_sv_methods)
    two_sv_grace_period_days = coalesce(var.two_sv_grace_period_days, local.profile_defaults[var.risk_profile].two_sv_grace_period_days)
    # Use ternary for booleans — coalesce treats false as null
    enable_security_keys_only = var.enable_security_keys_only != null ? var.enable_security_keys_only : local.profile_defaults[var.risk_profile].enable_security_keys_only
  }
}
