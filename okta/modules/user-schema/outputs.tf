# =============================================================================
# [Narrative] User Schema Module — Outputs
# =============================================================================

output "employee_id_index" {
  description = "Schema property index for employee_id (null if disabled)"
  value       = var.enable_employee_id ? okta_user_schema_property.employee_id[0].index : null
}

output "manager_email_index" {
  description = "Schema property index for manager_email (null if disabled)"
  value       = var.enable_manager_email ? okta_user_schema_property.manager_email[0].index : null
}

output "start_date_index" {
  description = "Schema property index for start_date (null if disabled)"
  value       = var.enable_start_date ? okta_user_schema_property.start_date[0].index : null
}

output "end_date_index" {
  description = "Schema property index for end_date (null if disabled)"
  value       = var.enable_end_date ? okta_user_schema_property.end_date[0].index : null
}

output "office_location_index" {
  description = "Schema property index for office_location (null if disabled)"
  value       = var.enable_office_location ? okta_user_schema_property.office_location[0].index : null
}

output "risk_level_index" {
  description = "Schema property index for risk_level (null if disabled)"
  value       = var.enable_risk_level ? okta_user_schema_property.risk_level[0].index : null
}

output "last_access_review_date_index" {
  description = "Schema property index for last_access_review_date (null if disabled)"
  value       = var.enable_last_access_review_date ? okta_user_schema_property.last_access_review_date[0].index : null
}

output "all_enabled_attributes" {
  description = "List of enabled custom attribute names"
  value = compact([
    var.enable_employee_id ? "employee_id" : "",
    var.enable_manager_email ? "manager_email" : "",
    var.enable_start_date ? "start_date" : "",
    var.enable_end_date ? "end_date" : "",
    var.enable_office_location ? "office_location" : "",
    var.enable_risk_level ? "risk_level" : "",
    var.enable_last_access_review_date ? "last_access_review_date" : "",
  ])
}
