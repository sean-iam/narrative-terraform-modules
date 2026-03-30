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
