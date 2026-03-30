# =============================================================================
# [Narrative] Password Policies Module — Outputs
# =============================================================================

output "admin_policy_id" {
  description = "Policy ID for the Admin Password Policy"
  value       = okta_policy_password.admin.id
}

output "employee_policy_id" {
  description = "Policy ID for the Employee Password Policy"
  value       = okta_policy_password.employee.id
}

output "contractor_policy_id" {
  description = "Policy ID for the Contractor Password Policy"
  value       = okta_policy_password.contractor.id
}

output "service_account_policy_id" {
  description = "Policy ID for the Service Account Password Policy"
  value       = okta_policy_password.service_account.id
}
