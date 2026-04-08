# =============================================================================
# [Narrative] Apps Module — Outputs
# =============================================================================

output "oidc_app_ids" {
  description = "Map of OIDC app display name to application (client) ID"
  value       = { for k, v in azuread_application.oidc : k => v.client_id }
}

output "oidc_object_ids" {
  description = "Map of OIDC app display name to object ID"
  value       = { for k, v in azuread_application.oidc : k => v.object_id }
}

output "saml_app_ids" {
  description = "Map of SAML app display name to application (client) ID"
  value       = { for k, v in azuread_application.saml : k => v.client_id }
}

output "saml_object_ids" {
  description = "Map of SAML app display name to object ID"
  value       = { for k, v in azuread_application.saml : k => v.object_id }
}

output "service_app_ids" {
  description = "Map of service app display name to application (client) ID"
  value       = { for k, v in azuread_application.service : k => v.client_id }
}

output "service_app_secrets" {
  description = "Map of service app display name to client secret value"
  value       = { for k, v in azuread_application_password.service : k => v.value }
  sensitive   = true
}
