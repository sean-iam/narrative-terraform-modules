# =============================================================================
# [Narrative] Authenticators Module
# MFA methods and enrollment configuration
#
# Defense-in-depth strategy:
# - Standard: Okta Verify push — convenient, good baseline
# - Elevated: Okta Verify number challenge — blocks MFA fatigue attacks
# - Strict: WebAuthn/FIDO2 — phishing-proof hardware keys
# =============================================================================

# -----------------------------------------------------------------------------
# Okta Verify — Primary MFA Authenticator
# Standard: push notification (channelBinding.required = false)
# Elevated/Strict: number challenge (channelBinding.required = true)
# -----------------------------------------------------------------------------

resource "okta_authenticator" "okta_verify" {
  name   = "Okta Verify"
  key    = "okta_verify"
  status = "ACTIVE"
  settings = jsonencode({
    channelBinding = {
      style    = "NUMBER_CHALLENGE"
      required = local.effective.mfa_method != "okta_verify_push"
    }
    compliance = {
      fips = "OPTIONAL"
    }
    userVerification = "PREFERRED"
    appInstanceId    = "DEFAULT"
  })
}

# -----------------------------------------------------------------------------
# FIDO2 WebAuthn — Strongest Authenticator
# Enabled at Elevated and Strict profiles
# Hardware keys (YubiKey) or platform authenticators (Touch ID, Windows Hello)
# -----------------------------------------------------------------------------

resource "okta_authenticator" "webauthn" {
  count  = local.effective.enable_webauthn ? 1 : 0
  name   = "Security Key or Biometric"
  key    = "webauthn"
  status = "ACTIVE"
  settings = jsonencode({
    userVerification        = "REQUIRED"
    authenticatorAttachment = "ANY"
  })
}

# -----------------------------------------------------------------------------
# Email — Recovery Only
# NOT for primary MFA (vulnerable to email compromise)
# -----------------------------------------------------------------------------

resource "okta_authenticator" "email" {
  count  = var.enable_email_recovery ? 1 : 0
  name   = "Email"
  key    = "okta_email"
  status = "ACTIVE"
  settings = jsonencode({
    tokenLifetimeInMinutes = var.email_token_lifetime_minutes
    allowedFor             = "recovery"
  })
}

# -----------------------------------------------------------------------------
# Password — First Factor Only
# Strong policy enforced separately (policies-password module)
# Never sufficient alone for authentication
# -----------------------------------------------------------------------------

resource "okta_authenticator" "password" {
  name   = "Password"
  key    = "okta_password"
  status = "ACTIVE"
}
