# =============================================================================
# [Narrative] Authenticators Module
# MFA methods via Entra ID Authentication Methods Policies
#
# Defense-in-depth strategy:
# - Standard: Microsoft Authenticator push — convenient, good baseline
# - Elevated: Microsoft Authenticator number matching — blocks MFA fatigue
# - Strict: FIDO2 hardware keys — phishing-proof
#
# Note: Entra ID manages authentication methods through policy resources
# rather than discrete authenticator objects. The azuread_authentication_
# strength_policy resource defines which methods are acceptable.
# =============================================================================

# -----------------------------------------------------------------------------
# Microsoft Authenticator Configuration
# Standard: push notification (numberMatchingRequiredState = disabled)
# Elevated/Strict: number matching (numberMatchingRequiredState = enabled)
# -----------------------------------------------------------------------------

resource "azuread_authentication_strength_policy" "main" {
  display_name = "[Narrative] MFA Authentication Strength"
  description  = "[Narrative] Authentication strength policy. Method: ${local.effective.mfa_method}."

  allowed_combinations = local.effective.mfa_method == "fido2" ? [
    "fido2",
  ] : local.effective.mfa_method == "microsoft_authenticator_number" ? [
    "microsoftAuthenticatorPush",
    "fido2",
  ] : [
    "microsoftAuthenticatorPush",
    "password,microsoftAuthenticatorPush",
    "fido2",
    "password,sms",
  ]
}

# -----------------------------------------------------------------------------
# FIDO2 Authentication Strength (Strict-only default)
# A dedicated strength policy that ONLY allows FIDO2 — used for admin
# and executive Conditional Access when strict profile is selected.
# -----------------------------------------------------------------------------

resource "azuread_authentication_strength_policy" "fido2_only" {
  count        = local.effective.enable_fido2 ? 1 : 0
  display_name = "[Narrative] FIDO2 Only — Phishing Resistant"
  description  = "[Narrative] Requires FIDO2 hardware security keys. Phishing-proof authentication."

  allowed_combinations = [
    "fido2",
  ]
}
