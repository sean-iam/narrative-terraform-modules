output "governance_audit_policy_id" {
  description = "Governance audit policy ID"
  value       = okta_policy.governance_audit.id
}

output "effective_report_frequency" {
  description = "Resolved report frequency"
  value       = local.effective.report_frequency
}

output "scheduled_reports_enabled" {
  description = "Whether scheduled reports are enabled"
  value       = local.effective.enable_scheduled_reports
}

output "compliance_dashboard_enabled" {
  description = "Whether the compliance dashboard is enabled"
  value       = local.effective.enable_compliance_dashboard
}

output "siem_export_hook_id" {
  description = "SIEM export event hook ID (null if not created)"
  value       = local.effective.enable_siem_export && var.siem_endpoint != null ? okta_event_hook.siem_governance_export[0].id : null
}

output "siem_export_enabled" {
  description = "Whether SIEM export is active"
  value       = local.effective.enable_siem_export
}
