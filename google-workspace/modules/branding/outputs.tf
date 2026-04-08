# =============================================================================
# [Narrative] Branding Module — Outputs
# =============================================================================

output "branding_policy_ou_path" {
  description = "OU path for branding policy documentation"
  value       = googleworkspace_org_unit.branding_policy.org_unit_path
}

output "primary_color" {
  description = "Configured primary brand color"
  value       = var.primary_color
}

output "secondary_color" {
  description = "Configured secondary brand color"
  value       = var.secondary_color
}
