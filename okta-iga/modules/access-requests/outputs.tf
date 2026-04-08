output "access_request_policy_id" {
  description = "Access request configuration policy ID"
  value       = local.effective.enable_self_service_requests ? okta_policy.access_request_config[0].id : null
}

output "self_service_enabled" {
  description = "Whether self-service access requests are enabled"
  value       = local.effective.enable_self_service_requests
}

output "effective_max_request_duration_days" {
  description = "Resolved maximum request duration in days"
  value       = local.effective.max_request_duration_days
}

output "effective_justification_required" {
  description = "Whether business justification is required"
  value       = local.effective.request_justification_required
}

output "effective_ticket_required" {
  description = "Whether a ticket number is required"
  value       = local.effective.request_ticket_required
}

output "slack_hook_id" {
  description = "Slack request notification hook ID (null if not created)"
  value       = local.effective.enable_slack_requests && var.slack_webhook_url != null ? okta_event_hook.slack_requests[0].id : null
}

output "teams_hook_id" {
  description = "Teams request notification hook ID (null if not created)"
  value       = local.effective.enable_teams_requests && var.teams_webhook_url != null ? okta_event_hook.teams_requests[0].id : null
}
