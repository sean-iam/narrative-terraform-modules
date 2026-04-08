# =============================================================================
# [Narrative] Login Policies Module — Outputs
# =============================================================================

output "admin_session_ou_path" {
  description = "OU path for admin session policy"
  value       = googleworkspace_org_unit.admin_session.org_unit_path
}

output "employee_session_ou_path" {
  description = "OU path for employee session policy"
  value       = googleworkspace_org_unit.employee_session.org_unit_path
}

output "contractor_session_ou_path" {
  description = "OU path for contractor session policy"
  value       = googleworkspace_org_unit.contractor_session.org_unit_path
}

output "break_glass_session_ou_path" {
  description = "OU path for break glass session policy"
  value       = googleworkspace_org_unit.break_glass_session.org_unit_path
}

output "effective_session_duration_hours" {
  description = "The resolved employee session duration in hours"
  value       = local.effective.session_duration_hours
}

output "effective_admin_session_duration_hours" {
  description = "The resolved admin session duration in hours"
  value       = local.effective.admin_session_duration_hours
}
