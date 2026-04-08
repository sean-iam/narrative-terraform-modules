# =============================================================================
# [Narrative] Resource Catalog Module — Variables
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

variable "enable_resource_catalog" {
  description = "Enable the self-service resource catalog"
  type        = bool
  default     = null
}

variable "catalog_visibility" {
  description = "Default catalog visibility"
  type        = string
  default     = null

  validation {
    condition     = var.catalog_visibility == null || contains(["all_users", "role_based", "department_based"], var.catalog_visibility)
    error_message = "Must be all_users, role_based, or department_based."
  }
}

variable "require_descriptions" {
  description = "Require descriptions on all catalog items"
  type        = bool
  default     = null
}

variable "catalog_items" {
  description = "Applications and resources to publish in the catalog"
  type = list(object({
    name              = string
    description       = string
    app_id            = optional(string)
    owner_group_id    = optional(string)
    visibility        = optional(string, "all_users")
    requires_approval = optional(bool, true)
  }))
  default = []
}

locals {
  profile_defaults = {
    standard = {
      enable_resource_catalog = true
      catalog_visibility      = "all_users"
      require_descriptions    = false
    }
    elevated = {
      enable_resource_catalog = true
      catalog_visibility      = "role_based"
      require_descriptions    = true
    }
    strict = {
      enable_resource_catalog = true
      catalog_visibility      = "department_based"
      require_descriptions    = true
    }
  }

  effective = {
    enable_resource_catalog = var.enable_resource_catalog != null ? var.enable_resource_catalog : local.profile_defaults[var.risk_profile].enable_resource_catalog
    catalog_visibility      = coalesce(var.catalog_visibility, local.profile_defaults[var.risk_profile].catalog_visibility)
    require_descriptions    = var.require_descriptions != null ? var.require_descriptions : local.profile_defaults[var.risk_profile].require_descriptions
  }
}
