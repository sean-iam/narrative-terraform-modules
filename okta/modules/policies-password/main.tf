# =============================================================================
# [Narrative] Password Policies Module — Main
# =============================================================================

# -----------------------------------------------------------------------------
# Admin Password Policy (Priority 1)
# Applies to all administrator role groups.
# -----------------------------------------------------------------------------

resource "okta_policy_password" "admin" {
  name        = "Admin Password Policy"
  description = "[Narrative] Password policy for administrator accounts. Requires ${local.effective.admin_password_min_length}-character passwords with ${local.effective.admin_password_max_age_days}-day rotation."
  priority    = 1
  status      = "ACTIVE"

  groups_included = [
    var.group_ids["super_admins"],
    var.group_ids["org_admins"],
    var.group_ids["app_admins"],
    var.group_ids["helpdesk_admins"],
    var.group_ids["api_access_admins"],
  ]

  password_min_length            = local.effective.admin_password_min_length
  password_min_lowercase         = 1
  password_min_uppercase         = 1
  password_min_number            = 1
  password_min_symbol            = 1
  password_exclude_username      = true
  password_exclude_first_name    = true
  password_exclude_last_name     = true
  password_dictionary_lookup     = true
  password_max_age_days          = local.effective.admin_password_max_age_days
  password_history_count         = local.effective.password_history_count
  password_min_age_minutes       = 60
  password_max_lockout_attempts  = local.effective.password_lockout_attempts
  password_auto_unlock_minutes   = local.effective.password_lockout_duration_minutes
  password_show_lockout_failures = local.effective.enable_lockout_admin_notification

  recovery_email_token = 10080
  email_recovery       = "ACTIVE"
  sms_recovery         = "INACTIVE"
  call_recovery        = "INACTIVE"
  question_recovery    = "INACTIVE"
}

# -----------------------------------------------------------------------------
# Employee Password Policy (Priority 2)
# Applies to all full-time and part-time employees.
# -----------------------------------------------------------------------------

resource "okta_policy_password" "employee" {
  name        = "Employee Password Policy"
  description = "[Narrative] Password policy for employees. Requires ${local.effective.password_min_length}-character passwords with ${local.effective.password_max_age_days}-day rotation."
  priority    = 2
  status      = "ACTIVE"

  groups_included = [
    var.group_ids["all_employees"],
  ]

  password_min_length            = local.effective.password_min_length
  password_min_lowercase         = 1
  password_min_uppercase         = 1
  password_min_number            = 1
  password_min_symbol            = 1
  password_exclude_username      = true
  password_exclude_first_name    = true
  password_exclude_last_name     = true
  password_dictionary_lookup     = true
  password_max_age_days          = local.effective.password_max_age_days
  password_history_count         = local.effective.password_history_count
  password_min_age_minutes       = 60
  password_max_lockout_attempts  = local.effective.password_lockout_attempts
  password_auto_unlock_minutes   = local.effective.password_lockout_duration_minutes
  password_show_lockout_failures = false

  recovery_email_token = 10080
  email_recovery       = "ACTIVE"
  sms_recovery         = "INACTIVE"
  call_recovery        = "INACTIVE"
  question_recovery    = "INACTIVE"
}

# -----------------------------------------------------------------------------
# Contractor Password Policy (Priority 2)
# Applies to contractors. Group may not exist if enable_contractor_group=false.
# -----------------------------------------------------------------------------

resource "okta_policy_password" "contractor" {
  depends_on = [okta_policy_password.admin]

  name        = "Contractor Password Policy"
  description = "[Narrative] Password policy for contractors and consultants. Requires ${local.effective.password_min_length}-character passwords with ${local.effective.password_max_age_days}-day rotation."
  priority    = 2
  status      = "ACTIVE"

  groups_included = try([var.group_ids["contractors"]], [])

  password_min_length            = local.effective.password_min_length
  password_min_lowercase         = 1
  password_min_uppercase         = 1
  password_min_number            = 1
  password_min_symbol            = 1
  password_exclude_username      = true
  password_exclude_first_name    = true
  password_exclude_last_name     = true
  password_dictionary_lookup     = true
  password_max_age_days          = local.effective.password_max_age_days
  password_history_count         = local.effective.password_history_count
  password_min_age_minutes       = 60
  password_max_lockout_attempts  = local.effective.password_lockout_attempts
  password_auto_unlock_minutes   = local.effective.password_lockout_duration_minutes
  password_show_lockout_failures = false

  recovery_email_token = 10080
  email_recovery       = "ACTIVE"
  sms_recovery         = "INACTIVE"
  call_recovery        = "INACTIVE"
  question_recovery    = "INACTIVE"
}

# -----------------------------------------------------------------------------
# Service Account Password Policy (Priority 3)
# Applies to non-human identities. No recovery methods — managed by IT ops.
# -----------------------------------------------------------------------------

resource "okta_policy_password" "service_account" {
  depends_on = [okta_policy_password.contractor]

  name        = "Service Account Password Policy"
  description = "[Narrative] Password policy for service accounts and API integrations. Requires ${local.effective.admin_password_min_length}-character passwords with ${local.effective.admin_password_max_age_days}-day rotation. Recovery disabled — credentials managed via secrets manager."
  priority    = 3
  status      = "ACTIVE"

  groups_included = [
    var.group_ids["service_accounts"],
  ]

  password_min_length            = local.effective.admin_password_min_length
  password_min_lowercase         = 1
  password_min_uppercase         = 1
  password_min_number            = 1
  password_min_symbol            = 1
  password_exclude_username      = true
  password_exclude_first_name    = true
  password_exclude_last_name     = true
  password_dictionary_lookup     = true
  password_max_age_days          = local.effective.admin_password_max_age_days
  password_history_count         = local.effective.password_history_count
  password_min_age_minutes       = 60
  password_max_lockout_attempts  = local.effective.password_lockout_attempts
  password_auto_unlock_minutes   = local.effective.password_lockout_duration_minutes
  password_show_lockout_failures = true

  recovery_email_token = 10080
  email_recovery       = "INACTIVE"
  sms_recovery         = "INACTIVE"
  call_recovery        = "INACTIVE"
  question_recovery    = "INACTIVE"
}
