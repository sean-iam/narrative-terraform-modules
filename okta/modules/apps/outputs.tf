# =============================================================================
# [Narrative] Apps Module — Outputs
# =============================================================================

# -----------------------------------------------------------------------------
# OIDC Apps
# -----------------------------------------------------------------------------

output "oidc_app_ids" {
  description = "Map of OIDC app label to app ID"
  value       = { for k, v in okta_app_oauth.oidc : k => v.id }
}

output "oidc_client_ids" {
  description = "Map of OIDC app label to client ID"
  value       = { for k, v in okta_app_oauth.oidc : k => v.client_id }
}

output "oidc_client_secrets" {
  description = "Map of OIDC app label to client secret"
  value       = { for k, v in okta_app_oauth.oidc : k => v.client_secret }
  sensitive   = true
}

# -----------------------------------------------------------------------------
# SAML Apps
# -----------------------------------------------------------------------------

output "saml_app_ids" {
  description = "Map of SAML app label to app ID"
  value       = { for k, v in okta_app_saml.saml : k => v.id }
}

# -----------------------------------------------------------------------------
# Service Apps
# -----------------------------------------------------------------------------

output "service_app_ids" {
  description = "Map of service app label to app ID"
  value       = { for k, v in okta_app_oauth.service : k => v.id }
}

output "service_client_ids" {
  description = "Map of service app label to client ID"
  value       = { for k, v in okta_app_oauth.service : k => v.client_id }
}

output "service_client_secrets" {
  description = "Map of service app label to client secret"
  value       = { for k, v in okta_app_oauth.service : k => v.client_secret }
  sensitive   = true
}

# -----------------------------------------------------------------------------
# Bookmark Apps
# -----------------------------------------------------------------------------

output "bookmark_app_ids" {
  description = "Map of bookmark app label to app ID"
  value       = { for k, v in okta_app_bookmark.bookmark : k => v.id }
}

# -----------------------------------------------------------------------------
# Aggregated
# -----------------------------------------------------------------------------

output "all_app_ids" {
  description = "Combined map of all app labels to app IDs"
  value = merge(
    { for k, v in okta_app_oauth.oidc : k => v.id },
    { for k, v in okta_app_saml.saml : k => v.id },
    { for k, v in okta_app_oauth.service : k => v.id },
    { for k, v in okta_app_bookmark.bookmark : k => v.id },
  )
}
