# =============================================================================
# Narrative Terraform Modules — Okta Identity Governance (OIG)
# Root composition — wires all governance modules together
# =============================================================================
# Modules will be added as they are built.
# Each module receives var.risk_profile and optional overrides.

module "governance_policies" {
  source       = "./modules/governance-policies"
  risk_profile = var.risk_profile

  enable_request_policy       = var.enable_request_policy
  enable_certification_policy = var.enable_certification_policy
  request_policy_action       = var.request_policy_action
  certification_policy_action = var.certification_policy_action
}

module "access_requests" {
  source       = "./modules/access-requests"
  risk_profile = var.risk_profile

  enable_self_service_requests    = var.enable_self_service_requests
  request_justification_required  = var.request_justification_required
  request_ticket_required         = var.request_ticket_required
  max_request_duration_days       = var.max_request_duration_days
  enable_slack_requests           = var.enable_slack_requests
  enable_teams_requests           = var.enable_teams_requests
  slack_webhook_url               = var.slack_webhook_url
  teams_webhook_url               = var.teams_webhook_url
}

module "certifications" {
  source       = "./modules/certifications"
  risk_profile = var.risk_profile

  certification_frequency       = var.certification_frequency
  certification_duration_days   = var.certification_duration_days
  reviewer_type                 = var.reviewer_type
  auto_revoke_on_failure        = var.auto_revoke_on_failure
  enable_micro_certifications   = var.enable_micro_certifications
  reminder_days_before_deadline = var.reminder_days_before_deadline
}

module "entitlements" {
  source       = "./modules/entitlements"
  risk_profile = var.risk_profile

  enable_entitlement_discovery    = var.enable_entitlement_discovery
  entitlement_sync_interval_hours = var.entitlement_sync_interval_hours
  enable_entitlement_bundles      = var.enable_entitlement_bundles
  entitlement_bundles             = var.entitlement_bundles
}

module "approval_workflows" {
  source       = "./modules/approval-workflows"
  risk_profile = var.risk_profile

  approval_levels        = var.approval_levels
  approval_timeout_hours = var.approval_timeout_hours
  enable_escalation      = var.enable_escalation
  escalation_target      = var.escalation_target
  enable_delegation      = var.enable_delegation
  timeout_action         = var.timeout_action
}

module "resource_catalog" {
  source       = "./modules/resource-catalog"
  risk_profile = var.risk_profile

  enable_resource_catalog = var.enable_resource_catalog
  catalog_visibility      = var.catalog_visibility
  require_descriptions    = var.require_descriptions
  catalog_items           = var.catalog_items
}

module "audit_reports" {
  source       = "./modules/audit-reports"
  risk_profile = var.risk_profile

  enable_scheduled_reports    = var.enable_scheduled_reports
  report_frequency            = var.report_frequency
  report_recipients           = var.report_recipients
  enable_compliance_dashboard = var.enable_compliance_dashboard
  enable_siem_export          = var.enable_siem_export
  siem_endpoint               = var.siem_endpoint
}

module "lifecycle_rules" {
  source       = "./modules/lifecycle-rules"
  risk_profile = var.risk_profile

  default_access_duration_days = var.default_access_duration_days
  max_access_duration_days     = var.max_access_duration_days
  enable_auto_expiration       = var.enable_auto_expiration
  enable_extension_workflow    = var.enable_extension_workflow
  extension_reminder_days      = var.extension_reminder_days
  max_extensions               = var.max_extensions
}

module "separation_of_duties" {
  source       = "./modules/separation-of-duties"
  risk_profile = var.risk_profile

  enable_sod_policies                = var.enable_sod_policies
  sod_violation_action               = var.sod_violation_action
  enable_toxic_combination_detection = var.enable_toxic_combination_detection
  sod_rules                          = var.sod_rules
}

module "notifications" {
  source       = "./modules/notifications"
  risk_profile = var.risk_profile

  enable_email_notifications     = var.enable_email_notifications
  enable_digest_notifications    = var.enable_digest_notifications
  digest_frequency               = var.digest_frequency
  reminder_escalation_hours      = var.reminder_escalation_hours
  custom_notification_templates  = var.custom_notification_templates
}

module "integrations" {
  source       = "./modules/integrations"
  risk_profile = var.risk_profile

  enable_servicenow_integration = var.enable_servicenow_integration
  servicenow_instance_url       = var.servicenow_instance_url
  servicenow_api_credential     = var.servicenow_api_credential
  enable_jira_integration       = var.enable_jira_integration
  jira_instance_url             = var.jira_instance_url
  jira_api_token                = var.jira_api_token
  enable_slack_approvals        = var.enable_slack_approvals
  enable_teams_approvals        = var.enable_teams_approvals
  slack_approval_webhook_url    = var.slack_approval_webhook_url
  teams_approval_webhook_url    = var.teams_approval_webhook_url
  enable_siem_forwarding        = var.enable_siem_forwarding
  siem_forwarding_endpoint      = var.siem_forwarding_endpoint
}
