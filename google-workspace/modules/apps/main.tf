# =============================================================================
# [Narrative] Apps Module
# Pre-installed apps, SAML app configurations, app access control per OU,
# and blocked third-party apps.
#
# Google Workspace app management:
# 1. Pre-installed Google Workspace apps — apps available to all users
# 2. SAML apps — federated SSO to third-party services
# 3. Blocked apps — OAuth apps blocked by client ID
# 4. App access restrictions — per-OU app availability
#
# Note: The googleworkspace provider does not have native SAML app resources.
# SAML app configuration is documented as OUs and should be configured via
# the Admin Console. Pre-installed apps and marketplace settings are also
# Admin Console operations.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. App Management Policy OU
# Documents the overall app management strategy.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "app_management" {
  name                 = "App Management"
  description          = "[Narrative] App management policy. Pre-installed apps: ${length(var.pre_installed_apps)}. SAML apps: ${length(var.saml_apps)}. Blocked apps: ${length(var.blocked_apps)}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2. SAML App Documentation OUs
# Each SAML app gets a documentation OU with its configuration details.
# Actual SAML app configuration must be done via the Admin Console.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "saml_apps" {
  for_each             = { for app in var.saml_apps : app.app_name => app }
  name                 = "SAML - ${each.value.display_name}"
  description          = "[Narrative] SAML app: ${each.value.display_name}. ACS URL: ${each.value.acs_url}. Entity ID: ${each.value.entity_id}. Name ID format: ${each.value.name_id}."
  parent_org_unit_path = googleworkspace_org_unit.app_management.org_unit_path
}

# -----------------------------------------------------------------------------
# 3. Blocked Apps Documentation OU
# Documents which OAuth app client IDs are blocked.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "blocked_apps" {
  count                = length(var.blocked_apps) > 0 ? 1 : 0
  name                 = "Blocked Apps"
  description          = "[Narrative] ${length(var.blocked_apps)} OAuth app client IDs blocked. These apps cannot access user data."
  parent_org_unit_path = googleworkspace_org_unit.app_management.org_unit_path
}

# -----------------------------------------------------------------------------
# 4. App Access Restriction OUs
# Per-OU app availability restrictions.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "app_restrictions" {
  for_each             = var.app_access_ou_restrictions
  name                 = "App Restriction - ${each.key}"
  description          = "[Narrative] App '${each.key}' restricted to OUs: ${join(", ", each.value)}."
  parent_org_unit_path = googleworkspace_org_unit.app_management.org_unit_path
}
