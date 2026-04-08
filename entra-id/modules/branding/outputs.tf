# =============================================================================
# [Narrative] Branding Module — Outputs
# =============================================================================

output "primary_color" {
  description = "Configured primary brand color"
  value       = var.primary_color
}

output "background_color" {
  description = "Configured background color"
  value       = var.background_color
}

output "self_service_password_reset_enabled" {
  description = "Whether self-service password reset is enabled"
  value       = var.enable_self_service_password_reset
}
