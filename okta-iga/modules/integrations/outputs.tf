output "servicenow_integration_enabled" {
  description = "Whether ServiceNow integration is active"
  value       = local.effective.enable_servicenow_integration
}

output "servicenow_hook_id" {
  description = "ServiceNow event hook ID (null if not created)"
  value       = local.effective.enable_servicenow_integration && var.servicenow_instance_url != null ? okta_event_hook.servicenow[0].id : null
}

output "jira_integration_enabled" {
  description = "Whether Jira integration is active"
  value       = local.effective.enable_jira_integration
}

output "jira_hook_id" {
  description = "Jira event hook ID (null if not created)"
  value       = local.effective.enable_jira_integration && var.jira_instance_url != null ? okta_event_hook.jira[0].id : null
}

output "slack_approvals_enabled" {
  description = "Whether Slack interactive approvals are active"
  value       = local.effective.enable_slack_approvals
}

output "slack_approvals_hook_id" {
  description = "Slack approvals hook ID (null if not created)"
  value       = local.effective.enable_slack_approvals && var.slack_approval_webhook_url != null ? okta_event_hook.slack_approvals[0].id : null
}

output "teams_approvals_enabled" {
  description = "Whether Teams interactive approvals are active"
  value       = local.effective.enable_teams_approvals
}

output "teams_approvals_hook_id" {
  description = "Teams approvals hook ID (null if not created)"
  value       = local.effective.enable_teams_approvals && var.teams_approval_webhook_url != null ? okta_event_hook.teams_approvals[0].id : null
}

output "siem_forwarding_enabled" {
  description = "Whether SIEM event forwarding is active"
  value       = local.effective.enable_siem_forwarding
}

output "siem_forwarding_hook_id" {
  description = "SIEM forwarding hook ID (null if not created)"
  value       = local.effective.enable_siem_forwarding && var.siem_forwarding_endpoint != null ? okta_event_hook.siem_forwarding[0].id : null
}
