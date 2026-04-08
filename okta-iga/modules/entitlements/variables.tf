# =============================================================================
# [Narrative] Entitlements Module — Variables
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

variable "enable_entitlement_discovery" {
  description = "Enable automatic discovery of application entitlements"
  type        = bool
  default     = null
}

variable "entitlement_sync_interval_hours" {
  description = "Hours between entitlement catalog sync"
  type        = number
  default     = null
}

variable "enable_entitlement_bundles" {
  description = "Enable grouping entitlements into role-based bundles"
  type        = bool
  default     = null
}

variable "entitlement_bundles" {
  description = "Predefined entitlement bundles"
  type = list(object({
    name         = string
    description  = string
    entitlements = list(string)
  }))
  default = []
}

locals {
  profile_defaults = {
    standard = {
      enable_entitlement_discovery    = true
      entitlement_sync_interval_hours = 24
      enable_entitlement_bundles      = false
    }
    elevated = {
      enable_entitlement_discovery    = true
      entitlement_sync_interval_hours = 12
      enable_entitlement_bundles      = true
    }
    strict = {
      enable_entitlement_discovery    = true
      entitlement_sync_interval_hours = 6
      enable_entitlement_bundles      = true
    }
  }

  effective = {
    enable_entitlement_discovery    = var.enable_entitlement_discovery != null ? var.enable_entitlement_discovery : local.profile_defaults[var.risk_profile].enable_entitlement_discovery
    entitlement_sync_interval_hours = coalesce(var.entitlement_sync_interval_hours, local.profile_defaults[var.risk_profile].entitlement_sync_interval_hours)
    enable_entitlement_bundles      = var.enable_entitlement_bundles != null ? var.enable_entitlement_bundles : local.profile_defaults[var.risk_profile].enable_entitlement_bundles
  }
}
