# =============================================================================
# [Narrative] Groups Module — Outputs
# =============================================================================

output "super_admins_id" {
  description = "Super Admins group ID"
  value       = okta_group.super_admins.id
}

output "all_employees_id" {
  description = "All Employees group ID"
  value       = okta_group.all_employees.id
}

output "contractors_id" {
  description = "Contractors group ID"
  value       = var.enable_contractor_group ? okta_group.contractors[0].id : null
}

output "break_glass_id" {
  description = "Break Glass group ID"
  value       = okta_group.break_glass.id
}

output "service_accounts_id" {
  description = "Service Accounts group ID"
  value       = okta_group.service_accounts.id
}

output "privileged_access_id" {
  description = "Privileged Access group ID"
  value       = okta_group.privileged_access.id
}

output "executive_leadership_id" {
  description = "Executive Leadership group ID"
  value       = var.enable_executive_group ? okta_group.executive_leadership[0].id : null
}

output "geo_exception_ofac_id" {
  description = "OFAC geo-exception group ID"
  value       = var.enable_geo_exception_groups ? okta_group.geo_exception_ofac[0].id : null
}

output "geo_exception_non_ofac_id" {
  description = "Non-OFAC geo-exception group ID"
  value       = var.enable_geo_exception_groups ? okta_group.geo_exception_non_ofac[0].id : null
}

output "department_group_ids" {
  description = "Map of department name to group ID"
  value       = { for k, v in okta_group.department : k => v.id }
}

output "admin_group_ids" {
  description = "Map of all admin group names to IDs"
  value = {
    super_admins      = okta_group.super_admins.id
    org_admins        = okta_group.org_admins.id
    app_admins        = okta_group.app_admins.id
    helpdesk_admins   = okta_group.helpdesk_admins.id
    readonly_admins   = okta_group.readonly_admins.id
    group_admins      = okta_group.group_admins.id
    api_access_admins = okta_group.api_access_admins.id
    report_admins     = okta_group.report_admins.id
  }
}

output "all_group_ids" {
  description = "Combined map of ALL group names to IDs — for modules that need cross-group references"
  value = merge(
    {
      super_admins      = okta_group.super_admins.id
      org_admins        = okta_group.org_admins.id
      app_admins        = okta_group.app_admins.id
      helpdesk_admins   = okta_group.helpdesk_admins.id
      readonly_admins   = okta_group.readonly_admins.id
      group_admins      = okta_group.group_admins.id
      api_access_admins = okta_group.api_access_admins.id
      report_admins     = okta_group.report_admins.id
      security_team     = okta_group.security_team.id
      privileged_access = okta_group.privileged_access.id
      break_glass       = okta_group.break_glass.id
      service_accounts  = okta_group.service_accounts.id
      all_employees     = okta_group.all_employees.id
    },
    var.enable_contractor_group ? { contractors = okta_group.contractors[0].id } : {},
    var.enable_executive_group ? { executive_leadership = okta_group.executive_leadership[0].id } : {},
    { for k, v in okta_group.department : "dept_${lower(replace(k, " ", "_"))}" => v.id },
  )
}
