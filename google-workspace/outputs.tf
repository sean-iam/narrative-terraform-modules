# =============================================================================
# Narrative Terraform Modules — Google Workspace
# Aggregated outputs from all modules
# =============================================================================

# Groups
output "all_group_ids" {
  description = "All group IDs from the groups module"
  value       = module.groups.all_group_ids
}

# Authenticators
output "effective_two_sv_method" {
  description = "The resolved 2-Step Verification method"
  value       = module.authenticators.effective_two_sv_method
}

# Auth Server
output "third_party_apps_enabled" {
  description = "Whether third-party app access is enabled"
  value       = module.auth_server.third_party_apps_enabled
}

output "domain_wide_delegation_enabled" {
  description = "Whether domain-wide delegation is enabled"
  value       = module.auth_server.domain_wide_delegation_enabled
}

# Network
output "context_aware_access_enabled" {
  description = "Whether context-aware access is enabled"
  value       = module.network.context_aware_access_enabled
}

# User Schema
output "custom_schema_name" {
  description = "Custom schema name for user profile extensions"
  value       = module.user_schema.schema_name
}
