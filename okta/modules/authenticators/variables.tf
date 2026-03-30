# =============================================================================
# [Narrative] Authenticators Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier"
  type        = string
  default     = "standard"
}

variable "mfa_method" {
  description = "Primary MFA method for end users"
  type        = string
  default     = null

  validation {
    condition     = var.mfa_method == null || contains(["okta_verify_push", "okta_verify_number", "webauthn_fido2"], var.mfa_method)
    error_message = "Must be okta_verify_push, okta_verify_number, or webauthn_fido2."
  }
}

variable "enable_webauthn" {
  description = "Enable WebAuthn/FIDO2 authenticator"
  type        = bool
  default     = null
}

variable "enable_email_recovery" {
  description = "Enable email as a recovery authenticator"
  type        = bool
  default     = true
}

variable "email_token_lifetime_minutes" {
  description = "Email recovery token lifetime in minutes"
  type        = number
  default     = 5
}

locals {
  profile_defaults = {
    standard = {
      mfa_method      = "okta_verify_push"
      enable_webauthn = false
    }
    elevated = {
      mfa_method      = "okta_verify_number"
      enable_webauthn = true
    }
    strict = {
      mfa_method      = "webauthn_fido2"
      enable_webauthn = true
    }
  }

  effective = {
    mfa_method      = coalesce(var.mfa_method, local.profile_defaults[var.risk_profile].mfa_method)
    # Use ternary for booleans — coalesce treats false as null
    enable_webauthn = var.enable_webauthn != null ? var.enable_webauthn : local.profile_defaults[var.risk_profile].enable_webauthn
  }
}
