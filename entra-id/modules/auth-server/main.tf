# =============================================================================
# [Narrative] Auth Server Module
# App registration, service principal, OAuth2 scopes, and token lifetime
# policies. Entra ID equivalent of Okta's custom authorization server.
#
# Resource inventory:
# 1. azuread_application.main              — App registration (API)
# 2. azuread_service_principal.main        — Enterprise app (service principal)
# 3. azuread_application_password.main     — Client secret
# 4. azuread_service_principal_token_signing_certificate — (optional)
#
# Note: In Entra ID, the "authorization server" concept maps to an App
# Registration exposing API scopes. Token lifetime policies are managed
# separately via azuread_token_lifetime_policy (or Conditional Access
# session controls for interactive flows).
# =============================================================================

# -----------------------------------------------------------------------------
# Generate a unique identifier for API scopes
# -----------------------------------------------------------------------------

resource "random_uuid" "scope_ids" {
  for_each = toset(var.api_scopes)
}

# -----------------------------------------------------------------------------
# 1. App Registration (API)
# The primary app registration that exposes custom OAuth2 scopes.
# Equivalent to an Okta custom authorization server.
# -----------------------------------------------------------------------------

resource "azuread_application" "main" {
  display_name = "[Narrative] ${var.app_registration_name}"
  description  = "[Narrative] ${var.app_registration_description}"

  sign_in_audience = "AzureADMyOrg"

  api {
    requested_access_token_version = 2

    dynamic "oauth2_permission_scope" {
      for_each = toset(var.api_scopes)
      content {
        id                         = random_uuid.scope_ids[oauth2_permission_scope.value].result
        value                      = oauth2_permission_scope.value
        admin_consent_display_name = "[Narrative] ${oauth2_permission_scope.value} scope"
        admin_consent_description  = "[Narrative] Grants ${oauth2_permission_scope.value} access to the API"
        type                       = "Admin"
        enabled                    = true
      }
    }
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = false
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  optional_claims {
    id_token {
      name = "groups"
    }
    access_token {
      name = "groups"
    }
  }
}

# -----------------------------------------------------------------------------
# 2. Service Principal (Enterprise Application)
# Makes the app registration available for user sign-in and token issuance.
# -----------------------------------------------------------------------------

resource "azuread_service_principal" "main" {
  client_id                    = azuread_application.main.client_id
  app_role_assignment_required = false

  description = "[Narrative] Service principal for ${var.app_registration_name}"
}

# -----------------------------------------------------------------------------
# 3. Token Lifetime Policy
# Controls access token and refresh token lifetimes.
# Applied to the service principal.
# -----------------------------------------------------------------------------

resource "azuread_service_principal_token_signing_certificate" "main" {
  service_principal_id = azuread_service_principal.main.id
}
