# =============================================================================
# [Narrative] User Schema Module
# Custom user profile schema fields for identity lifecycle and governance.
#
# Google Workspace custom schemas allow adding custom attributes to user
# profiles. These are used for:
# - HR data sync (employee ID, manager, dates)
# - Lifecycle management (start/end dates)
# - Access governance (risk level, last review date)
#
# All fields are managed via the googleworkspace_schema resource.
# =============================================================================

# -----------------------------------------------------------------------------
# Custom Schema — Narrative Identity Governance
# Single schema containing all custom fields for lifecycle management.
# -----------------------------------------------------------------------------

resource "googleworkspace_schema" "narrative_iga" {
  schema_name = "narrative_identity_governance"
  display_name = "Narrative Identity Governance"

  # Employee ID — Unique HR identifier for cross-system correlation
  dynamic "fields" {
    for_each = var.enable_employee_id ? [1] : []
    content {
      field_name      = "employee_id"
      field_type      = "STRING"
      display_name    = "Employee ID"
      multi_valued    = false
      read_access_type = "ADMINS_AND_SELF"

      numeric_indexing_spec {
        min_value = 0
        max_value = 999999
      }
    }
  }

  # Manager Email — Direct manager for approval workflows
  dynamic "fields" {
    for_each = var.enable_manager_email ? [1] : []
    content {
      field_name      = "manager_email"
      field_type      = "STRING"
      display_name    = "Manager Email"
      multi_valued    = false
      read_access_type = "ADMINS_AND_SELF"
    }
  }

  # Start Date — Employment start for onboarding automation
  dynamic "fields" {
    for_each = var.enable_start_date ? [1] : []
    content {
      field_name      = "start_date"
      field_type      = "DATE"
      display_name    = "Start Date"
      multi_valued    = false
      read_access_type = "ADMINS_AND_SELF"
    }
  }

  # End Date — Employment end for offboarding automation
  dynamic "fields" {
    for_each = var.enable_end_date ? [1] : []
    content {
      field_name      = "end_date"
      field_type      = "DATE"
      display_name    = "End Date"
      multi_valued    = false
      read_access_type = "ADMINS_AND_SELF"
    }
  }

  # Office Location — Physical office for location-based policies
  dynamic "fields" {
    for_each = var.enable_office_location ? [1] : []
    content {
      field_name      = "office_location"
      field_type      = "STRING"
      display_name    = "Office Location"
      multi_valued    = false
      read_access_type = "ADMINS_AND_SELF"
    }
  }

  # Risk Level — User risk tier for adaptive access policies
  dynamic "fields" {
    for_each = var.enable_risk_level ? [1] : []
    content {
      field_name      = "risk_level"
      field_type      = "STRING"
      display_name    = "Risk Level"
      multi_valued    = false
      read_access_type = "ADMINS_AND_SELF"
    }
  }

  # Last Access Review Date — Compliance tracking for access certifications
  dynamic "fields" {
    for_each = var.enable_last_access_review_date ? [1] : []
    content {
      field_name      = "last_access_review_date"
      field_type      = "DATE"
      display_name    = "Last Access Review Date"
      multi_valued    = false
      read_access_type = "ADMINS_AND_SELF"
    }
  }
}
