# =============================================================================
# Narrative Terraform Modules — Okta
# Root composition — wires all modules together
# =============================================================================
# Modules will be added as they are built.
# Each module receives var.risk_profile and optional overrides.

module "groups" {
  source           = "./modules/groups"
  risk_profile     = var.risk_profile
  org_display_name = var.org_display_name

  enable_department_groups     = var.enable_department_groups
  departments                  = var.departments
  enable_contractor_group      = var.enable_contractor_group
  enable_executive_group       = var.enable_executive_group
  enable_geo_exception_groups  = var.enable_geo_exception_groups
  custom_groups                = var.custom_groups
}

module "authenticators" {
  source       = "./modules/authenticators"
  risk_profile = var.risk_profile

  mfa_method                   = var.mfa_method
  enable_webauthn              = var.enable_webauthn
  enable_email_recovery        = var.enable_email_recovery
  email_token_lifetime_minutes = var.email_token_lifetime_minutes
}

module "policies_password" {
  source       = "./modules/policies-password"
  risk_profile = var.risk_profile
  group_ids    = module.groups.all_group_ids

  password_min_length               = var.password_min_length
  password_max_age_days             = var.password_max_age_days
  password_history_count            = var.password_history_count
  password_lockout_attempts         = var.password_lockout_attempts
  password_lockout_duration_minutes = var.password_lockout_duration_minutes
  admin_password_min_length         = var.admin_password_min_length
  admin_password_max_age_days       = var.admin_password_max_age_days
  enable_lockout_admin_notification = var.enable_lockout_admin_notification
}

module "network" {
  source       = "./modules/network"
  risk_profile = var.risk_profile

  trusted_cidrs                   = var.trusted_cidrs
  geo_exception_ofac_group_id     = module.groups.geo_exception_ofac_id
  geo_exception_non_ofac_group_id = module.groups.geo_exception_non_ofac_id

  ofac_countries            = var.ofac_countries
  enable_high_risk_blocking = var.enable_high_risk_blocking
  high_risk_countries       = var.high_risk_countries
  geo_mode                  = var.geo_mode
  allowlist_countries       = var.allowlist_countries
  enable_tor_blocking       = var.enable_tor_blocking
  threat_insight_action     = var.threat_insight_action
}

module "policies_signon" {
  source          = "./modules/policies-signon"
  risk_profile    = var.risk_profile
  group_ids       = module.groups.all_group_ids
  trusted_zone_id = module.network.trusted_zone_id

  employee_idle_timeout_minutes   = var.employee_idle_timeout_minutes
  admin_idle_timeout_minutes      = var.admin_idle_timeout_minutes
  max_session_lifetime_minutes    = var.max_session_lifetime_minutes
  mfa_prompt_mode                 = var.mfa_prompt_mode
  mfa_remember_device             = var.mfa_remember_device
  mfa_lifetime_minutes            = var.mfa_lifetime_minutes
  contractor_idle_timeout_minutes = var.contractor_idle_timeout_minutes
  break_glass_max_session_minutes = var.break_glass_max_session_minutes
}

module "behaviors" {
  source       = "./modules/behaviors"
  risk_profile = var.risk_profile

  velocity_threshold_kmh   = var.velocity_threshold_kmh
  impossible_travel_action = var.impossible_travel_action
  new_device_action        = var.new_device_action
  new_city_action          = var.new_city_action
}
