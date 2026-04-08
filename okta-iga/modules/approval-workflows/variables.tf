# =============================================================================
# [Narrative] Approval Workflows Module — Variables
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

variable "approval_levels" {
  description = "Number of approval levels required"
  type        = number
  default     = null

  validation {
    condition     = var.approval_levels == null || (var.approval_levels >= 1 && var.approval_levels <= 3)
    error_message = "Must be 1, 2, or 3."
  }
}

variable "approval_timeout_hours" {
  description = "Hours before an approval request times out"
  type        = number
  default     = null
}

variable "enable_escalation" {
  description = "Enable automatic escalation on timeout"
  type        = bool
  default     = null
}

variable "escalation_target" {
  description = "Who receives escalated approvals"
  type        = string
  default     = null

  validation {
    condition     = var.escalation_target == null || contains(["manager_of_approver", "app_owner", "governance_admin"], var.escalation_target)
    error_message = "Must be manager_of_approver, app_owner, or governance_admin."
  }
}

variable "enable_delegation" {
  description = "Allow approvers to delegate their approval authority"
  type        = bool
  default     = null
}

variable "timeout_action" {
  description = "Action when approval times out without escalation"
  type        = string
  default     = null

  validation {
    condition     = var.timeout_action == null || contains(["deny", "auto_approve"], var.timeout_action)
    error_message = "Must be deny or auto_approve."
  }
}

locals {
  profile_defaults = {
    standard = {
      approval_levels        = 1
      approval_timeout_hours = 72
      enable_escalation      = false
      escalation_target      = "manager_of_approver"
      enable_delegation      = true
      timeout_action         = "deny"
    }
    elevated = {
      approval_levels        = 2
      approval_timeout_hours = 48
      enable_escalation      = true
      escalation_target      = "app_owner"
      enable_delegation      = true
      timeout_action         = "deny"
    }
    strict = {
      approval_levels        = 3
      approval_timeout_hours = 24
      enable_escalation      = true
      escalation_target      = "governance_admin"
      enable_delegation      = false
      timeout_action         = "deny"
    }
  }

  effective = {
    approval_levels        = coalesce(var.approval_levels, local.profile_defaults[var.risk_profile].approval_levels)
    approval_timeout_hours = coalesce(var.approval_timeout_hours, local.profile_defaults[var.risk_profile].approval_timeout_hours)
    enable_escalation      = var.enable_escalation != null ? var.enable_escalation : local.profile_defaults[var.risk_profile].enable_escalation
    escalation_target      = coalesce(var.escalation_target, local.profile_defaults[var.risk_profile].escalation_target)
    enable_delegation      = var.enable_delegation != null ? var.enable_delegation : local.profile_defaults[var.risk_profile].enable_delegation
    timeout_action         = coalesce(var.timeout_action, local.profile_defaults[var.risk_profile].timeout_action)
  }
}
