output "certification_campaign_id" {
  description = "Certification campaign policy ID"
  value       = okta_policy.certification_campaign.id
}

output "effective_certification_frequency" {
  description = "Resolved certification frequency"
  value       = local.effective.certification_frequency
}

output "effective_certification_duration_days" {
  description = "Resolved certification review window in days"
  value       = local.effective.certification_duration_days
}

output "effective_reviewer_type" {
  description = "Resolved default reviewer assignment type"
  value       = local.effective.reviewer_type
}

output "effective_auto_revoke" {
  description = "Whether auto-revoke on certification failure is enabled"
  value       = local.effective.auto_revoke_on_failure
}

output "micro_certification_hook_id" {
  description = "Micro-certification trigger hook ID (null if disabled)"
  value       = local.effective.enable_micro_certifications ? okta_event_hook.micro_certification_trigger[0].id : null
}
