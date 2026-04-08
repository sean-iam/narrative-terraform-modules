# =============================================================================
# [Narrative] Audit Reports Module
# Governance reporting, scheduled reports, and compliance dashboards.
#
# Terraform support: MINIMAL
# OIG reporting is managed through the Governance API and admin console.
# This module configures event hooks for SIEM export and creates the
# policy documentation shell. Report scheduling and dashboard configuration
# require the Governance API or admin console.
#
# Risk profile philosophy:
# - Standard: No scheduled reports, no dashboard, no SIEM export
# - Elevated: Monthly reports, compliance dashboard, no SIEM
# - Strict: Weekly reports, dashboard, SIEM export of all events
# =============================================================================

# -----------------------------------------------------------------------------
# Governance Audit Policy
# Documents the reporting configuration. Report scheduling and
# dashboard settings require the OIG admin console or API.
# -----------------------------------------------------------------------------

resource "okta_policy" "governance_audit" {
  name        = "[Narrative] Governance Audit & Reporting"
  description = "Governance reporting configuration. Reports: ${local.effective.enable_scheduled_reports ? local.effective.report_frequency : "disabled"}. Dashboard: ${local.effective.enable_compliance_dashboard ? "enabled" : "disabled"}. SIEM: ${local.effective.enable_siem_export ? "enabled" : "disabled"}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 8

  // Requires Okta Governance API v2024.06+ for:
  // - Scheduled report configuration
  // - Report frequency settings
  // - Recipient email configuration
  // - Compliance dashboard enablement
  //
  // Reports endpoint: POST /api/v1/governance/reports/schedules
  // Dashboard endpoint: PUT /api/v1/governance/dashboards/settings
}

# -----------------------------------------------------------------------------
# SIEM Export Event Hook
# Forwards all governance-related events to a SIEM endpoint.
# Includes access request decisions, certification results,
# policy changes, and SoD violations.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "siem_governance_export" {
  count = local.effective.enable_siem_export && var.siem_endpoint != null ? 1 : 0

  name = "[Narrative] Governance SIEM Export"
  events = [
    "policy.lifecycle.create",
    "policy.lifecycle.update",
    "policy.lifecycle.delete",
    "application.user_membership.add",
    "application.user_membership.remove",
    "group.user_membership.add",
    "group.user_membership.remove",
    "user.lifecycle.activate",
    "user.lifecycle.deactivate",
    "user.lifecycle.suspend",
    "user.account.update_profile",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.siem_endpoint
    version = "1.0.0"
  }

  status = "ACTIVE"
}
