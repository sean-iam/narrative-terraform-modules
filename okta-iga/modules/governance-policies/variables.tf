# =============================================================================
# [Narrative] Governance Policies Module — Variables
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

variable "enable_request_policy" {
  description = "Enable the access request governance policy"
  type        = bool
  default     = null
}

variable "enable_certification_policy" {
  description = "Enable the access certification governance policy"
  type        = bool
  default     = null
}

variable "request_policy_action" {
  description = "Default action for access request policy"
  type        = string
  default     = null

  validation {
    condition     = var.request_policy_action == null || contains(["allow", "require_approval", "deny"], var.request_policy_action)
    error_message = "Must be allow, require_approval, or deny."
  }
}

variable "certification_policy_action" {
  description = "Default action when certification fails"
  type        = string
  default     = null

  validation {
    condition     = var.certification_policy_action == null || contains(["revoke", "flag", "notify"], var.certification_policy_action)
    error_message = "Must be revoke, flag, or notify."
  }
}

locals {
  profile_defaults = {
    standard = {
      enable_request_policy       = true
      enable_certification_policy = true
      request_policy_action       = "require_approval"
      certification_policy_action = "notify"
    }
    elevated = {
      enable_request_policy       = true
      enable_certification_policy = true
      request_policy_action       = "require_approval"
      certification_policy_action = "flag"
    }
    strict = {
      enable_request_policy       = true
      enable_certification_policy = true
      request_policy_action       = "require_approval"
      certification_policy_action = "revoke"
    }
  }

  effective = {
    enable_request_policy       = var.enable_request_policy != null ? var.enable_request_policy : local.profile_defaults[var.risk_profile].enable_request_policy
    enable_certification_policy = var.enable_certification_policy != null ? var.enable_certification_policy : local.profile_defaults[var.risk_profile].enable_certification_policy
    request_policy_action       = coalesce(var.request_policy_action, local.profile_defaults[var.risk_profile].request_policy_action)
    certification_policy_action = coalesce(var.certification_policy_action, local.profile_defaults[var.risk_profile].certification_policy_action)
  }
}
