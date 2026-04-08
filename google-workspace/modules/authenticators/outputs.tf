# =============================================================================
# [Narrative] Authenticators Module — Outputs
# =============================================================================

output "security_enforcement_ou_path" {
  description = "Security enforcement organizational unit path"
  value       = googleworkspace_org_unit.security_enforcement.org_unit_path
}

output "effective_two_sv_enforcement" {
  description = "The resolved 2SV enforcement level"
  value       = local.effective.two_sv_enforcement
}

output "effective_two_sv_method" {
  description = "The resolved allowed 2SV methods"
  value       = local.effective.allowed_two_sv_methods
}

output "effective_grace_period_days" {
  description = "The resolved 2SV grace period in days"
  value       = local.effective.two_sv_grace_period_days
}

output "security_keys_only" {
  description = "Whether only security keys are allowed for 2SV"
  value       = local.effective.enable_security_keys_only
}
