# =============================================================================
# [Narrative] Governance Policies Module
# Top-level governance policy configuration for OIG Access Requests
# and Access Certifications.
#
# Terraform support: PARTIAL
# The okta_policy resource supports ACCESS_POLICY type, which can be used
# for governance policies. Full OIG governance policy resources
# (okta_governance_policy) are not yet available in the provider.
# We use okta_policy with type "ACCESS_POLICY" where possible and
# placeholder blocks where the API requires OIG-specific endpoints.
# =============================================================================

# -----------------------------------------------------------------------------
# Access Request Governance Policy
# Controls whether access requests require approval and at what level.
# Uses okta_policy with ACCESS_POLICY type as the closest available resource.
# -----------------------------------------------------------------------------

resource "okta_policy" "access_request" {
  count = local.effective.enable_request_policy ? 1 : 0

  name        = "[Narrative] Access Request Governance Policy"
  description = "Governance policy controlling access request workflows. Action: ${local.effective.request_policy_action}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 1
}

resource "okta_policy_rule" "access_request_default" {
  count = local.effective.enable_request_policy ? 1 : 0

  policy_id = okta_policy.access_request[0].id
  name      = "[Narrative] Default Access Request Rule"
  status    = "ACTIVE"
  priority  = 1

  // Requires Okta API v2024.06+ for full governance rule properties.
  // The rule action (allow/require_approval/deny) maps to OIG request
  // workflow configuration. With current provider, this creates the
  // policy shell; request workflow behavior is configured via the
  // access-requests and approval-workflows modules.
}

# -----------------------------------------------------------------------------
# Access Certification Governance Policy
# Controls certification campaign behavior and remediation actions.
# -----------------------------------------------------------------------------

resource "okta_policy" "access_certification" {
  count = local.effective.enable_certification_policy ? 1 : 0

  name        = "[Narrative] Access Certification Governance Policy"
  description = "Governance policy for access certification campaigns. Failure action: ${local.effective.certification_policy_action}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 2
}

resource "okta_policy_rule" "certification_default" {
  count = local.effective.enable_certification_policy ? 1 : 0

  policy_id = okta_policy.access_certification[0].id
  name      = "[Narrative] Default Certification Rule"
  status    = "ACTIVE"
  priority  = 1

  // Requires Okta API v2024.06+ for certification-specific rule properties
  // such as auto_revoke_on_failure and remediation_action.
  // Certification campaign scheduling is handled by the certifications module.
}
