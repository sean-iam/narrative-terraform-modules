# =============================================================================
# [Narrative] Groups Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier"
  type        = string
  default     = "standard"
}

variable "org_display_name" {
  description = "Organization display name for group descriptions"
  type        = string
}

variable "enable_department_groups" {
  description = "Create department-based groups with dynamic membership rules"
  type        = bool
  default     = null # Resolved by risk_profile
}

variable "departments" {
  description = "List of departments to create groups for. Each department gets a security group with a dynamic membership rule based on the department attribute."
  type        = list(string)
  default     = ["Engineering", "Finance", "Human Resources", "IT Operations", "Sales", "Customer Support", "Legal & Compliance"]
}

variable "enable_contractor_group" {
  description = "Create a contractors group with dynamic membership rule"
  type        = bool
  default     = true
}

variable "enable_executive_group" {
  description = "Create an executive leadership group"
  type        = bool
  default     = true
}

variable "enable_geo_exception_groups" {
  description = "Create geo-blocking exception groups (OFAC and Non-OFAC)"
  type        = bool
  default     = true
}

variable "custom_groups" {
  description = "Additional custom groups to create"
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}

locals {
  profile_defaults = {
    standard = {
      enable_department_groups = true
    }
    elevated = {
      enable_department_groups = true
    }
    strict = {
      enable_department_groups = true
    }
  }

  # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
  effective = {
    enable_department_groups = var.enable_department_groups != null ? var.enable_department_groups : local.profile_defaults[var.risk_profile].enable_department_groups
  }
}
