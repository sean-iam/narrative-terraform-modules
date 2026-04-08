# =============================================================================
# [Narrative] Integrations Module
# Ticketing (ServiceNow, Jira), messaging (Slack, Teams), and SIEM
# integrations for Okta Identity Governance.
#
# Terraform support: PARTIAL
# Event hooks for Slack, Teams, and SIEM forwarding are fully supported
# via okta_event_hook. ServiceNow and Jira integrations require the
# OIG Governance API or Okta Workflows for bidirectional ticket sync.
# This module creates event hooks for outbound notifications and
# documents the required API configuration for ticketing.
#
# Risk profile philosophy:
# - Standard: No integrations enabled by default (opt-in)
# - Elevated: No integrations enabled by default (opt-in)
# - Strict: SIEM forwarding enabled by default (all others opt-in)
# Ticketing and messaging are environment-specific — not risk-driven.
# =============================================================================

# -----------------------------------------------------------------------------
# ServiceNow Integration
# Bidirectional ticket sync requires Okta Workflows or the OIG
# Governance API. This event hook provides outbound event forwarding.
# Full integration (ticket creation, status sync) needs additional setup.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "servicenow" {
  count = local.effective.enable_servicenow_integration && var.servicenow_instance_url != null ? 1 : 0

  name = "[Narrative] ServiceNow Governance Integration"
  events = [
    "application.user_membership.add",
    "application.user_membership.remove",
    "group.user_membership.add",
    "group.user_membership.remove",
    "user.lifecycle.activate",
    "user.lifecycle.deactivate",
  ]

  channel = {
    type    = "HTTP"
    uri     = "${var.servicenow_instance_url}/api/now/table/incident"
    version = "1.0.0"
  }

  // NOTE: This event hook provides one-way event forwarding to ServiceNow.
  // For full bidirectional integration (auto-create tickets on access
  // requests, sync ticket status back to OIG), configure via:
  // - Okta Workflows: ServiceNow connector
  // - OIG Governance API: PUT /api/v1/governance/integrations/servicenow
  // - ServiceNow: Okta Identity Governance spoke in IntegrationHub

  status = "ACTIVE"
}

# -----------------------------------------------------------------------------
# Jira Integration
# Same pattern as ServiceNow — outbound events via hook,
# full integration requires Okta Workflows or API config.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "jira" {
  count = local.effective.enable_jira_integration && var.jira_instance_url != null ? 1 : 0

  name = "[Narrative] Jira Governance Integration"
  events = [
    "application.user_membership.add",
    "application.user_membership.remove",
    "group.user_membership.add",
    "group.user_membership.remove",
    "user.lifecycle.activate",
    "user.lifecycle.deactivate",
  ]

  channel = {
    type    = "HTTP"
    uri     = "${var.jira_instance_url}/rest/api/3/issue"
    version = "1.0.0"
  }

  // NOTE: This event hook provides one-way event forwarding to Jira.
  // For full bidirectional integration (auto-create issues on access
  // requests, sync issue status back to OIG), configure via:
  // - Okta Workflows: Jira connector
  // - OIG Governance API: PUT /api/v1/governance/integrations/jira
  // - Jira: Okta Identity Governance app in Atlassian Marketplace

  status = "ACTIVE"
}

# -----------------------------------------------------------------------------
# Slack Interactive Approvals
# Sends approval requests as interactive Slack messages.
# Approvers can approve/deny directly from Slack.
# Requires Okta Workflows Slack connector for full interactivity.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "slack_approvals" {
  count = local.effective.enable_slack_approvals && var.slack_approval_webhook_url != null ? 1 : 0

  name = "[Narrative] Slack Approval Notifications"
  events = [
    "application.user_membership.add",
    "group.user_membership.add",
    "policy.lifecycle.update",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.slack_approval_webhook_url
    version = "1.0.0"
  }

  // NOTE: For interactive approve/deny buttons in Slack, configure
  // Okta Workflows with the Slack connector. This hook provides
  // notification-only forwarding. Interactive approvals require
  // a middleware endpoint that translates Slack actions back to
  // the OIG Governance API.

  status = "ACTIVE"
}

# -----------------------------------------------------------------------------
# Microsoft Teams Interactive Approvals
# Same pattern as Slack — notification hook with interactive
# approval requiring Okta Workflows or middleware.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "teams_approvals" {
  count = local.effective.enable_teams_approvals && var.teams_approval_webhook_url != null ? 1 : 0

  name = "[Narrative] Teams Approval Notifications"
  events = [
    "application.user_membership.add",
    "group.user_membership.add",
    "policy.lifecycle.update",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.teams_approval_webhook_url
    version = "1.0.0"
  }

  // NOTE: For interactive approve/deny cards in Teams, configure
  // Okta Workflows with the Microsoft Teams connector or Power Automate.
  // This hook provides notification-only forwarding.

  status = "ACTIVE"
}

# -----------------------------------------------------------------------------
# SIEM Event Forwarding
# Forwards all governance-related events to a SIEM endpoint.
# Complementary to the audit-reports module SIEM export — this
# integration focuses on real-time event streaming.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "siem_forwarding" {
  count = local.effective.enable_siem_forwarding && var.siem_forwarding_endpoint != null ? 1 : 0

  name = "[Narrative] Governance SIEM Forwarding"
  events = [
    "policy.lifecycle.create",
    "policy.lifecycle.update",
    "policy.lifecycle.delete",
    "application.lifecycle.create",
    "application.lifecycle.update",
    "application.lifecycle.delete",
    "application.user_membership.add",
    "application.user_membership.remove",
    "group.lifecycle.create",
    "group.lifecycle.update",
    "group.lifecycle.delete",
    "group.user_membership.add",
    "group.user_membership.remove",
    "user.lifecycle.activate",
    "user.lifecycle.deactivate",
    "user.lifecycle.suspend",
    "user.account.lock",
    "user.session.start",
    "user.mfa.factor.deactivate",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.siem_forwarding_endpoint
    version = "1.0.0"
  }

  status = "ACTIVE"
}
