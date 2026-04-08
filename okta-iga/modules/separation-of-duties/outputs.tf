output "sod_policy_id" {
  description = "SoD enforcement policy ID"
  value       = local.effective.enable_sod_policies ? okta_policy.sod_enforcement[0].id : null
}

output "sod_policies_enabled" {
  description = "Whether SoD policy enforcement is active"
  value       = local.effective.enable_sod_policies
}

output "effective_sod_violation_action" {
  description = "Resolved SoD violation action"
  value       = local.effective.sod_violation_action
}

output "toxic_combination_detection_enabled" {
  description = "Whether toxic combination detection is active"
  value       = local.effective.enable_toxic_combination_detection
}

output "sod_rule_group_ids" {
  description = "Map of SoD rule names to documentation group IDs"
  value = {
    for name, group in okta_group.sod_rule : name => group.id
  }
}

output "toxic_combination_hook_id" {
  description = "Toxic combination monitor hook ID (null if disabled)"
  value       = local.effective.enable_toxic_combination_detection ? okta_event_hook.toxic_combination_monitor[0].id : null
}
