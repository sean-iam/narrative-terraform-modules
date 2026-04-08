# =============================================================================
# Narrative Terraform Modules — Okta Identity Governance (OIG)
# Top-level variables passed to all modules
# =============================================================================

# -----------------------------------------------------------------------------
# Provider
# -----------------------------------------------------------------------------

variable "okta_org_name" {
  description = "Okta org name (e.g., 'dev-12345' from dev-12345.okta.com)"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL (okta.com, oktapreview.com, or okta-emea.com)"
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token with Super Admin privileges and Governance API scopes"
  type        = string
  sensitive   = true
}

# -----------------------------------------------------------------------------
# Organization
# -----------------------------------------------------------------------------

variable "org_display_name" {
  description = "Organization display name used in governance policies and notifications"
  type        = string
}

# -----------------------------------------------------------------------------
# Risk Profile
# -----------------------------------------------------------------------------

variable "risk_profile" {
  description = "Risk profile tier — sets defaults for all governance modules. Standard is quarterly certs with single approval, Elevated adds monthly certs and two-level approval, Strict enforces continuous certs and three-level approval with full audit trails."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

# -----------------------------------------------------------------------------
# Governance Policies Module Overrides
# -----------------------------------------------------------------------------

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
  description = "Default action for access request policy — allow, require_approval, or deny"
  type        = string
  default     = null
}

variable "certification_policy_action" {
  description = "Default action when certification fails — revoke, flag, or notify"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Access Requests Module Overrides
# -----------------------------------------------------------------------------

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
  description = "Require a ticket number (ServiceNow, Jira) on access requests"
  type        = bool
  default     = null
}

variable "max_request_duration_days" {
  description = "Maximum duration in days for a single access request"
  type        = number
  default     = null
}

variable "enable_slack_requests" {
  description = "Enable Slack integration for access request notifications"
  type        = bool
  default     = null
}

variable "enable_teams_requests" {
  description = "Enable Microsoft Teams integration for access request notifications"
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

# -----------------------------------------------------------------------------
# Certifications Module Overrides
# -----------------------------------------------------------------------------

variable "certification_frequency" {
  description = "How often access certification campaigns run — quarterly, monthly, weekly, or continuous"
  type        = string
  default     = null
}

variable "certification_duration_days" {
  description = "Number of days reviewers have to complete a certification campaign"
  type        = number
  default     = null
}

variable "reviewer_type" {
  description = "Default reviewer assignment — manager, app_owner, or custom"
  type        = string
  default     = null
}

variable "auto_revoke_on_failure" {
  description = "Automatically revoke access when certification is not completed or denied"
  type        = bool
  default     = null
}

variable "enable_micro_certifications" {
  description = "Enable event-driven micro-certifications on role changes or new assignments"
  type        = bool
  default     = null
}

variable "reminder_days_before_deadline" {
  description = "Days before certification deadline to send reminder"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Entitlements Module Overrides
# -----------------------------------------------------------------------------

variable "enable_entitlement_discovery" {
  description = "Enable automatic discovery of application entitlements"
  type        = bool
  default     = null
}

variable "entitlement_sync_interval_hours" {
  description = "Hours between entitlement catalog sync from connected applications"
  type        = number
  default     = null
}

variable "enable_entitlement_bundles" {
  description = "Enable grouping entitlements into role-based bundles"
  type        = bool
  default     = null
}

variable "entitlement_bundles" {
  description = "Predefined entitlement bundles mapping role names to sets of application entitlements"
  type = list(object({
    name         = string
    description  = string
    entitlements = list(string)
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Approval Workflows Module Overrides
# -----------------------------------------------------------------------------

variable "approval_levels" {
  description = "Number of approval levels required — 1, 2, or 3"
  type        = number
  default     = null
}

variable "approval_timeout_hours" {
  description = "Hours before an approval request times out and escalates"
  type        = number
  default     = null
}

variable "enable_escalation" {
  description = "Enable automatic escalation when approval times out"
  type        = bool
  default     = null
}

variable "escalation_target" {
  description = "Who receives escalated approvals — manager_of_approver, app_owner, or governance_admin"
  type        = string
  default     = null
}

variable "enable_delegation" {
  description = "Allow approvers to delegate their approval authority"
  type        = bool
  default     = null
}

variable "timeout_action" {
  description = "Action when approval times out without escalation — deny or auto_approve"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Resource Catalog Module Overrides
# -----------------------------------------------------------------------------

variable "enable_resource_catalog" {
  description = "Enable the self-service resource catalog for requestable items"
  type        = bool
  default     = null
}

variable "catalog_visibility" {
  description = "Default catalog visibility — all_users, role_based, or department_based"
  type        = string
  default     = null
}

variable "require_descriptions" {
  description = "Require descriptions on all catalog items"
  type        = bool
  default     = null
}

variable "catalog_items" {
  description = "Applications and resources to publish in the self-service catalog"
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

# -----------------------------------------------------------------------------
# Audit Reports Module Overrides
# -----------------------------------------------------------------------------

variable "enable_scheduled_reports" {
  description = "Enable scheduled governance reports"
  type        = bool
  default     = null
}

variable "report_frequency" {
  description = "How often governance reports are generated — weekly, monthly, or quarterly"
  type        = string
  default     = null
}

variable "report_recipients" {
  description = "Email addresses to receive scheduled governance reports"
  type        = list(string)
  default     = []
}

variable "enable_compliance_dashboard" {
  description = "Enable the governance compliance dashboard"
  type        = bool
  default     = null
}

variable "enable_siem_export" {
  description = "Enable SIEM export of governance audit events"
  type        = bool
  default     = null
}

variable "siem_endpoint" {
  description = "HTTPS endpoint for SIEM event export"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Lifecycle Rules Module Overrides
# -----------------------------------------------------------------------------

variable "default_access_duration_days" {
  description = "Default duration in days for time-bound access grants"
  type        = number
  default     = null
}

variable "max_access_duration_days" {
  description = "Maximum allowed access duration in days"
  type        = number
  default     = null
}

variable "enable_auto_expiration" {
  description = "Automatically expire access grants after their duration"
  type        = bool
  default     = null
}

variable "enable_extension_workflow" {
  description = "Allow users to request access extensions before expiration"
  type        = bool
  default     = null
}

variable "extension_reminder_days" {
  description = "Days before expiration to send extension reminder"
  type        = number
  default     = null
}

variable "max_extensions" {
  description = "Maximum number of extensions allowed per access grant"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Separation of Duties Module Overrides
# -----------------------------------------------------------------------------

variable "enable_sod_policies" {
  description = "Enable separation of duties policy enforcement"
  type        = bool
  default     = null
}

variable "sod_violation_action" {
  description = "Action on SoD violation — warn, block, or block_with_override"
  type        = string
  default     = null
}

variable "enable_toxic_combination_detection" {
  description = "Enable detection of toxic entitlement combinations"
  type        = bool
  default     = null
}

variable "sod_rules" {
  description = "Separation of duties rules defining incompatible entitlement pairs"
  type = list(object({
    name             = string
    description      = string
    entitlement_a    = string
    entitlement_b    = string
    action           = optional(string)
    allow_override   = optional(bool, false)
    override_approver = optional(string)
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Notifications Module Overrides
# -----------------------------------------------------------------------------

variable "enable_email_notifications" {
  description = "Enable email notifications for governance events"
  type        = bool
  default     = null
}

variable "enable_digest_notifications" {
  description = "Send digest summaries instead of individual notifications"
  type        = bool
  default     = null
}

variable "digest_frequency" {
  description = "Digest notification frequency — daily or weekly"
  type        = string
  default     = null
}

variable "reminder_escalation_hours" {
  description = "Hours before sending escalation reminder for pending actions"
  type        = number
  default     = null
}

variable "custom_notification_templates" {
  description = "Custom notification template overrides"
  type = list(object({
    event_type = string
    subject    = string
    body       = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Integrations Module Overrides
# -----------------------------------------------------------------------------

variable "enable_servicenow_integration" {
  description = "Enable ServiceNow ticketing integration"
  type        = bool
  default     = null
}

variable "servicenow_instance_url" {
  description = "ServiceNow instance URL (e.g., https://company.service-now.com)"
  type        = string
  default     = null
}

variable "servicenow_api_credential" {
  description = "ServiceNow API credential for ticket creation"
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
  description = "Jira instance URL (e.g., https://company.atlassian.net)"
  type        = string
  default     = null
}

variable "jira_api_token" {
  description = "Jira API token for ticket creation"
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
