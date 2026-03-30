# =============================================================================
# [Narrative] Event Hooks Module — Outputs
# =============================================================================

output "security_hook_id" {
  description = "Security event hook ID (null if not created)"
  value       = local.effective.enable_security_event_hook && var.security_hook_endpoint != null ? okta_event_hook.security[0].id : null
}

output "admin_activity_hook_id" {
  description = "Admin activity hook ID (null if not created)"
  value       = local.effective.enable_admin_activity_hook && var.admin_hook_endpoint != null ? okta_event_hook.admin_activity[0].id : null
}

output "security_hook_enabled" {
  description = "Whether the security event hook is active"
  value       = local.effective.enable_security_event_hook && var.security_hook_endpoint != null
}

output "admin_activity_hook_enabled" {
  description = "Whether the admin activity hook is active"
  value       = local.effective.enable_admin_activity_hook && var.admin_hook_endpoint != null
}
