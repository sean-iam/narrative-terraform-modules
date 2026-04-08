# =============================================================================
# [Narrative] Event Hooks Module — Outputs
# =============================================================================

output "security_alerts_ou_path" {
  description = "Security alerts OU path (null if not enabled)"
  value       = local.effective.enable_security_alerts ? googleworkspace_org_unit.security_alerts[0].org_unit_path : null
}

output "admin_activity_alerts_ou_path" {
  description = "Admin activity alerts OU path (null if not enabled)"
  value       = local.effective.enable_admin_activity_alerts ? googleworkspace_org_unit.admin_activity_alerts[0].org_unit_path : null
}

output "security_alerts_enabled" {
  description = "Whether security alert rules are active"
  value       = local.effective.enable_security_alerts
}

output "admin_activity_alerts_enabled" {
  description = "Whether admin activity alert rules are active"
  value       = local.effective.enable_admin_activity_alerts
}

output "audit_log_export_enabled" {
  description = "Whether audit log export is enabled"
  value       = var.audit_log_export_enabled
}
