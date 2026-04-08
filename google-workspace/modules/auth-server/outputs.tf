# =============================================================================
# [Narrative] Auth Server Module — Outputs
# =============================================================================

output "third_party_apps_ou_path" {
  description = "OU path for third-party app access policy"
  value       = googleworkspace_org_unit.third_party_apps.org_unit_path
}

output "delegation_policy_ou_path" {
  description = "OU path for domain-wide delegation policy"
  value       = googleworkspace_org_unit.delegation_policy.org_unit_path
}

output "api_access_policy_ou_path" {
  description = "OU path for API client access policy"
  value       = googleworkspace_org_unit.api_access_policy.org_unit_path
}

output "third_party_apps_enabled" {
  description = "Whether third-party app access is enabled"
  value       = local.effective.enable_third_party_apps
}

output "domain_wide_delegation_enabled" {
  description = "Whether domain-wide delegation is enabled"
  value       = local.effective.enable_domain_wide_delegation
}

output "effective_api_client_access" {
  description = "The resolved API client access level"
  value       = local.effective.api_client_access
}
