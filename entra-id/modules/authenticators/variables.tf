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

variable "mfa_method" {
  description = "Primary MFA method for end users"
  type        = string
  default     = null

  validation {
    condition     = var.mfa_method == null || contains(["microsoft_authenticator_push", "microsoft_authenticator_number", "fido2"], var.mfa_method)
    error_message = "Must be microsoft_authenticator_push, microsoft_authenticator_number, or fido2."
  }
}

variable "enable_fido2" {
  description = "Enable FIDO2 security keys as an authentication method"
  type        = bool
  default     = null
}

variable "enable_email_otp" {
  description = "Enable email OTP as an authentication method"
  type        = bool
  default     = true
}

variable "enable_phone_sms" {
  description = "Enable phone SMS as an authentication method"
  type        = bool
  default     = null
}

locals {
  profile_defaults = {
    standard = {
      mfa_method       = "microsoft_authenticator_push"
      enable_fido2     = false
      enable_phone_sms = true
    }
    elevated = {
      mfa_method       = "microsoft_authenticator_number"
      enable_fido2     = true
      enable_phone_sms = false
    }
    strict = {
      mfa_method       = "fido2"
      enable_fido2     = true
      enable_phone_sms = false
    }
  }

  effective = {
    mfa_method       = coalesce(var.mfa_method, local.profile_defaults[var.risk_profile].mfa_method)
    # Use ternary for booleans — coalesce treats false as null
    enable_fido2     = var.enable_fido2 != null ? var.enable_fido2 : local.profile_defaults[var.risk_profile].enable_fido2
    enable_phone_sms = var.enable_phone_sms != null ? var.enable_phone_sms : local.profile_defaults[var.risk_profile].enable_phone_sms
  }
}
