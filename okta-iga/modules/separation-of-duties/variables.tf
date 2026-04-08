# =============================================================================
# [Narrative] Separation of Duties Module — Variables
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

variable "enable_sod_policies" {
  description = "Enable separation of duties policy enforcement"
  type        = bool
  default     = null
}

variable "sod_violation_action" {
  description = "Action on SoD violation"
  type        = string
  default     = null

  validation {
    condition     = var.sod_violation_action == null || contains(["warn", "block", "block_with_override"], var.sod_violation_action)
    error_message = "Must be warn, block, or block_with_override."
  }
}

variable "enable_toxic_combination_detection" {
  description = "Enable detection of toxic entitlement combinations"
  type        = bool
  default     = null
}

variable "sod_rules" {
  description = "SoD rules defining incompatible entitlement pairs"
  type = list(object({
    name              = string
    description       = string
    entitlement_a     = string
    entitlement_b     = string
    action            = optional(string)
    allow_override    = optional(bool, false)
    override_approver = optional(string)
  }))
  default = []
}

locals {
  profile_defaults = {
    standard = {
      enable_sod_policies                = true
      sod_violation_action               = "warn"
      enable_toxic_combination_detection = false
    }
    elevated = {
      enable_sod_policies                = true
      sod_violation_action               = "block_with_override"
      enable_toxic_combination_detection = true
    }
    strict = {
      enable_sod_policies                = true
      sod_violation_action               = "block"
      enable_toxic_combination_detection = true
    }
  }

  effective = {
    enable_sod_policies                = var.enable_sod_policies != null ? var.enable_sod_policies : local.profile_defaults[var.risk_profile].enable_sod_policies
    sod_violation_action               = coalesce(var.sod_violation_action, local.profile_defaults[var.risk_profile].sod_violation_action)
    enable_toxic_combination_detection = var.enable_toxic_combination_detection != null ? var.enable_toxic_combination_detection : local.profile_defaults[var.risk_profile].enable_toxic_combination_detection
  }
}
