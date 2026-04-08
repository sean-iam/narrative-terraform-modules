# =============================================================================
# [Narrative] Apps Module
# Enterprise application provisioning for OIDC, SAML, service (M2M),
# and linked SSO applications.
#
# App inventory:
# 1. azuread_application + azuread_service_principal — OIDC web apps
# 2. azuread_application + azuread_service_principal — SAML apps
# 3. azuread_application + azuread_service_principal — Service/M2M apps
# 4. azuread_service_principal (linked) — Linked SSO portal links
#
# Note: In Entra ID, every application requires both an App Registration
# (azuread_application) and a Service Principal (azuread_service_principal)
# to be usable for sign-in.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. OIDC Web Applications
# App registrations with redirect URIs for authorization_code flow.
# -----------------------------------------------------------------------------

resource "azuread_application" "oidc" {
  for_each = { for app in var.oidc_apps : app.display_name => app }

  display_name = each.value.display_name

  sign_in_audience = "AzureADMyOrg"

  web {
    redirect_uris = each.value.redirect_uris
    logout_url    = each.value.logout_url

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
}

resource "azuread_service_principal" "oidc" {
  for_each  = azuread_application.oidc
  client_id = each.value.client_id
}

# -----------------------------------------------------------------------------
# 2. SAML Applications
# App registrations configured for SAML-based SSO.
# -----------------------------------------------------------------------------

resource "azuread_application" "saml" {
  for_each = { for app in var.saml_apps : app.display_name => app }

  display_name    = each.value.display_name
  identifier_uris = each.value.identifier_uris

  sign_in_audience = "AzureADMyOrg"

  web {
    redirect_uris = each.value.reply_urls
  }
}

resource "azuread_service_principal" "saml" {
  for_each                     = azuread_application.saml
  client_id                    = each.value.client_id
  preferred_single_sign_on_mode = "saml"

  saml_single_sign_on {
    relay_state = null
  }
}

# -----------------------------------------------------------------------------
# 3. Service / M2M Applications
# App registrations for machine-to-machine communication (client_credentials).
# No redirect URIs needed — uses client_id + client_secret.
# -----------------------------------------------------------------------------

resource "azuread_application" "service" {
  for_each = { for app in var.service_apps : app.display_name => app }

  display_name     = each.value.display_name
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "service" {
  for_each  = azuread_application.service
  client_id = each.value.client_id
}

resource "azuread_application_password" "service" {
  for_each       = azuread_application.service
  application_id = each.value.id
  display_name   = "[Narrative] Service credential"
}
