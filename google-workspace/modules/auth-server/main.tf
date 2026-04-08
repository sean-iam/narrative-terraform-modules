# =============================================================================
# [Narrative] Auth Server Module
# OAuth app management, API client access, domain-wide delegation controls,
# and third-party app access.
#
# Google Workspace OAuth and API access controls:
# 1. Third-party app access — control which external apps can access data
# 2. Domain-wide delegation — service accounts impersonating users
# 3. API client access — scope-based access control for API clients
#
# Defense-in-depth strategy:
# - Standard: Third-party apps allowed with user consent
# - Elevated: Third-party apps restricted, delegation audited
# - Strict: No third-party apps, delegation locked down
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Third-Party App Access Policy OU
# Controls whether users can grant OAuth access to third-party applications.
# Standard: users can consent to any app
# Elevated: users restricted to admin-approved apps
# Strict: no third-party app access
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "third_party_apps" {
  name                 = "Third-Party App Policy"
  description          = "[Narrative] Third-party app access policy. Apps allowed: ${local.effective.enable_third_party_apps}. API client access: ${local.effective.api_client_access}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2. Domain-Wide Delegation Policy OU
# Controls service account domain-wide delegation.
# Elevated/Strict profiles restrict or disable delegation entirely.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "delegation_policy" {
  name                 = "Domain-Wide Delegation Policy"
  description          = "[Narrative] Domain-wide delegation policy. Delegation enabled: ${local.effective.enable_domain_wide_delegation}. Only admin-approved service accounts should have delegation."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 3. API Client Access Policy OU
# Scope-based API access controls for OAuth clients.
# Documents the intended API access levels.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "api_access_policy" {
  name                 = "API Client Access Policy"
  description          = "[Narrative] API client access policy. Access level: ${local.effective.api_client_access}. Trusted app client IDs: ${length(var.trusted_apps)}."
  parent_org_unit_path = "/"
}
