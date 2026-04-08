# =============================================================================
# Narrative Terraform Modules — Okta Identity Governance (OIG)
# Aggregated outputs from all governance modules
# =============================================================================

# Governance Policies
output "request_policy_id" {
  description = "Access request governance policy ID"
  value       = module.governance_policies.request_policy_id
}

output "certification_policy_id" {
  description = "Certification governance policy ID"
  value       = module.governance_policies.certification_policy_id
}

# Access Requests
output "self_service_enabled" {
  description = "Whether self-service access requests are enabled"
  value       = module.access_requests.self_service_enabled
}

output "effective_max_request_duration_days" {
  description = "Resolved maximum request duration in days"
  value       = module.access_requests.effective_max_request_duration_days
}

# Certifications
output "effective_certification_frequency" {
  description = "Resolved certification campaign frequency"
  value       = module.certifications.effective_certification_frequency
}

output "certification_campaign_id" {
  description = "Primary certification campaign resource ID"
  value       = module.certifications.certification_campaign_id
}

# Approval Workflows
output "effective_approval_levels" {
  description = "Resolved number of approval levels"
  value       = module.approval_workflows.effective_approval_levels
}

# Lifecycle Rules
output "effective_access_duration_days" {
  description = "Resolved default access duration in days"
  value       = module.lifecycle_rules.effective_access_duration_days
}

output "effective_max_access_duration_days" {
  description = "Resolved maximum access duration in days"
  value       = module.lifecycle_rules.effective_max_access_duration_days
}

# Separation of Duties
output "sod_policies_enabled" {
  description = "Whether SoD policy enforcement is active"
  value       = module.separation_of_duties.sod_policies_enabled
}

output "effective_sod_violation_action" {
  description = "Resolved SoD violation action"
  value       = module.separation_of_duties.effective_sod_violation_action
}

# Integrations
output "servicenow_integration_enabled" {
  description = "Whether ServiceNow integration is active"
  value       = module.integrations.servicenow_integration_enabled
}

output "jira_integration_enabled" {
  description = "Whether Jira integration is active"
  value       = module.integrations.jira_integration_enabled
}
