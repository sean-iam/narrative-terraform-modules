# =============================================================================
# [Narrative] Sign-On Policies Module — Outputs
# =============================================================================

output "global_session_policy_id" {
  description = "Policy ID for the Global Session Policy (EVERYONE catch-all)"
  value       = okta_policy_signon.global_session.id
}

output "break_glass_policy_id" {
  description = "Policy ID for the Break Glass Policy"
  value       = okta_policy_signon.break_glass.id
}

output "service_accounts_policy_id" {
  description = "Policy ID for the Service Account Policy"
  value       = okta_policy_signon.service_accounts.id
}

output "admins_policy_id" {
  description = "Policy ID for the Admin Sign-On Policy"
  value       = okta_policy_signon.admins.id
}

output "executives_policy_id" {
  description = "Policy ID for the Executive Sign-On Policy (null if executive_leadership group not provisioned)"
  value       = try(okta_policy_signon.executives[0].id, null)
}

output "contractors_policy_id" {
  description = "Policy ID for the Contractor Sign-On Policy (null if contractors group not provisioned)"
  value       = try(okta_policy_signon.contractors[0].id, null)
}

output "employees_policy_id" {
  description = "Policy ID for the Employee Sign-On Policy"
  value       = okta_policy_signon.employees.id
}

output "all_policy_ids" {
  description = "Map of policy names to IDs for all sign-on policies"
  value = merge(
    {
      global_session   = okta_policy_signon.global_session.id
      break_glass      = okta_policy_signon.break_glass.id
      service_accounts = okta_policy_signon.service_accounts.id
      admins           = okta_policy_signon.admins.id
      employees        = okta_policy_signon.employees.id
    },
    try(okta_policy_signon.executives[0].id, null) != null ? { executives = okta_policy_signon.executives[0].id } : {},
    try(okta_policy_signon.contractors[0].id, null) != null ? { contractors = okta_policy_signon.contractors[0].id } : {},
  )
}
