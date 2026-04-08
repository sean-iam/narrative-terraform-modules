# =============================================================================
# [Narrative] Behaviors Module
# Login challenges, suspicious activity responses, and account recovery.
#
# Google Workspace behavioral security controls:
# 1. Suspicious login challenges — prompt additional verification
# 2. Account recovery settings — control self-service recovery methods
# 3. Less secure app blocking — prevent legacy auth protocols
#
# These settings are managed at the OU level via the Admin SDK.
# This module creates OUs documenting the intended configuration.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Login Challenge Policy OU
# Controls how Google responds to suspicious login attempts.
# Standard: basic challenges
# Elevated: aggressive challenges with login verification
# Strict: aggressive challenges, employee ID verification required
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "login_challenges" {
  name                 = "Login Challenge Policy"
  description          = "[Narrative] Login challenge policy. Suspicious login challenges: ${local.effective.enable_suspicious_login_challenge}. Less secure apps blocked: ${local.effective.enable_less_secure_apps_block}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2. Account Recovery Policy OU
# Controls how users can recover their accounts.
# Standard: email and phone recovery allowed
# Elevated: admin-only recovery, no self-service
# Strict: admin-only recovery, no self-service, require identity verification
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "account_recovery" {
  name                 = "Account Recovery Policy"
  description          = "[Narrative] Account recovery policy. Recovery method: ${local.effective.account_recovery_method}. Self-service recovery: ${local.effective.account_recovery_method == "self_service" ? "enabled" : "disabled"}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 3. Less Secure Apps Policy OU
# Blocks legacy authentication protocols that do not support 2SV.
# Always blocked for elevated/strict profiles.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "less_secure_apps" {
  count                = local.effective.enable_less_secure_apps_block ? 1 : 0
  name                 = "Less Secure Apps Blocked"
  description          = "[Narrative] Less secure app access is blocked for this OU. Legacy protocols (IMAP, POP, basic SMTP) that bypass 2SV are not allowed."
  parent_org_unit_path = "/"
}
