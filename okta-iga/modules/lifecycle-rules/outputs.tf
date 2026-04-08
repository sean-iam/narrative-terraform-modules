output "access_lifecycle_policy_id" {
  description = "Access lifecycle policy ID"
  value       = okta_policy.access_lifecycle.id
}

output "effective_access_duration_days" {
  description = "Resolved default access duration in days"
  value       = local.effective.default_access_duration_days
}

output "effective_max_access_duration_days" {
  description = "Resolved maximum access duration in days"
  value       = local.effective.max_access_duration_days
}

output "auto_expiration_enabled" {
  description = "Whether auto-expiration is enabled"
  value       = local.effective.enable_auto_expiration
}

output "extension_workflow_enabled" {
  description = "Whether extension workflows are enabled"
  value       = local.effective.enable_extension_workflow
}

output "effective_max_extensions" {
  description = "Resolved maximum number of extensions allowed"
  value       = local.effective.max_extensions
}

output "expiration_reminder_hook_id" {
  description = "Expiration reminder hook ID (null if extensions disabled)"
  value       = local.effective.enable_extension_workflow ? okta_event_hook.expiration_reminder[0].id : null
}
