# =============================================================================
# [Narrative] Groups Module — Main
# Entra ID security groups, role-assignable groups, and dynamic membership rules.
#
# Group inventory:
# 1. Admin role-assignable groups (Global Admin, User Admin, etc.)
# 2. Functional groups (Security Team, Privileged Access, Break Glass, etc.)
# 3. Department groups (dynamic membership)
# 4. Geo-exception groups
# 5. Custom groups
# =============================================================================

# -----------------------------------------------------------------------------
# Admin Role-Assignable Groups
# These groups are role-assignable so they can be assigned Entra ID directory
# roles. Members automatically receive the corresponding admin permissions.
# -----------------------------------------------------------------------------

resource "azuread_group" "global_admins" {
  display_name     = "Admins - Global"
  description      = "[Narrative] Full administrative control. Break-glass only. Membership requires approval from two existing global admins."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

resource "azuread_group" "user_admins" {
  display_name     = "Admins - User"
  description      = "[Narrative] Day-to-day user administration. Can manage users, reset passwords, manage licenses. Cannot modify security policies or admin roles."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

resource "azuread_group" "application_admins" {
  display_name     = "Admins - Application"
  description      = "[Narrative] Manage application registrations and enterprise apps. Cannot modify users or security policies."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

resource "azuread_group" "helpdesk_admins" {
  display_name     = "Admins - Help Desk"
  description      = "[Narrative] Reset passwords, unlock accounts, manage MFA. Cannot modify group membership or app assignments."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

resource "azuread_group" "security_admins" {
  display_name     = "Admins - Security"
  description      = "[Narrative] Manage security policies, Conditional Access, Identity Protection. Cannot manage users directly."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

resource "azuread_group" "readonly_admins" {
  display_name     = "Admins - Global Reader"
  description      = "[Narrative] View-only access to admin center. For auditors, compliance reviewers, and security monitoring."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

resource "azuread_group" "groups_admins" {
  display_name     = "Admins - Groups"
  description      = "[Narrative] Manage group membership for non-admin groups. Cannot create/delete groups or modify admin groups."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

resource "azuread_group" "conditional_access_admins" {
  display_name     = "Admins - Conditional Access"
  description      = "[Narrative] Manage Conditional Access policies, named locations, and authentication context."
  security_enabled = true
  assignable_to_role = true
  types            = ["UnifiedGroup"]
}

# -----------------------------------------------------------------------------
# Admin Role Assignments
# Assigns Entra ID built-in directory roles to the admin groups.
# Uses well-known role template IDs.
# -----------------------------------------------------------------------------

data "azuread_directory_roles" "all" {}

locals {
  # Map role template IDs to our group resources
  role_assignments = {
    # Global Administrator
    "62e90394-69f5-4237-9190-012177145e10" = azuread_group.global_admins.object_id
    # User Administrator
    "fe930be7-5e62-47db-91af-98c3a49a38b1" = azuread_group.user_admins.object_id
    # Application Administrator
    "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3" = azuread_group.application_admins.object_id
    # Helpdesk Administrator
    "729827e3-9c14-49f7-bb1b-9608f156bbb8" = azuread_group.helpdesk_admins.object_id
    # Security Administrator
    "194ae4cb-b126-40b2-bd5b-6091b380977d" = azuread_group.security_admins.object_id
    # Global Reader
    "f2ef992c-3afb-46b9-b7cf-a126ee74c451" = azuread_group.readonly_admins.object_id
    # Groups Administrator
    "fdd7a751-b60b-444a-984c-02652fe8fa1c" = azuread_group.groups_admins.object_id
    # Conditional Access Administrator
    "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9" = azuread_group.conditional_access_admins.object_id
  }

  # Build a map of directory role name -> object ID from the data source
  directory_role_ids = { for r in data.azuread_directory_roles.all.roles : r.template_id => r.object_id }
}

resource "azuread_directory_role_assignment" "admin_roles" {
  for_each = local.role_assignments

  role_id             = local.directory_role_ids[each.key]
  principal_object_id = each.value
}

# -----------------------------------------------------------------------------
# Functional Groups
# -----------------------------------------------------------------------------

resource "azuread_group" "security_team" {
  display_name     = "Security Team"
  description      = "[Narrative] Security engineers and analysts. Targeted by stricter auth policies and granted security tooling access."
  security_enabled = true
}

resource "azuread_group" "privileged_access" {
  display_name     = "Privileged Access"
  description      = "[Narrative] Temporary group for just-in-time elevated access. Membership should be time-bound and audited."
  security_enabled = true
}

resource "azuread_group" "break_glass" {
  display_name     = "Break Glass"
  description      = "[Narrative] Emergency access accounts. Heavily monitored, requires post-use review. Max 2-3 members."
  security_enabled = true
}

resource "azuread_group" "service_accounts" {
  display_name     = "Service Accounts"
  description      = "[Narrative] Non-human identities (service principals, managed identities). Subject to separate Conditional Access policy with IP restriction."
  security_enabled = true
}

resource "azuread_group" "all_employees" {
  display_name       = "All Employees"
  description        = "[Narrative] All full-time and part-time employees. Auto-populated via dynamic membership rule on employeeType attribute."
  security_enabled   = true
  types              = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "(user.employeeType -eq \"Employee\")"
  }
}

# -----------------------------------------------------------------------------
# Conditional Groups — Contractors
# -----------------------------------------------------------------------------

resource "azuread_group" "contractors" {
  count              = var.enable_contractor_group ? 1 : 0
  display_name       = "Contractors"
  description        = "[Narrative] External contractors and consultants. Subject to stricter session controls and limited app access."
  security_enabled   = true
  types              = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "(user.employeeType -eq \"Contractor\")"
  }
}

# -----------------------------------------------------------------------------
# Conditional Groups — Executive Leadership
# -----------------------------------------------------------------------------

resource "azuread_group" "executive_leadership" {
  count            = var.enable_executive_group ? 1 : 0
  display_name     = "Executive Leadership"
  description      = "[Narrative] C-suite and VP-level. Subject to enhanced phishing-resistant MFA. Limited but high-sensitivity app access."
  security_enabled = true
}

# -----------------------------------------------------------------------------
# Department Groups (dynamic membership)
# -----------------------------------------------------------------------------

resource "azuread_group" "department" {
  for_each           = local.effective.enable_department_groups ? toset(var.departments) : toset([])
  display_name       = "Dept - ${each.value}"
  description        = "[Narrative] Department group for ${each.value}. Auto-populated by department attribute."
  security_enabled   = true
  types              = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "(user.department -eq \"${each.value}\")"
  }
}

# -----------------------------------------------------------------------------
# Geo-Exception Groups
# -----------------------------------------------------------------------------

resource "azuread_group" "geo_exception_ofac" {
  count            = var.enable_geo_exception_groups ? 1 : 0
  display_name     = "Geo Exception - OFAC"
  description      = "[Narrative] Users exempt from OFAC country geo-blocking. Requires documented business justification and periodic review."
  security_enabled = true
}

resource "azuread_group" "geo_exception_non_ofac" {
  count            = var.enable_geo_exception_groups ? 1 : 0
  display_name     = "Geo Exception - Non-OFAC"
  description      = "[Narrative] Users exempt from non-OFAC geo-blocking (e.g., traveling employees). Time-bound membership recommended."
  security_enabled = true
}

# -----------------------------------------------------------------------------
# Custom Groups
# -----------------------------------------------------------------------------

resource "azuread_group" "custom" {
  for_each         = { for g in var.custom_groups : g.name => g }
  display_name     = each.value.name
  description      = "[Narrative] ${each.value.description}"
  security_enabled = true
}
