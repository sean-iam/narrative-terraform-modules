# =============================================================================
# [Narrative] Lifecycle Rules Module
# Access duration policies, time-bound access, auto-expiration, and
# extension workflows.
#
# Terraform support: PARTIAL
# Access lifecycle rules in OIG are managed through the Governance API.
# This module creates the policy framework and documents configuration.
# Duration settings and extension workflows require API/console config.
#
# Risk profile philosophy:
# - Standard: 90-day default, 365-day max, 4 extensions allowed
# - Elevated: 60-day default, 180-day max, 2 extensions
# - Strict: 30-day default, 90-day max, 1 extension only
# =============================================================================

# -----------------------------------------------------------------------------
# Access Lifecycle Policy
# Controls time-bound access grants and expiration behavior.
# The policy documents the lifecycle configuration; actual duration
# enforcement requires the OIG Governance API.
# -----------------------------------------------------------------------------

resource "okta_policy" "access_lifecycle" {
  name        = "[Narrative] Access Lifecycle Rules"
  description = "Time-bound access management. Default: ${local.effective.default_access_duration_days} days. Max: ${local.effective.max_access_duration_days} days. Auto-expire: ${local.effective.enable_auto_expiration ? "yes" : "no"}. Extensions: ${local.effective.enable_extension_workflow ? "up to ${local.effective.max_extensions}" : "disabled"}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 9

  // Requires Okta Governance API v2024.06+ for:
  // - default_access_duration_days enforcement
  // - max_access_duration_days cap
  // - Auto-expiration scheduling
  // - Extension workflow configuration
  // - Extension limit enforcement
  //
  // Lifecycle config endpoint: PUT /api/v1/governance/lifecycle/settings
  // Extension workflow: POST /api/v1/governance/lifecycle/extensions
}

resource "okta_policy_rule" "lifecycle_default" {
  policy_id = okta_policy.access_lifecycle.id
  name      = "[Narrative] Default Lifecycle Rule"
  status    = "ACTIVE"
  priority  = 1

  // Duration and extension properties configured via Governance API.
  // This rule documents the intended lifecycle behavior.
}

# -----------------------------------------------------------------------------
# Expiration Reminder Event Hook
# Sends reminders before access expires so users can request extensions.
# Only created if extension workflows are enabled.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "expiration_reminder" {
  count = local.effective.enable_extension_workflow ? 1 : 0

  name = "[Narrative] Access Expiration Reminder"
  events = [
    "user.lifecycle.deactivate",
    "application.user_membership.remove",
    "group.user_membership.remove",
  ]

  channel = {
    type    = "HTTP"
    // Requires an endpoint that checks upcoming expirations and sends
    // reminders. Typically an Okta Workflow or serverless function.
    uri     = "https://placeholder.example.com/expiration-reminder"
    version = "1.0.0"
  }

  // NOTE: The URI above is a placeholder. Replace with your actual
  // expiration reminder endpoint before applying. The endpoint should
  // check if the event is an expiration (vs manual removal) and send
  // a reminder ${local.effective.extension_reminder_days} days before.

  status = "ACTIVE"
}
