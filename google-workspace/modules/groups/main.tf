# =============================================================================
# [Narrative] Groups Module — Main
# Google Workspace groups for admin roles, functional teams, departments,
# and custom purposes.
# =============================================================================

# -----------------------------------------------------------------------------
# Admin Role Groups
# These groups are assigned admin roles in Google Workspace.
# -----------------------------------------------------------------------------

resource "googleworkspace_group" "super_admins" {
  email       = "admins-super@${var.org_domain}"
  name        = "Admins - Super"
  description = "[Narrative] Full administrative control. Break-glass only. Membership requires approval from two existing super admins."
}

resource "googleworkspace_group" "groups_admins" {
  email       = "admins-groups@${var.org_domain}"
  name        = "Admins - Groups"
  description = "[Narrative] Manage group membership for non-admin groups. Cannot create/delete admin groups."
}

resource "googleworkspace_group" "user_mgmt_admins" {
  email       = "admins-user-mgmt@${var.org_domain}"
  name        = "Admins - User Management"
  description = "[Narrative] Create, suspend, and manage user accounts. Cannot modify admin roles or security policies."
}

resource "googleworkspace_group" "helpdesk_admins" {
  email       = "admins-helpdesk@${var.org_domain}"
  name        = "Admins - Help Desk"
  description = "[Narrative] Reset passwords, view user details. Cannot modify group membership or app assignments."
}

resource "googleworkspace_group" "services_admins" {
  email       = "admins-services@${var.org_domain}"
  name        = "Admins - Services"
  description = "[Narrative] Manage Google Workspace services and app settings. Cannot modify users or security policies."
}

resource "googleworkspace_group" "reporting_admins" {
  email       = "admins-reporting@${var.org_domain}"
  name        = "Admins - Reporting"
  description = "[Narrative] Access to audit logs, reports, and usage data. Read-only operational visibility."
}

resource "googleworkspace_group" "security_admins" {
  email       = "admins-security@${var.org_domain}"
  name        = "Admins - Security"
  description = "[Narrative] Manage security settings, 2SV enforcement, and security investigations."
}

resource "googleworkspace_group" "mobile_admins" {
  email       = "admins-mobile@${var.org_domain}"
  name        = "Admins - Mobile"
  description = "[Narrative] Manage mobile device policies and endpoint management."
}

# -----------------------------------------------------------------------------
# Admin Role Assignments
# Google Workspace admin roles are assigned via googleworkspace_role_assignment
# but role IDs must be discovered at runtime. These are documented as
# well-known role IDs in the Google Admin SDK.
#
# NOTE: Role assignments require the role ID from the Admin SDK. The provider
# does not have a dedicated admin role assignment resource. Admin role
# assignment should be done via the Admin Console or Admin SDK API.
# The groups above serve as the targeting mechanism for policies.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Functional Groups
# -----------------------------------------------------------------------------

resource "googleworkspace_group" "security_team" {
  email       = "security-team@${var.org_domain}"
  name        = "Security Team"
  description = "[Narrative] Security engineers and analysts. Targeted by stricter auth policies and granted security tooling access."
}

resource "googleworkspace_group" "privileged_access" {
  email       = "privileged-access@${var.org_domain}"
  name        = "Privileged Access"
  description = "[Narrative] Temporary group for just-in-time elevated access. Membership should be time-bound and audited."
}

resource "googleworkspace_group" "break_glass" {
  email       = "break-glass@${var.org_domain}"
  name        = "Break Glass"
  description = "[Narrative] Emergency access accounts. Heavily monitored, requires post-use review. Max 2-3 members."
}

resource "googleworkspace_group" "service_accounts" {
  email       = "service-accounts@${var.org_domain}"
  name        = "Service Accounts"
  description = "[Narrative] Non-human identities (API integrations, automation). Subject to separate auth policy with IP restriction."
}

resource "googleworkspace_group" "all_employees" {
  email       = "all-employees@${var.org_domain}"
  name        = "All Employees"
  description = "[Narrative] All full-time and part-time employees. Managed via HR sync or directory rules."
}

# -----------------------------------------------------------------------------
# Group Settings — All Employees
# Controls who can post, join, and view the group.
# -----------------------------------------------------------------------------

resource "googleworkspace_group_settings" "all_employees" {
  email = googleworkspace_group.all_employees.email

  who_can_join               = "INVITED_CAN_JOIN"
  who_can_view_membership    = "ALL_IN_DOMAIN_CAN_VIEW"
  who_can_view_group         = "ALL_IN_DOMAIN_CAN_VIEW"
  who_can_post_message       = "ALL_IN_DOMAIN_CAN_POST"
  allow_external_members     = false
  is_archived                = false
  members_can_post_as_the_group = false
}

# -----------------------------------------------------------------------------
# Conditional Groups — Contractors
# -----------------------------------------------------------------------------

resource "googleworkspace_group" "contractors" {
  count       = var.enable_contractor_group ? 1 : 0
  email       = "contractors@${var.org_domain}"
  name        = "Contractors"
  description = "[Narrative] External contractors and consultants. Subject to stricter session controls and limited app access."
}

resource "googleworkspace_group_settings" "contractors" {
  count = var.enable_contractor_group ? 1 : 0
  email = googleworkspace_group.contractors[0].email

  who_can_join               = "INVITED_CAN_JOIN"
  who_can_view_membership    = "ALL_MANAGERS_CAN_VIEW"
  who_can_view_group         = "ALL_IN_DOMAIN_CAN_VIEW"
  who_can_post_message       = "ALL_MEMBERS_CAN_POST"
  allow_external_members     = true
  is_archived                = false
  members_can_post_as_the_group = false
}

# -----------------------------------------------------------------------------
# Conditional Groups — Executive Leadership
# -----------------------------------------------------------------------------

resource "googleworkspace_group" "executive_leadership" {
  count       = var.enable_executive_group ? 1 : 0
  email       = "executive-leadership@${var.org_domain}"
  name        = "Executive Leadership"
  description = "[Narrative] C-suite and VP-level. Subject to enhanced phishing-resistant 2SV. Limited but high-sensitivity app access."
}

resource "googleworkspace_group_settings" "executive_leadership" {
  count = var.enable_executive_group ? 1 : 0
  email = googleworkspace_group.executive_leadership[0].email

  who_can_join               = "INVITED_CAN_JOIN"
  who_can_view_membership    = "ALL_MANAGERS_CAN_VIEW"
  who_can_view_group         = "ALL_MANAGERS_CAN_VIEW"
  who_can_post_message       = "ALL_MEMBERS_CAN_POST"
  allow_external_members     = false
  is_archived                = false
  members_can_post_as_the_group = false
}

# -----------------------------------------------------------------------------
# Department Groups (dynamic)
# -----------------------------------------------------------------------------

resource "googleworkspace_group" "department" {
  for_each    = local.effective.enable_department_groups ? toset(var.departments) : toset([])
  email       = "dept-${lower(replace(each.value, " ", "-"))}@${var.org_domain}"
  name        = "Dept - ${each.value}"
  description = "[Narrative] Department group for ${each.value}. Managed via directory sync or manual assignment."
}

resource "googleworkspace_group_settings" "department" {
  for_each = local.effective.enable_department_groups ? toset(var.departments) : toset([])
  email    = googleworkspace_group.department[each.value].email

  who_can_join               = "INVITED_CAN_JOIN"
  who_can_view_membership    = "ALL_IN_DOMAIN_CAN_VIEW"
  who_can_view_group         = "ALL_IN_DOMAIN_CAN_VIEW"
  who_can_post_message       = "ALL_MEMBERS_CAN_POST"
  allow_external_members     = false
  is_archived                = false
  members_can_post_as_the_group = false
}

# -----------------------------------------------------------------------------
# Custom Groups
# -----------------------------------------------------------------------------

resource "googleworkspace_group" "custom" {
  for_each    = { for g in var.custom_groups : g.name => g }
  email       = "${lower(replace(each.value.name, " ", "-"))}@${var.org_domain}"
  name        = each.value.name
  description = "[Narrative] ${each.value.description}"
}

resource "googleworkspace_group_settings" "custom" {
  for_each = { for g in var.custom_groups : g.name => g }
  email    = googleworkspace_group.custom[each.key].email

  who_can_join               = "INVITED_CAN_JOIN"
  who_can_view_membership    = "ALL_IN_DOMAIN_CAN_VIEW"
  who_can_view_group         = "ALL_IN_DOMAIN_CAN_VIEW"
  who_can_post_message       = "ALL_MEMBERS_CAN_POST"
  allow_external_members     = false
  is_archived                = false
  members_can_post_as_the_group = false
}
