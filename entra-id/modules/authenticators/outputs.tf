# =============================================================================
# [Narrative] Authenticators Module — Outputs
# =============================================================================

output "auth_strength_policy_id" {
  description = "Primary authentication strength policy ID"
  value       = azuread_authentication_strength_policy.main.id
}

output "fido2_only_policy_id" {
  description = "FIDO2-only authentication strength policy ID (null if FIDO2 disabled)"
  value       = local.effective.enable_fido2 ? azuread_authentication_strength_policy.fido2_only[0].id : null
}

output "effective_mfa_method" {
  description = "The resolved MFA method being used"
  value       = local.effective.mfa_method
}
