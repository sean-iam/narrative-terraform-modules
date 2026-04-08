# =============================================================================
# [Narrative] Password Policies Module — Main
# Google Workspace password policies via organizational unit settings.
#
# Google Workspace manages password policies at the OU level through the
# Admin SDK. The googleworkspace provider does not have a dedicated password
# policy resource. This module creates OUs that document the intended
# password policy configuration and uses schema properties to track settings.
#
# Policy tiers:
# 1. Admin Password Policy — strictest, for admin role groups
# 2. Employee Password Policy — standard, for all employees
# 3. Service Account OU — no interactive login, managed credentials
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Admin Password Policy OU
# Organizational unit for admin accounts with stricter password requirements.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "admin_password_policy" {
  name                 = "Admin Accounts"
  description          = "[Narrative] Admin password policy OU. Min length: ${local.effective.admin_password_min_length}. Max age: ${local.effective.admin_password_max_age_days} days. Reuse count: ${local.effective.password_reuse_count}. Strong passwords: enforced."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2. Employee Password Policy OU
# Standard employees get baseline password requirements.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "employee_password_policy" {
  name                 = "Employee Accounts"
  description          = "[Narrative] Employee password policy OU. Min length: ${local.effective.password_min_length}. Max age: ${local.effective.password_max_age_days} days. Reuse count: ${local.effective.password_reuse_count}. Strong passwords: ${local.effective.password_enforce_strong}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 3. Service Account OU
# Non-human identities with managed credentials.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "service_account_policy" {
  name                 = "Service Accounts"
  description          = "[Narrative] Service account OU. Min length: ${local.effective.admin_password_min_length}. Max age: ${local.effective.admin_password_max_age_days} days. No interactive login — credentials managed via secrets manager."
  parent_org_unit_path = "/"
}
