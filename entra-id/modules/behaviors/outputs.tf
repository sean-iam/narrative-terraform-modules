# =============================================================================
# [Narrative] Behaviors Module — Outputs
# =============================================================================

output "sign_in_risk_policy_id" {
  description = "Sign-in risk Conditional Access policy ID (null if action is allow)"
  value       = local.effective.sign_in_risk_action != "allow" ? azuread_conditional_access_policy.sign_in_risk[0].id : null
}

output "user_risk_policy_id" {
  description = "User risk Conditional Access policy ID (null if action is allow)"
  value       = local.effective.user_risk_action != "allow" ? azuread_conditional_access_policy.user_risk[0].id : null
}

# -----------------------------------------------------------------------------
# Action metadata — documents the effective configuration
# -----------------------------------------------------------------------------

output "effective_sign_in_risk_action" {
  description = "Resolved action for sign-in risk events"
  value       = local.effective.sign_in_risk_action
}

output "effective_user_risk_action" {
  description = "Resolved action for user risk events"
  value       = local.effective.user_risk_action
}

output "effective_sign_in_risk_level" {
  description = "Resolved minimum sign-in risk level threshold"
  value       = local.effective.sign_in_risk_level
}

output "effective_user_risk_level" {
  description = "Resolved minimum user risk level threshold"
  value       = local.effective.user_risk_level
}
