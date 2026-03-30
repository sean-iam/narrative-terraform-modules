# =============================================================================
# [Narrative] Auth Server Module — Outputs
# =============================================================================

output "auth_server_id" {
  description = "Custom authorization server ID"
  value       = okta_auth_server.main.id
}

output "auth_server_issuer" {
  description = "Authorization server issuer URL"
  value       = okta_auth_server.main.issuer
}

output "scope_ids" {
  description = "Map of scope name to scope ID"
  value       = { for k, v in okta_auth_server_scope.scopes : k => v.id }
}

output "internal_policy_id" {
  description = "Internal applications token policy ID"
  value       = okta_auth_server_policy.internal.id
}

output "service_policy_id" {
  description = "Service-to-service token policy ID"
  value       = okta_auth_server_policy.service.id
}
