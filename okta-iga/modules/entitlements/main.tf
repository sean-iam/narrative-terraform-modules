# =============================================================================
# [Narrative] Entitlements Module
# Entitlement management, resource catalogs, and entitlement bundles.
#
# Terraform support: MINIMAL
# OIG entitlement management is configured through the Governance API
# (/api/v1/governance/entitlements). The Terraform provider does not have
# dedicated entitlement resources. This module uses Okta groups to model
# entitlement bundles and documents required API/console configuration.
#
# Risk profile philosophy:
# - Standard: Discovery enabled, 24h sync, bundles optional
# - Elevated: 12h sync, bundles enabled for role-based access
# - Strict: 6h sync, bundles required, all entitlements cataloged
# =============================================================================

# -----------------------------------------------------------------------------
# Entitlement Bundle Groups
# Models entitlement bundles as Okta groups. Each bundle maps to a role
# that grants a set of application entitlements. OIG uses these groups
# as the basis for access request catalogs and certification scoping.
# -----------------------------------------------------------------------------

resource "okta_group" "entitlement_bundle" {
  for_each = local.effective.enable_entitlement_bundles ? {
    for bundle in var.entitlement_bundles : bundle.name => bundle
  } : {}

  name        = "[Narrative] Bundle: ${each.value.name}"
  description = "${each.value.description}. Entitlements: ${join(", ", each.value.entitlements)}."
}

# -----------------------------------------------------------------------------
# Entitlement Discovery Configuration
# OIG entitlement discovery is configured via the Governance API.
# This policy serves as the configuration anchor and documentation.
# -----------------------------------------------------------------------------

resource "okta_policy" "entitlement_management" {
  count = local.effective.enable_entitlement_discovery ? 1 : 0

  name        = "[Narrative] Entitlement Management"
  description = "Entitlement discovery and catalog management. Sync interval: ${local.effective.entitlement_sync_interval_hours}h. Bundles: ${local.effective.enable_entitlement_bundles ? "enabled" : "disabled"}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 5

  // Requires Okta Governance API v2024.06+ for:
  // - Entitlement discovery configuration
  // - Sync interval settings
  // - Entitlement-to-group mapping
  // - Bundle composition rules
  //
  // Discovery endpoint: POST /api/v1/governance/entitlements/discover
  // Sync config endpoint: PUT /api/v1/governance/entitlements/settings
}
