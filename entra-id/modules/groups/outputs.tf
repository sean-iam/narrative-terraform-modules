# =============================================================================
# [Narrative] Groups Module — Outputs
# =============================================================================

output "global_admins_id" {
  description = "Global Admins group object ID"
  value       = azuread_group.global_admins.object_id
}

output "all_employees_id" {
  description = "All Employees group object ID"
  value       = azuread_group.all_employees.object_id
}

output "contractors_id" {
  description = "Contractors group object ID"
  value       = var.enable_contractor_group ? azuread_group.contractors[0].object_id : null
}

output "break_glass_id" {
  description = "Break Glass group object ID"
  value       = azuread_group.break_glass.object_id
}

output "service_accounts_id" {
  description = "Service Accounts group object ID"
  value       = azuread_group.service_accounts.object_id
}

output "privileged_access_id" {
  description = "Privileged Access group object ID"
  value       = azuread_group.privileged_access.object_id
}

output "executive_leadership_id" {
  description = "Executive Leadership group object ID"
  value       = var.enable_executive_group ? azuread_group.executive_leadership[0].object_id : null
}

output "geo_exception_ofac_id" {
  description = "OFAC geo-exception group object ID"
  value       = var.enable_geo_exception_groups ? azuread_group.geo_exception_ofac[0].object_id : null
}

output "geo_exception_non_ofac_id" {
  description = "Non-OFAC geo-exception group object ID"
  value       = var.enable_geo_exception_groups ? azuread_group.geo_exception_non_ofac[0].object_id : null
}

output "department_group_ids" {
  description = "Map of department name to group object ID"
  value       = { for k, v in azuread_group.department : k => v.object_id }
}

output "admin_group_ids" {
  description = "Map of all admin group names to object IDs"
  value = {
    global_admins            = azuread_group.global_admins.object_id
    user_admins              = azuread_group.user_admins.object_id
    application_admins       = azuread_group.application_admins.object_id
    helpdesk_admins          = azuread_group.helpdesk_admins.object_id
    security_admins          = azuread_group.security_admins.object_id
    readonly_admins          = azuread_group.readonly_admins.object_id
    groups_admins            = azuread_group.groups_admins.object_id
    conditional_access_admins = azuread_group.conditional_access_admins.object_id
  }
}

output "all_group_ids" {
  description = "Combined map of ALL group names to object IDs — for modules that need cross-group references"
  value = merge(
    {
      global_admins            = azuread_group.global_admins.object_id
      user_admins              = azuread_group.user_admins.object_id
      application_admins       = azuread_group.application_admins.object_id
      helpdesk_admins          = azuread_group.helpdesk_admins.object_id
      security_admins          = azuread_group.security_admins.object_id
      readonly_admins          = azuread_group.readonly_admins.object_id
      groups_admins            = azuread_group.groups_admins.object_id
      conditional_access_admins = azuread_group.conditional_access_admins.object_id
      security_team            = azuread_group.security_team.object_id
      privileged_access        = azuread_group.privileged_access.object_id
      break_glass              = azuread_group.break_glass.object_id
      service_accounts         = azuread_group.service_accounts.object_id
      all_employees            = azuread_group.all_employees.object_id
    },
    var.enable_contractor_group ? { contractors = azuread_group.contractors[0].object_id } : {},
    var.enable_executive_group ? { executive_leadership = azuread_group.executive_leadership[0].object_id } : {},
    { for k, v in azuread_group.department : "dept_${lower(replace(k, " ", "_"))}" => v.object_id },
  )
}
