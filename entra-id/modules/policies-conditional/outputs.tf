# =============================================================================
# [Narrative] Conditional Access Policies Module — Outputs
# =============================================================================

output "block_legacy_auth_policy_id" {
  description = "Block Legacy Authentication policy ID"
  value       = local.effective.block_legacy_auth ? azuread_conditional_access_policy.block_legacy_auth[0].id : null
}

output "admin_mfa_policy_id" {
  description = "Admin MFA policy ID"
  value       = local.effective.require_mfa_for_admins ? azuread_conditional_access_policy.admin_mfa[0].id : null
}

output "employee_mfa_policy_id" {
  description = "Employee MFA policy ID"
  value       = local.effective.require_mfa_for_all_users ? azuread_conditional_access_policy.employee_mfa[0].id : null
}

output "block_ofac_policy_id" {
  description = "OFAC geo-block policy ID"
  value       = var.ofac_location_id != null ? azuread_conditional_access_policy.block_ofac[0].id : null
}

output "block_high_risk_policy_id" {
  description = "High-risk country geo-block policy ID"
  value       = var.high_risk_location_id != null ? azuread_conditional_access_policy.block_high_risk[0].id : null
}
