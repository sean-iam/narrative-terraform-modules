# =============================================================================
# [Narrative] Auth Server Module — Outputs
# =============================================================================

output "app_registration_id" {
  description = "App registration object ID"
  value       = azuread_application.main.object_id
}

output "app_registration_client_id" {
  description = "App registration application (client) ID"
  value       = azuread_application.main.client_id
}

output "service_principal_id" {
  description = "Service principal object ID"
  value       = azuread_service_principal.main.object_id
}

output "scope_ids" {
  description = "Map of scope name to scope ID"
  value       = { for k, v in random_uuid.scope_ids : k => v.result }
}

output "effective_access_token_lifetime_minutes" {
  description = "Resolved access token lifetime in minutes"
  value       = local.effective.access_token_lifetime_minutes
}

output "effective_refresh_token_lifetime_days" {
  description = "Resolved refresh token lifetime in days"
  value       = local.effective.refresh_token_lifetime_days
}
