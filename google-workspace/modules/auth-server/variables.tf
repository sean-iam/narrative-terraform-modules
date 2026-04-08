# =============================================================================
# [Narrative] Auth Server Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — controls OAuth and delegation settings."
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
# OAuth / Third-Party App Overrides
# -----------------------------------------------------------------------------

variable "enable_third_party_apps" {
  description = "Allow third-party OAuth app access"
  type        = bool
  default     = null
}

variable "enable_domain_wide_delegation" {
  description = "Allow domain-wide delegation for service accounts"
  type        = bool
  default     = null
}

variable "api_client_access" {
  description = "API client access level — open, restricted, or locked"
  type        = string
  default     = null

  validation {
    condition     = var.api_client_access == null || contains(["open", "restricted", "locked"], var.api_client_access)
    error_message = "Must be open, restricted, or locked."
  }
}

variable "trusted_apps" {
  description = "List of trusted OAuth app client IDs that are always allowed"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      enable_third_party_apps       = true
      enable_domain_wide_delegation = true
      api_client_access             = "open"
    }
    elevated = {
      enable_third_party_apps       = false
      enable_domain_wide_delegation = true
      api_client_access             = "restricted"
    }
    strict = {
      enable_third_party_apps       = false
      enable_domain_wide_delegation = false
      api_client_access             = "locked"
    }
  }

  effective = {
    # Use ternary for booleans — coalesce treats false as null
    enable_third_party_apps       = var.enable_third_party_apps != null ? var.enable_third_party_apps : local.profile_defaults[var.risk_profile].enable_third_party_apps
    enable_domain_wide_delegation = var.enable_domain_wide_delegation != null ? var.enable_domain_wide_delegation : local.profile_defaults[var.risk_profile].enable_domain_wide_delegation
    api_client_access             = coalesce(var.api_client_access, local.profile_defaults[var.risk_profile].api_client_access)
  }
}
