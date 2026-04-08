output "approval_workflow_policy_id" {
  description = "Approval workflow policy ID"
  value       = okta_policy.approval_workflow.id
}

output "effective_approval_levels" {
  description = "Resolved number of approval levels"
  value       = local.effective.approval_levels
}

output "effective_approval_timeout_hours" {
  description = "Resolved approval timeout in hours"
  value       = local.effective.approval_timeout_hours
}

output "approval_level_1_group_id" {
  description = "Level 1 approver group ID"
  value       = okta_group.approval_level_1.id
}

output "approval_level_2_group_id" {
  description = "Level 2 approver group ID (null if single-level)"
  value       = local.effective.approval_levels >= 2 ? okta_group.approval_level_2[0].id : null
}

output "approval_level_3_group_id" {
  description = "Level 3 approver group ID (null if less than three levels)"
  value       = local.effective.approval_levels >= 3 ? okta_group.approval_level_3[0].id : null
}

output "escalation_target_group_id" {
  description = "Escalation target group ID (null if escalation disabled)"
  value       = local.effective.enable_escalation ? okta_group.escalation_target[0].id : null
}

output "effective_escalation_enabled" {
  description = "Whether escalation is enabled"
  value       = local.effective.enable_escalation
}

output "effective_delegation_enabled" {
  description = "Whether delegation is enabled"
  value       = local.effective.enable_delegation
}
