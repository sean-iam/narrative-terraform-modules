# =============================================================================
# [Narrative] Notifications Module
# Notification templates, reminder schedules, escalation alerts,
# and digest settings for governance events.
#
# Terraform support: MINIMAL
# OIG notification configuration is managed through the Governance API
# and admin console. This module creates the configuration policy and
# event hooks for escalation reminders. Template customization requires
# the Governance API.
#
# Risk profile philosophy:
# - Standard: Weekly digests, 48h escalation reminder
# - Elevated: Individual notifications (no digest), 24h escalation
# - Strict: Individual notifications, 12h escalation for urgency
# =============================================================================

# -----------------------------------------------------------------------------
# Notification Configuration Policy
# Documents notification settings. Template customization and digest
# configuration require the OIG admin console or Governance API.
# -----------------------------------------------------------------------------

resource "okta_policy" "notification_config" {
  count = local.effective.enable_email_notifications ? 1 : 0

  name        = "[Narrative] Governance Notification Settings"
  description = "Governance notification configuration. Mode: ${local.effective.enable_digest_notifications ? "digest (${local.effective.digest_frequency})" : "individual"}. Escalation reminder: ${local.effective.reminder_escalation_hours}h."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 11

  // Requires Okta Governance API v2024.06+ for:
  // - Notification template customization
  // - Digest frequency configuration
  // - Escalation reminder scheduling
  // - Per-event notification routing
  //
  // Notification settings: PUT /api/v1/governance/notifications/settings
  // Templates: PUT /api/v1/governance/notifications/templates/{type}
}

# -----------------------------------------------------------------------------
# Escalation Reminder Event Hook
# Monitors pending approval events and triggers reminders when
# approvals are nearing the escalation threshold.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "escalation_reminder" {
  count = local.effective.enable_email_notifications ? 1 : 0

  name = "[Narrative] Governance Escalation Reminder"
  events = [
    "policy.lifecycle.update",
    "application.user_membership.add",
    "group.user_membership.add",
  ]

  channel = {
    type    = "HTTP"
    // Requires an endpoint that checks pending approvals and sends
    // reminders when they approach the escalation threshold.
    // Typically an Okta Workflow or scheduled function.
    uri     = "https://placeholder.example.com/escalation-reminder"
    version = "1.0.0"
  }

  // NOTE: The URI above is a placeholder. Replace with your actual
  // escalation reminder endpoint before applying.

  status = "ACTIVE"
}
