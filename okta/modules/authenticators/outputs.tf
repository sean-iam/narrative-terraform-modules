output "okta_verify_id" {
  description = "Okta Verify authenticator ID"
  value       = okta_authenticator.okta_verify.id
}

output "webauthn_id" {
  description = "WebAuthn/FIDO2 authenticator ID"
  value       = local.effective.enable_webauthn ? okta_authenticator.webauthn[0].id : null
}

output "email_id" {
  description = "Email authenticator ID"
  value       = var.enable_email_recovery ? okta_authenticator.email[0].id : null
}

output "password_id" {
  description = "Password authenticator ID"
  value       = okta_authenticator.password.id
}

output "effective_mfa_method" {
  description = "The resolved MFA method being used"
  value       = local.effective.mfa_method
}
