# =============================================================================
# [Narrative] Groups Module — Main
# =============================================================================

# -----------------------------------------------------------------------------
# Admin Groups
# -----------------------------------------------------------------------------

resource "okta_group" "super_admins" {
  name        = "Admins - Super"
  description = "[Narrative] Full administrative control. Break-glass only. Membership requires approval from two existing super admins."
}

resource "okta_group" "org_admins" {
  name        = "Admins - Org"
  description = "[Narrative] Day-to-day org administration. Can manage users, groups, apps. Cannot modify security policies or admin roles."
}

resource "okta_group" "app_admins" {
  name        = "Admins - Application"
  description = "[Narrative] Manage application assignments and configurations. Cannot modify users or security policies."
}

resource "okta_group" "helpdesk_admins" {
  name        = "Admins - Help Desk"
  description = "[Narrative] Reset passwords, unlock accounts, manage MFA. Cannot modify group membership or app assignments."
}

resource "okta_group" "readonly_admins" {
  name        = "Admins - Read Only"
  description = "[Narrative] View-only access to admin console. For auditors, compliance reviewers, and security monitoring."
}

resource "okta_group" "group_admins" {
  name        = "Admins - Group Membership"
  description = "[Narrative] Manage group membership for non-admin groups. Cannot create/delete groups or modify admin groups."
}

resource "okta_group" "api_access_admins" {
  name        = "Admins - API Access Management"
  description = "[Narrative] Manage authorization servers, scopes, claims, and access policies."
}

resource "okta_group" "report_admins" {
  name        = "Admins - Report"
  description = "[Narrative] Access to system log, reports, and audit data. Read-only operational visibility."
}

# -----------------------------------------------------------------------------
# Admin Role Assignments
# -----------------------------------------------------------------------------

resource "okta_group_role" "super_admins" {
  group_id  = okta_group.super_admins.id
  role_type = "SUPER_ADMIN"
}

resource "okta_group_role" "org_admins" {
  group_id  = okta_group.org_admins.id
  role_type = "ORG_ADMIN"
}

resource "okta_group_role" "app_admins" {
  group_id  = okta_group.app_admins.id
  role_type = "APP_ADMIN"
}

resource "okta_group_role" "helpdesk_admins" {
  group_id  = okta_group.helpdesk_admins.id
  role_type = "HELP_DESK_ADMIN"
}

resource "okta_group_role" "readonly_admins" {
  group_id  = okta_group.readonly_admins.id
  role_type = "READ_ONLY_ADMIN"
}

resource "okta_group_role" "api_access_admins" {
  group_id  = okta_group.api_access_admins.id
  role_type = "API_ACCESS_MANAGEMENT_ADMIN"
}

resource "okta_group_role" "report_admins" {
  group_id  = okta_group.report_admins.id
  role_type = "REPORT_ADMIN"
}

resource "okta_group_role" "group_admins_scoped" {
  group_id  = okta_group.group_admins.id
  role_type = "GROUP_MEMBERSHIP_ADMIN"
  target_group_list = concat(
    [okta_group.all_employees.id],
    var.enable_contractor_group ? [okta_group.contractors[0].id] : [],
    var.enable_executive_group ? [okta_group.executive_leadership[0].id] : [],
    [for g in okta_group.department : g.id],
  )
}

# -----------------------------------------------------------------------------
# Functional Groups
# -----------------------------------------------------------------------------

resource "okta_group" "security_team" {
  name        = "Security Team"
  description = "[Narrative] Security engineers and analysts. Targeted by stricter auth policies and granted security tooling access."
}

resource "okta_group" "privileged_access" {
  name        = "Privileged Access"
  description = "[Narrative] Temporary group for just-in-time elevated access. Membership should be time-bound and audited."
}

resource "okta_group" "break_glass" {
  name        = "Break Glass"
  description = "[Narrative] Emergency access accounts. Heavily monitored, requires post-use review. Max 2-3 members."
}

resource "okta_group" "service_accounts" {
  name        = "Service Accounts"
  description = "[Narrative] Non-human identities (API integrations, automation). Subject to separate auth policy with no MFA but IP restriction."
}

resource "okta_group" "all_employees" {
  name        = "All Employees"
  description = "[Narrative] All full-time and part-time employees. Auto-populated via HRIS sync or group rules."
}

# -----------------------------------------------------------------------------
# Conditional Groups — Contractors
# -----------------------------------------------------------------------------

resource "okta_group" "contractors" {
  count       = var.enable_contractor_group ? 1 : 0
  name        = "Contractors"
  description = "[Narrative] External contractors and consultants. Subject to stricter session controls and limited app access."
}

resource "okta_group_rule" "auto_contractors" {
  count             = var.enable_contractor_group ? 1 : 0
  name              = "Auto: Contractors"
  group_assignments = [okta_group.contractors[0].id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.userType==\"Contractor\""
  status            = "ACTIVE"
}

# -----------------------------------------------------------------------------
# Conditional Groups — Executive Leadership
# -----------------------------------------------------------------------------

resource "okta_group" "executive_leadership" {
  count       = var.enable_executive_group ? 1 : 0
  name        = "Executive Leadership"
  description = "[Narrative] C-suite and VP-level. Subject to enhanced phishing-resistant MFA. Limited but high-sensitivity app access."
}

# -----------------------------------------------------------------------------
# Group Rules — Auto-population
# -----------------------------------------------------------------------------

resource "okta_group_rule" "auto_all_employees" {
  name              = "Auto: All Employees"
  group_assignments = [okta_group.all_employees.id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.userType==\"Employee\""
  status            = "ACTIVE"
}

# -----------------------------------------------------------------------------
# Department Groups (dynamic)
# -----------------------------------------------------------------------------

resource "okta_group" "department" {
  for_each    = local.effective.enable_department_groups ? toset(var.departments) : toset([])
  name        = "Dept - ${each.value}"
  description = "[Narrative] Department group for ${each.value}. Auto-populated by department attribute."
}

resource "okta_group_rule" "department" {
  for_each          = local.effective.enable_department_groups ? toset(var.departments) : toset([])
  name              = "Auto: ${each.value}"
  group_assignments = [okta_group.department[each.value].id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.department==\"${each.value}\""
  status            = "ACTIVE"
}

# -----------------------------------------------------------------------------
# Geo-Exception Groups
# -----------------------------------------------------------------------------

resource "okta_group" "geo_exception_ofac" {
  count       = var.enable_geo_exception_groups ? 1 : 0
  name        = "Geo Exception - OFAC"
  description = "[Narrative] Users exempt from OFAC country geo-blocking. Requires documented business justification and periodic review."
}

resource "okta_group" "geo_exception_non_ofac" {
  count       = var.enable_geo_exception_groups ? 1 : 0
  name        = "Geo Exception - Non-OFAC"
  description = "[Narrative] Users exempt from non-OFAC geo-blocking (e.g., traveling employees). Time-bound membership recommended."
}

# -----------------------------------------------------------------------------
# Custom Groups
# -----------------------------------------------------------------------------

resource "okta_group" "custom" {
  for_each    = { for g in var.custom_groups : g.name => g }
  name        = each.value.name
  description = "[Narrative] ${each.value.description}"
}
