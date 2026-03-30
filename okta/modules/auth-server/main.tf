# =============================================================================
# [Narrative] Auth Server Module
# Custom authorization server with scopes, claims, and token policies.
#
# Resource inventory:
# 1. okta_auth_server.main              — Custom auth server
# 2. okta_auth_server_scope.scopes      — Custom scopes (read, write, admin)
# 3. okta_auth_server_claim.groups      — Groups claim
# 4. okta_auth_server_claim.department  — Department claim
# 5. okta_auth_server_claim.employee_type — Employee type claim
# 6. okta_auth_server_claim.manager     — Manager claim
# 7. okta_auth_server_claim.is_admin    — Admin boolean claim
# 8. okta_auth_server_policy.internal   — Internal apps token policy
# 9. okta_auth_server_policy_rule.internal — Internal apps policy rule
# 10. okta_auth_server_policy.service   — Service-to-service token policy
# 11. okta_auth_server_policy_rule.service — Service-to-service policy rule
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Custom Authorization Server
# -----------------------------------------------------------------------------

resource "okta_auth_server" "main" {
  name        = "[Narrative] ${var.auth_server_name}"
  description = "[Narrative] ${var.auth_server_description}"
  audiences   = ["api://default"]
  status      = "ACTIVE"
}

# -----------------------------------------------------------------------------
# 2. Custom Scopes
# -----------------------------------------------------------------------------

resource "okta_auth_server_scope" "scopes" {
  for_each = toset(var.scopes)

  auth_server_id   = okta_auth_server.main.id
  name             = each.value
  description      = "[Narrative] ${each.value} scope"
  consent          = "IMPLICIT"
  metadata_publish = "NO_CLIENTS"
}

# -----------------------------------------------------------------------------
# 3–7. Claims
# -----------------------------------------------------------------------------

resource "okta_auth_server_claim" "groups" {
  auth_server_id = okta_auth_server.main.id
  name           = "groups"
  value_type     = "GROUPS"
  group_filter_type = "REGEX"
  value          = ".*"
  claim_type     = "IDENTITY"
  scopes         = []
}

resource "okta_auth_server_claim" "department" {
  auth_server_id = okta_auth_server.main.id
  name           = "department"
  value_type     = "EXPRESSION"
  value          = "user.department"
  claim_type     = "IDENTITY"
  scopes         = []
}

resource "okta_auth_server_claim" "employee_type" {
  auth_server_id = okta_auth_server.main.id
  name           = "employee_type"
  value_type     = "EXPRESSION"
  value          = "user.employeeType"
  claim_type     = "IDENTITY"
  scopes         = []
}

resource "okta_auth_server_claim" "manager" {
  auth_server_id = okta_auth_server.main.id
  name           = "manager"
  value_type     = "EXPRESSION"
  value          = "user.manager"
  claim_type     = "IDENTITY"
  scopes         = []
}

resource "okta_auth_server_claim" "is_admin" {
  auth_server_id = okta_auth_server.main.id
  name           = "is_admin"
  value_type     = "EXPRESSION"
  value          = "isMemberOfGroupName(\"Super Admins\")"
  claim_type     = "IDENTITY"
  scopes         = []
}

# -----------------------------------------------------------------------------
# 8–9. Internal Apps Token Policy
# Applies to all clients — sets access/refresh token lifetimes based on
# the risk profile.
# -----------------------------------------------------------------------------

resource "okta_auth_server_policy" "internal" {
  auth_server_id = okta_auth_server.main.id
  name           = "[Narrative] Internal Applications"
  description    = "[Narrative] Token policy for internal web and mobile applications"
  priority       = 1
  client_whitelist = ["ALL_CLIENTS"]
  status         = "ACTIVE"
}

resource "okta_auth_server_policy_rule" "internal" {
  auth_server_id = okta_auth_server.main.id
  policy_id      = okta_auth_server_policy.internal.id
  name           = "[Narrative] Internal App Token Rule"
  priority       = 1
  grant_type_whitelist = ["authorization_code", "refresh_token"]

  access_token_lifetime_minutes  = local.effective.access_token_lifetime_minutes
  refresh_token_lifetime_minutes = local.effective.refresh_token_lifetime_days * 24 * 60

  status = "ACTIVE"
}

# -----------------------------------------------------------------------------
# 10–11. Service-to-Service Token Policy
# Applies to service/M2M apps using client_credentials grant.
# -----------------------------------------------------------------------------

resource "okta_auth_server_policy" "service" {
  auth_server_id = okta_auth_server.main.id
  name           = "[Narrative] Service-to-Service"
  description    = "[Narrative] Token policy for machine-to-machine API integrations"
  priority       = 2
  client_whitelist = ["ALL_CLIENTS"]
  status         = "ACTIVE"
}

resource "okta_auth_server_policy_rule" "service" {
  auth_server_id = okta_auth_server.main.id
  policy_id      = okta_auth_server_policy.service.id
  name           = "[Narrative] Service Token Rule"
  priority       = 1
  grant_type_whitelist = ["client_credentials"]

  access_token_lifetime_minutes = local.effective.service_token_lifetime_minutes

  status = "ACTIVE"
}
