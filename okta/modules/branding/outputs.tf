# =============================================================================
# [Narrative] Branding Module — Outputs
# =============================================================================

output "security_notifications_enabled" {
  description = "Whether security notification emails are enabled"
  value       = var.enable_security_notifications
}

# Theme outputs — uncomment when branding resources are enabled.
# output "brand_id" {
#   description = "Okta brand ID"
#   value       = tolist(data.okta_brands.all.brands)[0].id
# }
