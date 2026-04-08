# =============================================================================
# [Narrative] Behaviors Module — Outputs
# =============================================================================

output "login_challenges_ou_path" {
  description = "OU path for login challenge policy"
  value       = googleworkspace_org_unit.login_challenges.org_unit_path
}

output "account_recovery_ou_path" {
  description = "OU path for account recovery policy"
  value       = googleworkspace_org_unit.account_recovery.org_unit_path
}

output "less_secure_apps_blocked" {
  description = "Whether less secure apps are blocked"
  value       = local.effective.enable_less_secure_apps_block
}

output "effective_recovery_method" {
  description = "The resolved account recovery method"
  value       = local.effective.account_recovery_method
}
