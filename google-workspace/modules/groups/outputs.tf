# =============================================================================
# [Narrative] Groups Module — Outputs
# =============================================================================

output "super_admins_id" {
  description = "Super Admins group ID"
  value       = googleworkspace_group.super_admins.id
}

output "all_employees_id" {
  description = "All Employees group ID"
  value       = googleworkspace_group.all_employees.id
}

output "contractors_id" {
  description = "Contractors group ID"
  value       = var.enable_contractor_group ? googleworkspace_group.contractors[0].id : null
}

output "break_glass_id" {
  description = "Break Glass group ID"
  value       = googleworkspace_group.break_glass.id
}

output "service_accounts_id" {
  description = "Service Accounts group ID"
  value       = googleworkspace_group.service_accounts.id
}

output "privileged_access_id" {
  description = "Privileged Access group ID"
  value       = googleworkspace_group.privileged_access.id
}

output "executive_leadership_id" {
  description = "Executive Leadership group ID"
  value       = var.enable_executive_group ? googleworkspace_group.executive_leadership[0].id : null
}

output "department_group_ids" {
  description = "Map of department name to group ID"
  value       = { for k, v in googleworkspace_group.department : k => v.id }
}

output "admin_group_ids" {
  description = "Map of all admin group names to IDs"
  value = {
    super_admins     = googleworkspace_group.super_admins.id
    groups_admins    = googleworkspace_group.groups_admins.id
    user_mgmt_admins = googleworkspace_group.user_mgmt_admins.id
    helpdesk_admins  = googleworkspace_group.helpdesk_admins.id
    services_admins  = googleworkspace_group.services_admins.id
    reporting_admins = googleworkspace_group.reporting_admins.id
    security_admins  = googleworkspace_group.security_admins.id
    mobile_admins    = googleworkspace_group.mobile_admins.id
  }
}

output "all_group_ids" {
  description = "Combined map of ALL group names to IDs — for modules that need cross-group references"
  value = merge(
    {
      super_admins     = googleworkspace_group.super_admins.id
      groups_admins    = googleworkspace_group.groups_admins.id
      user_mgmt_admins = googleworkspace_group.user_mgmt_admins.id
      helpdesk_admins  = googleworkspace_group.helpdesk_admins.id
      services_admins  = googleworkspace_group.services_admins.id
      reporting_admins = googleworkspace_group.reporting_admins.id
      security_admins  = googleworkspace_group.security_admins.id
      mobile_admins    = googleworkspace_group.mobile_admins.id
      security_team    = googleworkspace_group.security_team.id
      privileged_access = googleworkspace_group.privileged_access.id
      break_glass      = googleworkspace_group.break_glass.id
      service_accounts = googleworkspace_group.service_accounts.id
      all_employees    = googleworkspace_group.all_employees.id
    },
    var.enable_contractor_group ? { contractors = googleworkspace_group.contractors[0].id } : {},
    var.enable_executive_group ? { executive_leadership = googleworkspace_group.executive_leadership[0].id } : {},
    { for k, v in googleworkspace_group.department : "dept_${lower(replace(k, " ", "_"))}" => v.id },
  )
}

output "super_admins_email" {
  description = "Super Admins group email"
  value       = googleworkspace_group.super_admins.email
}

output "all_employees_email" {
  description = "All Employees group email"
  value       = googleworkspace_group.all_employees.email
}
