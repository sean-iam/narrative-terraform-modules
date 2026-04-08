# =============================================================================
# Narrative Terraform Modules — Entra ID (Azure AD)
# Root composition — wires all modules together
# =============================================================================
# Modules will be added as they are built.
# Each module receives var.risk_profile and optional overrides.

module "groups" {
  source           = "./modules/groups"
  risk_profile     = var.risk_profile
  org_display_name = var.org_display_name

  enable_department_groups    = var.enable_department_groups
  departments                = var.departments
  enable_contractor_group    = var.enable_contractor_group
  enable_executive_group     = var.enable_executive_group
  enable_geo_exception_groups = var.enable_geo_exception_groups
  custom_groups              = var.custom_groups
}

module "authenticators" {
  source       = "./modules/authenticators"
  risk_profile = var.risk_profile

  mfa_method     = var.mfa_method
  enable_fido2   = var.enable_fido2
  enable_email_otp = var.enable_email_otp
  enable_phone_sms = var.enable_phone_sms
}

module "policies_password" {
  source       = "./modules/policies-password"
  risk_profile = var.risk_profile

  password_min_length               = var.password_min_length
  password_max_age_days             = var.password_max_age_days
  password_history_count            = var.password_history_count
  password_lockout_attempts         = var.password_lockout_attempts
  password_lockout_duration_seconds = var.password_lockout_duration_seconds
  enable_banned_password_list       = var.enable_banned_password_list
  banned_passwords                  = var.banned_passwords
}

module "network" {
  source       = "./modules/network"
  risk_profile = var.risk_profile

  trusted_cidrs             = var.trusted_cidrs
  ofac_countries            = var.ofac_countries
  enable_high_risk_blocking = var.enable_high_risk_blocking
  high_risk_countries       = var.high_risk_countries
  geo_mode                  = var.geo_mode
  allowlist_countries       = var.allowlist_countries
}

module "policies_conditional" {
  source       = "./modules/policies-conditional"
  risk_profile = var.risk_profile
  group_ids    = module.groups.all_group_ids

  trusted_location_id              = module.network.trusted_location_id
  ofac_location_id                 = module.network.ofac_location_id
  high_risk_location_id            = module.network.high_risk_location_id

  employee_sign_in_frequency_hours   = var.employee_sign_in_frequency_hours
  admin_sign_in_frequency_hours      = var.admin_sign_in_frequency_hours
  persistent_browser_session         = var.persistent_browser_session
  require_mfa_for_admins             = var.require_mfa_for_admins
  require_mfa_for_all_users          = var.require_mfa_for_all_users
  contractor_sign_in_frequency_hours = var.contractor_sign_in_frequency_hours
  block_legacy_auth                  = var.block_legacy_auth
}

module "behaviors" {
  source       = "./modules/behaviors"
  risk_profile = var.risk_profile
  group_ids    = module.groups.all_group_ids

  sign_in_risk_action = var.sign_in_risk_action
  user_risk_action    = var.user_risk_action
  sign_in_risk_level  = var.sign_in_risk_level
  user_risk_level     = var.user_risk_level
}

module "apps" {
  source = "./modules/apps"

  oidc_apps       = var.oidc_apps
  saml_apps       = var.saml_apps
  service_apps    = var.service_apps
  linked_sso_apps = var.linked_sso_apps
}

module "auth_server" {
  source       = "./modules/auth-server"
  risk_profile = var.risk_profile

  app_registration_name        = var.app_registration_name
  app_registration_description = var.app_registration_description
  api_scopes                   = var.api_scopes
  access_token_lifetime_minutes = var.access_token_lifetime_minutes
  id_token_lifetime_minutes     = var.id_token_lifetime_minutes
  refresh_token_lifetime_days   = var.refresh_token_lifetime_days
}

module "user_schema" {
  source = "./modules/user-schema"

  enable_employee_id             = var.enable_employee_id
  enable_manager_email           = var.enable_manager_email
  enable_start_date              = var.enable_start_date
  enable_end_date                = var.enable_end_date
  enable_office_location         = var.enable_office_location
  enable_risk_level              = var.enable_risk_level
  enable_last_access_review_date = var.enable_last_access_review_date
}

module "branding" {
  source = "./modules/branding"

  org_display_name                  = var.org_display_name
  primary_color                     = var.primary_color
  background_color                  = var.background_color
  enable_self_service_password_reset = var.enable_self_service_password_reset
  sign_in_page_text                 = var.sign_in_page_text
}

module "event_hooks" {
  source       = "./modules/event-hooks"
  risk_profile = var.risk_profile

  enable_audit_log_streaming   = var.enable_audit_log_streaming
  enable_sign_in_log_streaming = var.enable_sign_in_log_streaming
  log_analytics_workspace_id   = var.log_analytics_workspace_id
  storage_account_id           = var.storage_account_id
}
