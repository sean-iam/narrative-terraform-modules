output "notification_policy_id" {
  description = "Notification configuration policy ID"
  value       = local.effective.enable_email_notifications ? okta_policy.notification_config[0].id : null
}

output "email_notifications_enabled" {
  description = "Whether email notifications are enabled"
  value       = local.effective.enable_email_notifications
}

output "effective_digest_mode" {
  description = "Whether digest mode is active"
  value       = local.effective.enable_digest_notifications
}

output "effective_digest_frequency" {
  description = "Resolved digest frequency"
  value       = local.effective.digest_frequency
}

output "effective_escalation_reminder_hours" {
  description = "Resolved escalation reminder threshold in hours"
  value       = local.effective.reminder_escalation_hours
}

output "escalation_reminder_hook_id" {
  description = "Escalation reminder hook ID (null if notifications disabled)"
  value       = local.effective.enable_email_notifications ? okta_event_hook.escalation_reminder[0].id : null
}
