# =============================================================================
# Narrative Terraform Modules — Google Workspace
# Root composition — wires all modules together
# =============================================================================
# Modules will be added as they are built.
# Each module receives var.risk_profile and optional overrides.

module "groups" {
  source           = "./modules/groups"
  risk_profile     = var.risk_profile
  org_display_name = var.org_display_name
  org_domain       = var.org_domain

  enable_department_groups = var.enable_department_groups
  departments             = var.departments
  enable_contractor_group = var.enable_contractor_group
  enable_executive_group  = var.enable_executive_group
  custom_groups           = var.custom_groups
}

module "authenticators" {
  source       = "./modules/authenticators"
  risk_profile = var.risk_profile

  two_sv_enforcement       = var.two_sv_enforcement
  allowed_two_sv_methods   = var.allowed_two_sv_methods
  two_sv_grace_period_days = var.two_sv_grace_period_days
  enable_security_keys_only = var.enable_security_keys_only
}

module "policies_password" {
  source       = "./modules/policies-password"
  risk_profile = var.risk_profile

  password_min_length         = var.password_min_length
  password_max_age_days       = var.password_max_age_days
  password_reuse_count        = var.password_reuse_count
  password_enforce_strong     = var.password_enforce_strong
  admin_password_min_length   = var.admin_password_min_length
  admin_password_max_age_days = var.admin_password_max_age_days
}

module "policies_login" {
  source       = "./modules/policies-login"
  risk_profile = var.risk_profile
  group_ids    = module.groups.all_group_ids

  session_duration_hours       = var.session_duration_hours
  admin_session_duration_hours = var.admin_session_duration_hours
  enable_login_challenge       = var.enable_login_challenge
  require_reauth_for_sensitive = var.require_reauth_for_sensitive
}

module "network" {
  source       = "./modules/network"
  risk_profile = var.risk_profile
  group_ids    = module.groups.all_group_ids

  trusted_cidrs              = var.trusted_cidrs
  enable_context_aware_access = var.enable_context_aware_access
  enforce_ip_allowlist       = var.enforce_ip_allowlist
}

module "behaviors" {
  source       = "./modules/behaviors"
  risk_profile = var.risk_profile

  enable_suspicious_login_challenge = var.enable_suspicious_login_challenge
  account_recovery_method           = var.account_recovery_method
  enable_less_secure_apps_block     = var.enable_less_secure_apps_block
}

module "auth_server" {
  source       = "./modules/auth-server"
  risk_profile = var.risk_profile
  group_ids    = module.groups.all_group_ids

  enable_third_party_apps       = var.enable_third_party_apps
  enable_domain_wide_delegation = var.enable_domain_wide_delegation
  api_client_access             = var.api_client_access
  trusted_apps                  = var.trusted_apps
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

  primary_color            = var.primary_color
  secondary_color          = var.secondary_color
  logo_url                 = var.logo_url
  custom_login_page_enabled = var.custom_login_page_enabled
}

module "event_hooks" {
  source       = "./modules/event-hooks"
  risk_profile = var.risk_profile

  enable_security_alerts       = var.enable_security_alerts
  enable_admin_activity_alerts = var.enable_admin_activity_alerts
  alert_notification_email     = var.alert_notification_email
  audit_log_export_enabled     = var.audit_log_export_enabled
}

module "apps" {
  source    = "./modules/apps"
  group_ids = module.groups.all_group_ids

  pre_installed_apps       = var.pre_installed_apps
  saml_apps                = var.saml_apps
  blocked_apps             = var.blocked_apps
  app_access_ou_restrictions = var.app_access_ou_restrictions
}
