# =============================================================================
# Narrative Terraform Modules — Entra ID
# Aggregated outputs from all modules
# =============================================================================

# Groups
output "all_group_ids" {
  description = "All group IDs from the groups module"
  value       = module.groups.all_group_ids
}

# Network
output "trusted_location_id" {
  description = "Trusted named location ID"
  value       = module.network.trusted_location_id
}

# Authenticators
output "effective_mfa_method" {
  description = "The resolved MFA method"
  value       = module.authenticators.effective_mfa_method
}

# Auth Server
output "app_registration_id" {
  description = "Primary app registration object ID"
  value       = module.auth_server.app_registration_id
}

output "app_registration_client_id" {
  description = "Primary app registration application (client) ID"
  value       = module.auth_server.app_registration_client_id
}
