# =============================================================================
# [Narrative] Login Policies Module — Main
# Session controls, login challenges, and re-authentication requirements.
#
# Google Workspace session management is configured at the OU level.
# This module creates organizational units with documented session
# configurations and manages login challenge settings.
#
# Session tiers:
# 1. Admin sessions — shortest duration, always require re-auth
# 2. Employee sessions — balanced convenience and security
# 3. Contractor sessions — tighter controls than employees
# 4. Break glass sessions — time-limited emergency access
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Admin Session OU
# Shortest session durations, re-auth required for sensitive actions.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "admin_session" {
  name                 = "Admin Sessions"
  description          = "[Narrative] Admin session OU. Session duration: ${local.effective.admin_session_duration_hours}h. Re-auth for sensitive actions: always. Login challenges: ${local.effective.enable_login_challenge}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2. Employee Session OU
# Standard session durations with login challenge support.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "employee_session" {
  name                 = "Employee Sessions"
  description          = "[Narrative] Employee session OU. Session duration: ${local.effective.session_duration_hours}h. Login challenges: ${local.effective.enable_login_challenge}. Re-auth for sensitive: ${local.effective.require_reauth_for_sensitive}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 3. Contractor Session OU (if contractors group exists)
# Tighter session controls than standard employees.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "contractor_session" {
  name                 = "Contractor Sessions"
  description          = "[Narrative] Contractor session OU. Session duration: ${local.effective.contractor_session_duration_hours}h. Login challenges: always enabled. Re-auth for sensitive: always."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 4. Break Glass Session OU
# Emergency access with time-limited sessions.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "break_glass_session" {
  name                 = "Break Glass Sessions"
  description          = "[Narrative] Break glass session OU. Session duration: ${local.effective.break_glass_session_hours}h. Heavily monitored, requires post-use review."
  parent_org_unit_path = "/"
}
