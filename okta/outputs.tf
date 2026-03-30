# =============================================================================
# Narrative Terraform Modules — Okta
# Aggregated outputs from all modules
# =============================================================================

# Groups
output "all_group_ids" {
  description = "All group IDs from the groups module"
  value       = module.groups.all_group_ids
}

# Network
output "trusted_zone_id" {
  description = "Trusted network zone ID"
  value       = module.network.trusted_zone_id
}

# Authenticators
output "effective_mfa_method" {
  description = "The resolved MFA method"
  value       = module.authenticators.effective_mfa_method
}

# Auth Server
output "auth_server_id" {
  description = "Custom authorization server ID"
  value       = module.auth_server.auth_server_id
}

output "auth_server_issuer" {
  description = "Authorization server issuer URL"
  value       = module.auth_server.auth_server_issuer
}
