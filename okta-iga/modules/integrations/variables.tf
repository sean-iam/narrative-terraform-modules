# =============================================================================
# [Narrative] Integrations Module — Variables
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

variable "enable_servicenow_integration" {
  description = "Enable ServiceNow ticketing integration"
  type        = bool
  default     = null
}

variable "servicenow_instance_url" {
  description = "ServiceNow instance URL"
  type        = string
  default     = null
}

variable "servicenow_api_credential" {
  description = "ServiceNow API credential"
  type        = string
  default     = null
  sensitive   = true
}

variable "enable_jira_integration" {
  description = "Enable Jira ticketing integration"
  type        = bool
  default     = null
}

variable "jira_instance_url" {
  description = "Jira instance URL"
  type        = string
  default     = null
}

variable "jira_api_token" {
  description = "Jira API token"
  type        = string
  default     = null
  sensitive   = true
}

variable "enable_slack_approvals" {
  description = "Enable Slack for interactive approval workflows"
  type        = bool
  default     = null
}

variable "enable_teams_approvals" {
  description = "Enable Microsoft Teams for interactive approval workflows"
  type        = bool
  default     = null
}

variable "slack_approval_webhook_url" {
  description = "Slack webhook URL for interactive approval messages"
  type        = string
  default     = null
}

variable "teams_approval_webhook_url" {
  description = "Microsoft Teams webhook URL for interactive approval messages"
  type        = string
  default     = null
}

variable "enable_siem_forwarding" {
  description = "Enable SIEM forwarding of governance events"
  type        = bool
  default     = null
}

variable "siem_forwarding_endpoint" {
  description = "HTTPS endpoint for SIEM event forwarding"
  type        = string
  default     = null
}

locals {
  profile_defaults = {
    standard = {
      enable_servicenow_integration = false
      enable_jira_integration       = false
      enable_slack_approvals        = false
      enable_teams_approvals        = false
      enable_siem_forwarding        = false
    }
    elevated = {
      enable_servicenow_integration = false
      enable_jira_integration       = false
      enable_slack_approvals        = false
      enable_teams_approvals        = false
      enable_siem_forwarding        = false
    }
    strict = {
      enable_servicenow_integration = false
      enable_jira_integration       = false
      enable_slack_approvals        = false
      enable_teams_approvals        = false
      enable_siem_forwarding        = true
    }
  }

  effective = {
    enable_servicenow_integration = var.enable_servicenow_integration != null ? var.enable_servicenow_integration : local.profile_defaults[var.risk_profile].enable_servicenow_integration
    enable_jira_integration       = var.enable_jira_integration != null ? var.enable_jira_integration : local.profile_defaults[var.risk_profile].enable_jira_integration
    enable_slack_approvals        = var.enable_slack_approvals != null ? var.enable_slack_approvals : local.profile_defaults[var.risk_profile].enable_slack_approvals
    enable_teams_approvals        = var.enable_teams_approvals != null ? var.enable_teams_approvals : local.profile_defaults[var.risk_profile].enable_teams_approvals
    enable_siem_forwarding        = var.enable_siem_forwarding != null ? var.enable_siem_forwarding : local.profile_defaults[var.risk_profile].enable_siem_forwarding
  }
}
