# =============================================================================
# [Narrative] Access Requests Module — Variables
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

variable "enable_self_service_requests" {
  description = "Allow end users to request access through the Okta dashboard"
  type        = bool
  default     = null
}

variable "request_justification_required" {
  description = "Require business justification on all access requests"
  type        = bool
  default     = null
}

variable "request_ticket_required" {
  description = "Require a ticket number on access requests"
  type        = bool
  default     = null
}

variable "max_request_duration_days" {
  description = "Maximum duration in days for a single access request"
  type        = number
  default     = null
}

variable "enable_slack_requests" {
  description = "Enable Slack integration for request notifications"
  type        = bool
  default     = null
}

variable "enable_teams_requests" {
  description = "Enable Microsoft Teams integration for request notifications"
  type        = bool
  default     = null
}

variable "slack_webhook_url" {
  description = "Slack incoming webhook URL for request notifications"
  type        = string
  default     = null
}

variable "teams_webhook_url" {
  description = "Microsoft Teams incoming webhook URL for request notifications"
  type        = string
  default     = null
}

locals {
  profile_defaults = {
    standard = {
      enable_self_service_requests    = true
      request_justification_required  = false
      request_ticket_required         = false
      max_request_duration_days       = 90
      enable_slack_requests           = false
      enable_teams_requests           = false
    }
    elevated = {
      enable_self_service_requests    = true
      request_justification_required  = true
      request_ticket_required         = false
      max_request_duration_days       = 60
      enable_slack_requests           = false
      enable_teams_requests           = false
    }
    strict = {
      enable_self_service_requests    = true
      request_justification_required  = true
      request_ticket_required         = true
      max_request_duration_days       = 30
      enable_slack_requests           = false
      enable_teams_requests           = false
    }
  }

  effective = {
    enable_self_service_requests    = var.enable_self_service_requests != null ? var.enable_self_service_requests : local.profile_defaults[var.risk_profile].enable_self_service_requests
    request_justification_required  = var.request_justification_required != null ? var.request_justification_required : local.profile_defaults[var.risk_profile].request_justification_required
    request_ticket_required         = var.request_ticket_required != null ? var.request_ticket_required : local.profile_defaults[var.risk_profile].request_ticket_required
    max_request_duration_days       = coalesce(var.max_request_duration_days, local.profile_defaults[var.risk_profile].max_request_duration_days)
    enable_slack_requests           = var.enable_slack_requests != null ? var.enable_slack_requests : local.profile_defaults[var.risk_profile].enable_slack_requests
    enable_teams_requests           = var.enable_teams_requests != null ? var.enable_teams_requests : local.profile_defaults[var.risk_profile].enable_teams_requests
  }
}
