# =============================================================================
# [Narrative] Password Policies Module — Outputs
# =============================================================================

output "admin_policy_ou_path" {
  description = "Organizational unit path for admin password policy"
  value       = googleworkspace_org_unit.admin_password_policy.org_unit_path
}

output "employee_policy_ou_path" {
  description = "Organizational unit path for employee password policy"
  value       = googleworkspace_org_unit.employee_password_policy.org_unit_path
}

output "service_account_ou_path" {
  description = "Organizational unit path for service account password policy"
  value       = googleworkspace_org_unit.service_account_policy.org_unit_path
}

output "effective_password_min_length" {
  description = "The resolved minimum password length for employees"
  value       = local.effective.password_min_length
}

output "effective_admin_password_min_length" {
  description = "The resolved minimum password length for admins"
  value       = local.effective.admin_password_min_length
}
