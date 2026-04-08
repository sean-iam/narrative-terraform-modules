# =============================================================================
# [Narrative] Auth Server Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — controls token lifetimes."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

# -----------------------------------------------------------------------------
# App Registration Configuration
# -----------------------------------------------------------------------------

variable "app_registration_name" {
  description = "Display name for the app registration (API)"
  type        = string
  default     = "Narrative API"
}

variable "app_registration_description" {
  description = "Description for the app registration"
  type        = string
  default     = "Custom API app registration"
}

variable "api_scopes" {
  description = "List of custom OAuth2 scopes to expose on the app registration"
  type        = list(string)
  default     = ["read", "write", "admin"]
}

# -----------------------------------------------------------------------------
# Token Lifetime Overrides
# -----------------------------------------------------------------------------

variable "access_token_lifetime_minutes" {
  description = "Access token lifetime in minutes"
  type        = number
  default     = null
}

variable "id_token_lifetime_minutes" {
  description = "ID token lifetime in minutes"
  type        = number
  default     = null
}

variable "refresh_token_lifetime_days" {
  description = "Refresh token lifetime in days"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      access_token_lifetime_minutes = 60
      id_token_lifetime_minutes     = 60
      refresh_token_lifetime_days   = 30
    }
    elevated = {
      access_token_lifetime_minutes = 30
      id_token_lifetime_minutes     = 30
      refresh_token_lifetime_days   = 14
    }
    strict = {
      access_token_lifetime_minutes = 15
      id_token_lifetime_minutes     = 15
      refresh_token_lifetime_days   = 7
    }
  }

  effective = {
    access_token_lifetime_minutes = coalesce(var.access_token_lifetime_minutes, local.profile_defaults[var.risk_profile].access_token_lifetime_minutes)
    id_token_lifetime_minutes     = coalesce(var.id_token_lifetime_minutes, local.profile_defaults[var.risk_profile].id_token_lifetime_minutes)
    refresh_token_lifetime_days   = coalesce(var.refresh_token_lifetime_days, local.profile_defaults[var.risk_profile].refresh_token_lifetime_days)
  }

  # Convert to ISO 8601 duration format for token lifetime policy
  access_token_duration = "PT${local.effective.access_token_lifetime_minutes}M"
  id_token_duration     = "PT${local.effective.id_token_lifetime_minutes}M"
}
