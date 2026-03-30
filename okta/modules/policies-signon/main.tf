# =============================================================================
# [Narrative] Sign-On Policies Module
# Per-role MFA enforcement and session controls
#
# Policy priority order (lower number = evaluated first):
# 1. Global Session    — baseline for EVERYONE, evaluated last if no specific policy matches
# 2. Break Glass       — emergency accounts, password only, trusted network if available
# 3. Service Accounts  — no MFA, IP-restricted
# 4. Admins            — MFA always, short sessions
# 5. Executives        — MFA always, standard sessions (conditional on group existing)
# 6. Contractors       — MFA required, shorter idle timeout (conditional on group existing)
# 7. Employees         — MFA with device trust based on risk profile
# =============================================================================

# -----------------------------------------------------------------------------
# Policy 1: Global Session Policy (EVERYONE)
# Catch-all baseline — applies to all users not matched by a more specific policy.
# Enforces session bounds so no user ever has an unbounded session.
# -----------------------------------------------------------------------------

resource "okta_policy_signon" "global_session" {
  name        = "Global Session Policy"
  description = "[Narrative] Baseline session policy for all users. Enforces maximum session lifetime of ${local.effective.max_session_lifetime_minutes} minutes. More specific policies apply to each user population. This policy is the final catch-all."
  priority    = 1
  status      = "ACTIVE"

  groups_included = ["EVERYONE"]
}

resource "okta_policy_rule_signon" "global_session_default" {
  policy_id = okta_policy_signon.global_session.id
  name      = "Default Session Rule"
  priority  = 1
  status    = "ACTIVE"

  access                    = "ALLOW"
  authtype                  = "ANY"
  network_connection        = "ANYWHERE"
  session_idle              = local.effective.employee_idle_timeout_minutes
  session_lifetime          = local.effective.max_session_lifetime_minutes
  session_persistent        = false
  mfa_required              = false
}

# -----------------------------------------------------------------------------
# Policy 2: Break Glass
# Emergency accounts for lockout recovery. Password-only authentication.
# Restricted to trusted network if zone is configured.
# Short session lifetime to limit exposure window.
# -----------------------------------------------------------------------------

resource "okta_policy_signon" "break_glass" {
  name        = "Break Glass Policy"
  description = "[Narrative] Sign-on policy for break glass emergency accounts. Password-only authentication. Session limited to ${local.effective.break_glass_max_session_minutes} minutes. ${var.trusted_zone_id != null ? "Restricted to trusted network zone." : "Network zone not configured — restrict access manually."}"
  priority    = 2
  status      = "ACTIVE"

  groups_included = [var.group_ids["break_glass"]]
}

resource "okta_policy_rule_signon" "break_glass_allow" {
  policy_id = okta_policy_signon.break_glass.id
  name      = "Break Glass — Trusted Network Only"
  priority  = 1
  status    = "ACTIVE"

  access                    = "ALLOW"
  authtype                  = "ANY"
  network_connection        = var.trusted_zone_id != null ? "ZONE" : "ANYWHERE"
  network_includes          = var.trusted_zone_id != null ? [var.trusted_zone_id] : []
  session_idle              = local.effective.break_glass_max_session_minutes
  session_lifetime          = local.effective.break_glass_max_session_minutes
  session_persistent        = false
  mfa_required              = false
}

resource "okta_policy_rule_signon" "break_glass_deny_untrusted" {
  count     = var.trusted_zone_id != null ? 1 : 0
  policy_id = okta_policy_signon.break_glass.id
  name      = "Break Glass — Deny Untrusted Network"
  priority  = 2
  status    = "ACTIVE"

  access             = "DENY"
  authtype           = "ANY"
  network_connection = "ZONE"
  network_excludes   = [var.trusted_zone_id]
}

# -----------------------------------------------------------------------------
# Policy 3: Service Accounts
# Non-human identities — no MFA (automated processes cannot push-approve).
# IP-restricted to trusted network zone if available.
# No persistent sessions — each auth is discrete.
# -----------------------------------------------------------------------------

resource "okta_policy_signon" "service_accounts" {
  name        = "Service Account Policy"
  description = "[Narrative] Sign-on policy for service accounts and API integrations. MFA not required — automated processes cannot complete interactive MFA challenges. ${var.trusted_zone_id != null ? "Access restricted to trusted network zone." : "Network zone not configured — restrict by IP at the application level."}"
  priority    = 3
  status      = "ACTIVE"

  groups_included = [var.group_ids["service_accounts"]]
}

resource "okta_policy_rule_signon" "service_accounts_allow" {
  policy_id = okta_policy_signon.service_accounts.id
  name      = "Service Accounts — IP Restricted"
  priority  = 1
  status    = "ACTIVE"

  access                    = "ALLOW"
  authtype                  = "ANY"
  network_connection        = var.trusted_zone_id != null ? "ZONE" : "ANYWHERE"
  network_includes          = var.trusted_zone_id != null ? [var.trusted_zone_id] : []
  session_idle              = local.effective.admin_idle_timeout_minutes
  session_lifetime          = local.effective.max_session_lifetime_minutes
  session_persistent        = false
  mfa_required              = false
}

resource "okta_policy_rule_signon" "service_accounts_deny_untrusted" {
  count     = var.trusted_zone_id != null ? 1 : 0
  policy_id = okta_policy_signon.service_accounts.id
  name      = "Service Accounts — Deny Untrusted Network"
  priority  = 2
  status    = "ACTIVE"

  access             = "DENY"
  authtype           = "ANY"
  network_connection = "ZONE"
  network_excludes   = [var.trusted_zone_id]
}

# -----------------------------------------------------------------------------
# Policy 4: Admins
# All administrator role groups. MFA always required — no device remembering.
# Short idle timeout. Admins are high-value targets and must re-authenticate
# frequently even at standard risk profile.
# -----------------------------------------------------------------------------

resource "okta_policy_signon" "admins" {
  name        = "Admin Sign-On Policy"
  description = "[Narrative] Sign-on policy for all administrator accounts. MFA required on every sign-on. Session idle timeout: ${local.effective.admin_idle_timeout_minutes} minutes. Max session: ${local.effective.max_session_lifetime_minutes} minutes."
  priority    = 4
  status      = "ACTIVE"

  groups_included = [
    var.group_ids["super_admins"],
    var.group_ids["org_admins"],
    var.group_ids["app_admins"],
    var.group_ids["helpdesk_admins"],
    var.group_ids["api_access_admins"],
    var.group_ids["report_admins"],
  ]
}

resource "okta_policy_rule_signon" "admins_mfa" {
  policy_id = okta_policy_signon.admins.id
  name      = "Admins — MFA Always Required"
  priority  = 1
  status    = "ACTIVE"

  access                    = "ALLOW"
  authtype                  = "ANY"
  network_connection        = "ANYWHERE"
  session_idle              = local.effective.admin_idle_timeout_minutes
  session_lifetime          = local.effective.max_session_lifetime_minutes
  session_persistent        = false
  mfa_required              = true
  mfa_prompt                = "ALWAYS"
  mfa_remember_device       = false
}

# -----------------------------------------------------------------------------
# Policy 5: Executives (conditional — only if executive_leadership group exists)
# Similar to admins: MFA always, short sessions.
# Separate policy allows distinct audit reporting for executive sign-on patterns.
# -----------------------------------------------------------------------------

resource "okta_policy_signon" "executives" {
  count = try(var.group_ids["executive_leadership"], null) != null ? 1 : 0

  name        = "Executive Sign-On Policy"
  description = "[Narrative] Sign-on policy for executive leadership. MFA required on every sign-on. Session idle timeout: ${local.effective.admin_idle_timeout_minutes} minutes. Max session: ${local.effective.max_session_lifetime_minutes} minutes."
  priority    = 5
  status      = "ACTIVE"

  groups_included = [var.group_ids["executive_leadership"]]
}

resource "okta_policy_rule_signon" "executives_mfa" {
  count = try(var.group_ids["executive_leadership"], null) != null ? 1 : 0

  policy_id = okta_policy_signon.executives[0].id
  name      = "Executives — MFA Always Required"
  priority  = 1
  status    = "ACTIVE"

  access                    = "ALLOW"
  authtype                  = "ANY"
  network_connection        = "ANYWHERE"
  session_idle              = local.effective.admin_idle_timeout_minutes
  session_lifetime          = local.effective.max_session_lifetime_minutes
  session_persistent        = false
  mfa_required              = true
  mfa_prompt                = "ALWAYS"
  mfa_remember_device       = false
}

# -----------------------------------------------------------------------------
# Policy 6: Contractors (conditional — only if contractors group exists)
# MFA required. Shorter idle timeout than employees — third-party risk.
# No persistent sessions.
# -----------------------------------------------------------------------------

resource "okta_policy_signon" "contractors" {
  count = try(var.group_ids["contractors"], null) != null ? 1 : 0

  name        = "Contractor Sign-On Policy"
  description = "[Narrative] Sign-on policy for contractors and consultants. MFA required every session. Session idle timeout: ${local.effective.contractor_idle_timeout_minutes} minutes. Max session: ${local.effective.max_session_lifetime_minutes} minutes."
  priority    = 6
  status      = "ACTIVE"

  groups_included = [var.group_ids["contractors"]]
}

resource "okta_policy_rule_signon" "contractors_mfa" {
  count = try(var.group_ids["contractors"], null) != null ? 1 : 0

  policy_id = okta_policy_signon.contractors[0].id
  name      = "Contractors — MFA Required"
  priority  = 1
  status    = "ACTIVE"

  access                    = "ALLOW"
  authtype                  = "ANY"
  network_connection        = "ANYWHERE"
  session_idle              = local.effective.contractor_idle_timeout_minutes
  session_lifetime          = local.effective.max_session_lifetime_minutes
  session_persistent        = false
  mfa_required              = true
  mfa_prompt                = "ALWAYS"
  mfa_remember_device       = false
}

# -----------------------------------------------------------------------------
# Policy 7: Employees
# Full-time employees. MFA enforced. Device trust behavior controlled by
# risk profile — standard remembers device for 30 days, elevated/strict prompt
# every session or every authentication.
# -----------------------------------------------------------------------------

resource "okta_policy_signon" "employees" {
  name        = "Employee Sign-On Policy"
  description = "[Narrative] Sign-on policy for employees. MFA required every session. Session idle timeout: ${local.effective.employee_idle_timeout_minutes} minutes. Max session: ${local.effective.max_session_lifetime_minutes / 60} hours."
  priority    = 7
  status      = "ACTIVE"

  groups_included = [var.group_ids["all_employees"]]
}

resource "okta_policy_rule_signon" "employees_mfa" {
  policy_id = okta_policy_signon.employees.id
  name      = "Employees — MFA with Device Trust"
  priority  = 1
  status    = "ACTIVE"

  access                    = "ALLOW"
  authtype                  = "ANY"
  network_connection        = "ANYWHERE"
  session_idle              = local.effective.employee_idle_timeout_minutes
  session_lifetime          = local.effective.max_session_lifetime_minutes
  session_persistent        = local.effective.mfa_remember_device
  mfa_required              = true
  mfa_prompt                = local.effective.mfa_prompt_mode
  mfa_remember_device       = local.effective.mfa_remember_device
  mfa_lifetime              = local.effective.mfa_lifetime_minutes
}
