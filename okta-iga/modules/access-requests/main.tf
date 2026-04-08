# =============================================================================
# [Narrative] Access Requests Module
# Access request configuration, self-service settings, and
# messaging integration for Okta Identity Governance.
#
# Terraform support: PARTIAL
# OIG Access Requests are configured primarily through the Okta Admin UI
# and the Governance API (v2024.06+). The Terraform provider does not yet
# have dedicated okta_governance_request_* resources. This module uses
# okta_policy and okta_policy_rule to create the policy framework, with
# comments noting where manual/API configuration is required.
#
# Risk profile philosophy:
# - Standard: Self-service enabled, no justification required, 90-day max
# - Elevated: Justification required on all requests, 60-day max
# - Strict: Justification + ticket number required, 30-day max duration
# =============================================================================

# -----------------------------------------------------------------------------
# Access Request Configuration Policy
# Defines the request workflow settings as a policy resource.
# Actual OIG request form configuration requires API v2024.06+.
# -----------------------------------------------------------------------------

resource "okta_policy" "access_request_config" {
  count = local.effective.enable_self_service_requests ? 1 : 0

  name        = "[Narrative] Access Request Configuration"
  description = "Self-service access request settings. Justification: ${local.effective.request_justification_required ? "required" : "optional"}. Ticket: ${local.effective.request_ticket_required ? "required" : "optional"}. Max duration: ${local.effective.max_request_duration_days} days."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 3
}

resource "okta_policy_rule" "self_service_rule" {
  count = local.effective.enable_self_service_requests ? 1 : 0

  policy_id = okta_policy.access_request_config[0].id
  name      = "[Narrative] Self-Service Request Rule"
  status    = "ACTIVE"
  priority  = 1

  // Requires Okta Governance API v2024.06+ for:
  // - request_justification_required
  // - request_ticket_required
  // - max_request_duration_days
  // - request_form_fields configuration
  // These properties are set via the OIG admin console or API until
  // the Terraform provider adds governance request resources.
}

# -----------------------------------------------------------------------------
# Slack Integration for Request Notifications
# Requires Okta Workflows or OIG native Slack integration.
# The event hook sends request lifecycle events to Slack.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "slack_requests" {
  count = local.effective.enable_slack_requests && var.slack_webhook_url != null ? 1 : 0

  name = "[Narrative] Access Request Slack Notifications"
  events = [
    "application.user_membership.add",
    "application.user_membership.remove",
    "group.user_membership.add",
    "group.user_membership.remove",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.slack_webhook_url
    version = "1.0.0"
  }

  status = "ACTIVE"
}

# -----------------------------------------------------------------------------
# Microsoft Teams Integration for Request Notifications
# Same pattern as Slack — event hook to Teams webhook.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "teams_requests" {
  count = local.effective.enable_teams_requests && var.teams_webhook_url != null ? 1 : 0

  name = "[Narrative] Access Request Teams Notifications"
  events = [
    "application.user_membership.add",
    "application.user_membership.remove",
    "group.user_membership.add",
    "group.user_membership.remove",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.teams_webhook_url
    version = "1.0.0"
  }

  status = "ACTIVE"
}
