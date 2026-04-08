# =============================================================================
# [Narrative] Resource Catalog Module
# Self-service catalog of requestable applications and resources.
#
# Terraform support: PARTIAL
# The resource catalog in OIG is managed through the Governance API.
# This module uses okta_group for catalog visibility scoping and
# okta_policy for the catalog configuration shell. Catalog item
# publishing requires the Governance API or admin console.
#
# Risk profile philosophy:
# - Standard: All users see all catalog items, descriptions optional
# - Elevated: Role-based visibility, descriptions required
# - Strict: Department-based visibility, descriptions required
# =============================================================================

# -----------------------------------------------------------------------------
# Resource Catalog Configuration Policy
# Documents the catalog configuration. Actual catalog item publishing
# requires the OIG Governance API.
# -----------------------------------------------------------------------------

resource "okta_policy" "resource_catalog" {
  count = local.effective.enable_resource_catalog ? 1 : 0

  name        = "[Narrative] Resource Catalog"
  description = "Self-service resource catalog. Visibility: ${local.effective.catalog_visibility}. Descriptions: ${local.effective.require_descriptions ? "required" : "optional"}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 7

  // Requires Okta Governance API v2024.06+ for:
  // - Catalog item publishing
  // - Visibility rule configuration
  // - Description requirements
  // - Owner assignment per catalog item
  //
  // Catalog endpoint: POST /api/v1/governance/catalog/items
  // Visibility config: PUT /api/v1/governance/catalog/settings
}

# -----------------------------------------------------------------------------
# Catalog Visibility Groups
# When visibility is role_based or department_based, these groups
# control which users can see which catalog items.
# -----------------------------------------------------------------------------

resource "okta_group" "catalog_viewers" {
  count = local.effective.enable_resource_catalog && local.effective.catalog_visibility != "all_users" ? 1 : 0

  name        = "[Narrative] Catalog Viewers"
  description = "Users who can view the resource catalog. Visibility mode: ${local.effective.catalog_visibility}."
}

# -----------------------------------------------------------------------------
# Catalog Item Owner Groups
# Each catalog item with an owner_group_id gets an ownership association.
# Owners are responsible for approving access and maintaining descriptions.
# -----------------------------------------------------------------------------

resource "okta_group" "catalog_item_owners" {
  for_each = local.effective.enable_resource_catalog ? {
    for item in var.catalog_items : item.name => item if item.owner_group_id == null
  } : {}

  name        = "[Narrative] Catalog Owner: ${each.value.name}"
  description = "Owners of the '${each.value.name}' catalog item. Responsible for approving access requests and maintaining item descriptions."
}
