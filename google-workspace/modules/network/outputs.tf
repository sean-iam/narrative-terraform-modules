# =============================================================================
# [Narrative] Network Module — Outputs
# =============================================================================

output "network_policy_ou_path" {
  description = "Network policy organizational unit path"
  value       = googleworkspace_org_unit.network_policy.org_unit_path
}

output "admin_ip_restriction_ou_path" {
  description = "Admin IP restriction OU path (null if not enforced)"
  value       = local.effective.enforce_ip_allowlist ? googleworkspace_org_unit.admin_ip_restriction[0].org_unit_path : null
}

output "context_aware_access_enabled" {
  description = "Whether context-aware access is enabled"
  value       = local.effective.enable_context_aware_access
}

output "ip_allowlist_enforced" {
  description = "Whether IP allowlist is enforced for admin access"
  value       = local.effective.enforce_ip_allowlist
}
