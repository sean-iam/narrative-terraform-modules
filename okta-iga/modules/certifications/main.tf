# =============================================================================
# [Narrative] Certifications Module
# Access certification campaigns, schedules, and reviewer assignment.
#
# Terraform support: MINIMAL
# Okta Identity Governance certifications are managed through the OIG
# Governance API (/api/v1/governance/campaigns). There are no dedicated
# Terraform resources for certification campaigns yet. This module creates
# the policy framework and documents the required manual/API configuration.
#
# Risk profile philosophy:
# - Standard: Quarterly campaigns, 14-day review window, no auto-revoke
# - Elevated: Monthly campaigns, 10-day window, auto-revoke on failure
# - Strict: Continuous certification, 7-day window, auto-revoke + micro-certs
# =============================================================================

# -----------------------------------------------------------------------------
# Certification Campaign Policy
# Creates the policy shell for certification campaigns.
# Campaign scheduling, reviewer assignment, and remediation actions
# require the OIG Governance API or admin console configuration.
# -----------------------------------------------------------------------------

resource "okta_policy" "certification_campaign" {
  name        = "[Narrative] Access Certification Campaign"
  description = "Access certification campaign. Frequency: ${local.effective.certification_frequency}. Duration: ${local.effective.certification_duration_days} days. Reviewer: ${local.effective.reviewer_type}. Auto-revoke: ${local.effective.auto_revoke_on_failure}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 4
}

resource "okta_policy_rule" "certification_campaign_rule" {
  policy_id = okta_policy.certification_campaign.id
  name      = "[Narrative] Certification Campaign Rule"
  status    = "ACTIVE"
  priority  = 1

  // Requires Okta Governance API v2024.06+ for campaign-specific properties:
  // - frequency (quarterly/monthly/weekly/continuous)
  // - duration_days
  // - reviewer_type (manager/app_owner/custom)
  // - auto_revoke_on_failure
  // - enable_micro_certifications
  // - reminder_days_before_deadline
  //
  // Campaign creation endpoint: POST /api/v1/governance/campaigns
  // Campaign schedule endpoint: POST /api/v1/governance/campaigns/{id}/schedule
}

# -----------------------------------------------------------------------------
# Micro-Certification Event Hook
# Triggers certification review on role/group membership changes.
# Only active when enable_micro_certifications is true.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "micro_certification_trigger" {
  count = local.effective.enable_micro_certifications ? 1 : 0

  name = "[Narrative] Micro-Certification Trigger"
  events = [
    "group.user_membership.add",
    "group.user_membership.remove",
    "application.user_membership.add",
    "user.lifecycle.activate",
    "user.account.update_profile",
  ]

  channel = {
    type    = "HTTP"
    // Requires an endpoint that triggers a micro-certification campaign
    // via the OIG Governance API. Typically an Okta Workflow or
    // serverless function that calls POST /api/v1/governance/campaigns
    // with scope limited to the affected user.
    uri     = "https://placeholder.example.com/micro-cert-trigger"
    version = "1.0.0"
  }

  // NOTE: The URI above is a placeholder. Replace with your actual
  // micro-certification trigger endpoint (Okta Workflow, Lambda, etc.)
  // before applying. If no endpoint is available, disable
  // enable_micro_certifications or remove this resource.

  status = "ACTIVE"
}
