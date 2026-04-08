# =============================================================================
# [Narrative] Authenticators Module
# 2-Step Verification enforcement and allowed methods.
#
# Defense-in-depth strategy:
# - Standard: Google Prompt — convenient, good baseline
# - Elevated: Security key OR Google Prompt with number matching
# - Strict: FIDO2 security keys only — phishing-proof hardware keys
#
# Note: Google Workspace 2SV settings are managed via the Admin SDK.
# The googleworkspace provider does not have a native 2SV resource.
# These are implemented as googleworkspace_chrome_policy or via
# organizational unit settings where available.
# =============================================================================

# -----------------------------------------------------------------------------
# Organizational Unit for 2SV Enforcement
# Creates a dedicated OU for security policy scoping if needed.
# The actual 2SV enforcement is configured at the OU level via
# the Admin Console or Admin SDK — this module documents the
# intended configuration as Terraform-managed org units.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "security_enforcement" {
  name                 = "Security Enforcement"
  description          = "[Narrative] OU for 2-Step Verification enforcement. 2SV method: ${local.effective.allowed_two_sv_methods}. Enforcement: ${local.effective.two_sv_enforcement}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2SV Policy Documentation (as Terraform locals)
# The googleworkspace provider does not expose 2SV admin settings as
# resources. These locals document the intended configuration that
# should be applied via the Admin Console or Admin SDK.
#
# Intended enforcement:
# - Standard: 2SV optional but encouraged, Google Prompt allowed
# - Elevated: 2SV enforced, security key or number matching required
# - Strict: 2SV enforced, only FIDO2 security keys accepted
# -----------------------------------------------------------------------------

# The following org_unit serves as a policy anchor. The 2SV settings
# documented in the effective locals should be manually verified or
# applied via the Google Admin SDK.

resource "googleworkspace_org_unit" "two_sv_standard" {
  count                = local.effective.two_sv_enforcement == "optional" ? 1 : 0
  name                 = "2SV Optional"
  description          = "[Narrative] 2SV is optional. Users are encouraged to enroll in Google Prompt or authenticator app. Grace period: ${local.effective.two_sv_grace_period_days} days."
  parent_org_unit_path = googleworkspace_org_unit.security_enforcement.org_unit_path
}

resource "googleworkspace_org_unit" "two_sv_enforced" {
  count                = local.effective.two_sv_enforcement != "optional" ? 1 : 0
  name                 = "2SV Enforced"
  description          = "[Narrative] 2SV is enforced. Allowed methods: ${local.effective.allowed_two_sv_methods}. Grace period: ${local.effective.two_sv_grace_period_days} days. Security keys only: ${local.effective.enable_security_keys_only}."
  parent_org_unit_path = googleworkspace_org_unit.security_enforcement.org_unit_path
}
