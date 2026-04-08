# =============================================================================
# [Narrative] User Schema Module — Outputs
# =============================================================================

output "extensions_app_id" {
  description = "Object ID of the app registration hosting directory extensions"
  value       = azuread_application_registration.extensions.id
}

output "enabled_attributes" {
  description = "Map of attribute names to their enabled status"
  value = {
    employee_id             = var.enable_employee_id
    manager_email           = var.enable_manager_email
    start_date              = var.enable_start_date
    end_date                = var.enable_end_date
    office_location         = var.enable_office_location
    risk_level              = var.enable_risk_level
    last_access_review_date = var.enable_last_access_review_date
  }
}
