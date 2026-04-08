# =============================================================================
# [Narrative] User Schema Module
# Directory extension attributes for custom user properties.
#
# Entra ID supports two types of custom attributes:
# 1. Extension attributes (extension_<appId>_<name>) — via app registration
# 2. Open extensions — for application-specific data
#
# This module uses directory extensions via an app registration, which is the
# standard approach for custom user attributes that need to be available
# across the directory (similar to Okta custom profile attributes).
#
# Attribute inventory:
# 1. employee_id             — Unique HR identifier
# 2. manager_email           — Direct manager email
# 3. start_date              — Employment start date
# 4. end_date                — Employment end date
# 5. office_location         — Physical office location
# 6. risk_level              — User risk tier: low/medium/high/critical
# 7. last_access_review_date — Last access certification date
# =============================================================================

# -----------------------------------------------------------------------------
# Extension App Registration
# Directory extensions require an app registration to host the extension
# properties. This is a technical requirement — the app itself is not used
# for authentication.
# -----------------------------------------------------------------------------

resource "azuread_application_registration" "extensions" {
  display_name = "[Narrative] Directory Extensions Host"
}

# -----------------------------------------------------------------------------
# 1. Employee ID
# Unique identifier from the HR system. Used for cross-system correlation.
# -----------------------------------------------------------------------------

resource "azuread_application_optional_claims" "extensions" {
  application_id = azuread_application_registration.extensions.id

  access_token {
    name = "groups"
  }
}

resource "terraform_data" "extension_attributes" {
  input = {
    app_object_id = azuread_application_registration.extensions.id
    attributes = {
      employee_id             = var.enable_employee_id
      manager_email           = var.enable_manager_email
      start_date              = var.enable_start_date
      end_date                = var.enable_end_date
      office_location         = var.enable_office_location
      risk_level              = var.enable_risk_level
      last_access_review_date = var.enable_last_access_review_date
    }
  }
}

# Note: The azuread provider does not have a direct resource for directory
# extension properties (extension_<appId>_<name>). These are typically
# created via the Microsoft Graph API:
#
# POST /applications/<app-object-id>/extensionProperties
# {
#   "name": "employee_id",
#   "dataType": "String",
#   "targetObjects": ["User"]
# }
#
# The terraform_data resource above tracks the intended configuration.
# Use the Graph API or Azure portal to create the actual extension properties.
# Future versions of the azuread provider may add native support.
#
# Attribute names in the directory will be:
# extension_<appClientId_no_hyphens>_employee_id
# extension_<appClientId_no_hyphens>_manager_email
# extension_<appClientId_no_hyphens>_start_date
# extension_<appClientId_no_hyphens>_end_date
# extension_<appClientId_no_hyphens>_office_location
# extension_<appClientId_no_hyphens>_risk_level
# extension_<appClientId_no_hyphens>_last_access_review_date
