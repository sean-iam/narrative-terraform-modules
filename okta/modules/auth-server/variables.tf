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

variable "group_ids" {
  description = "Map of group names to IDs (from groups module)"
  type        = map(string)
}

# -----------------------------------------------------------------------------
# Auth Server Configuration
# -----------------------------------------------------------------------------

variable "auth_server_name" {
  description = "Name for the custom authorization server"
  type        = string
  default     = "custom"
}

variable "auth_server_description" {
  description = "Description for the custom authorization server"
  type        = string
  default     = "Custom authorization server"
}

variable "scopes" {
  description = "List of custom scopes to create"
  type        = list(string)
  default     = ["read", "write", "admin"]
}

# -----------------------------------------------------------------------------
# Token Lifetime Overrides
# -----------------------------------------------------------------------------

variable "access_token_lifetime_minutes" {
  description = "Access token lifetime in minutes for internal app policy"
  type        = number
  default     = null
}

variable "refresh_token_lifetime_days" {
  description = "Refresh token lifetime in days for internal app policy"
  type        = number
  default     = null
}

variable "service_token_lifetime_minutes" {
  description = "Access token lifetime in minutes for service-to-service policy"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      access_token_lifetime_minutes  = 60
      refresh_token_lifetime_days    = 30
      service_token_lifetime_minutes = 60
    }
    elevated = {
      access_token_lifetime_minutes  = 30
      refresh_token_lifetime_days    = 14
      service_token_lifetime_minutes = 30
    }
    strict = {
      access_token_lifetime_minutes  = 15
      refresh_token_lifetime_days    = 7
      service_token_lifetime_minutes = 15
    }
  }

  effective = {
    access_token_lifetime_minutes  = coalesce(var.access_token_lifetime_minutes, local.profile_defaults[var.risk_profile].access_token_lifetime_minutes)
    refresh_token_lifetime_days    = coalesce(var.refresh_token_lifetime_days, local.profile_defaults[var.risk_profile].refresh_token_lifetime_days)
    service_token_lifetime_minutes = coalesce(var.service_token_lifetime_minutes, local.profile_defaults[var.risk_profile].service_token_lifetime_minutes)
  }
}
