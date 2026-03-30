# =============================================================================
# [Narrative] Apps Module
# Template-driven application provisioning for OIDC, SAML, service (M2M),
# and bookmark applications.
#
# App inventory:
# 1. okta_app_oauth.oidc     — OIDC web applications (authorization_code)
# 2. okta_app_saml.saml      — SAML SP applications
# 3. okta_app_oauth.service  — OAuth2 service/M2M apps (client_credentials)
# 4. okta_app_bookmark.bookmark — Portal bookmark links
#
# Note: Group assignments are managed via lifecycle ignore_changes to allow
# external management (e.g., group rules, manual assignment) without drift.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. OIDC Web Applications
# -----------------------------------------------------------------------------

resource "okta_app_oauth" "oidc" {
  for_each = { for app in var.oidc_apps : app.label => app }

  label                      = each.value.label
  type                       = "web"
  grant_types                = each.value.grant_types
  response_types             = each.value.response_types
  redirect_uris              = each.value.redirect_uris
  post_logout_redirect_uris  = each.value.post_logout_redirect_uris
  token_endpoint_auth_method = each.value.token_endpoint_auth_method

}

# -----------------------------------------------------------------------------
# 2. SAML Applications
# -----------------------------------------------------------------------------

resource "okta_app_saml" "saml" {
  for_each = { for app in var.saml_apps : app.label => app }

  label                  = each.value.label
  sso_url                = each.value.sso_url
  recipient              = each.value.recipient
  destination            = each.value.destination
  audience               = each.value.audience
  subject_name_id_format = each.value.subject_name_format
}

# -----------------------------------------------------------------------------
# 3. Service / M2M Applications
# -----------------------------------------------------------------------------

resource "okta_app_oauth" "service" {
  for_each = { for app in var.service_apps : app.label => app }

  label          = each.value.label
  type           = "service"
  grant_types    = each.value.grant_types
  response_types = []
}

# -----------------------------------------------------------------------------
# 4. Bookmark Applications
# -----------------------------------------------------------------------------

resource "okta_app_bookmark" "bookmark" {
  for_each = { for app in var.bookmark_apps : app.label => app }

  label = each.value.label
  url   = each.value.url
}
