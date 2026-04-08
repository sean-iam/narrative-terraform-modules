# =============================================================================
# [Narrative] Separation of Duties Module
# SoD policy definitions, toxic combination rules, and violation handling.
#
# Terraform support: PARTIAL
# OIG SoD policies are managed through the Governance API
# (/api/v1/governance/sod). This module creates the policy framework
# and models SoD rule metadata. Actual SoD enforcement at the request
# and provisioning layer requires the Governance API.
#
# Risk profile philosophy:
# - Standard: SoD warnings only (advisory), no toxic combo detection
# - Elevated: Block with override on critical, toxic combo detection on
# - Strict: Hard block everywhere, toxic combos blocked, no overrides
# =============================================================================

# -----------------------------------------------------------------------------
# SoD Enforcement Policy
# Controls how the system responds to separation of duties violations.
# Actual enforcement rules require the OIG Governance API.
# -----------------------------------------------------------------------------

resource "okta_policy" "sod_enforcement" {
  count = local.effective.enable_sod_policies ? 1 : 0

  name        = "[Narrative] Separation of Duties Enforcement"
  description = "SoD policy enforcement. Violation action: ${local.effective.sod_violation_action}. Toxic combination detection: ${local.effective.enable_toxic_combination_detection ? "enabled" : "disabled"}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 10

  // Requires Okta Governance API v2024.06+ for:
  // - SoD rule creation and management
  // - Violation action enforcement (warn/block/block_with_override)
  // - Toxic combination detection engine
  // - Override approval routing
  //
  // SoD rules endpoint: POST /api/v1/governance/sod/rules
  // SoD settings endpoint: PUT /api/v1/governance/sod/settings
}

# -----------------------------------------------------------------------------
# SoD Rule Documentation
# Each rule defines an incompatible pair of entitlements.
# The actual enforcement is handled by OIG at request time.
# These groups serve as documentation and can be used for
# reporting on SoD rule coverage.
# -----------------------------------------------------------------------------

resource "okta_group" "sod_rule" {
  for_each = local.effective.enable_sod_policies ? {
    for rule in var.sod_rules : rule.name => rule
  } : {}

  name        = "[Narrative] SoD Rule: ${each.value.name}"
  description = "${each.value.description}. Conflict: '${each.value.entitlement_a}' vs '${each.value.entitlement_b}'. Action: ${coalesce(each.value.action, local.effective.sod_violation_action)}. Override: ${each.value.allow_override ? "allowed" : "denied"}."
}

# -----------------------------------------------------------------------------
# Toxic Combination Detection Event Hook
# Monitors entitlement changes and flags toxic combinations.
# Only active when toxic combination detection is enabled.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "toxic_combination_monitor" {
  count = local.effective.enable_toxic_combination_detection ? 1 : 0

  name = "[Narrative] Toxic Combination Monitor"
  events = [
    "application.user_membership.add",
    "group.user_membership.add",
    "user.account.update_profile",
  ]

  channel = {
    type    = "HTTP"
    // Requires an endpoint that evaluates entitlement combinations
    // against SoD rules. Typically an Okta Workflow or serverless
    // function that queries the user's current entitlements and
    // checks for toxic pairs.
    uri     = "https://placeholder.example.com/toxic-combo-check"
    version = "1.0.0"
  }

  // NOTE: The URI above is a placeholder. Replace with your actual
  // toxic combination detection endpoint before applying.

  status = "ACTIVE"
}
