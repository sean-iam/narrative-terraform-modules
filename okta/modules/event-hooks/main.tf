# =============================================================================
# [Narrative] Event Hooks Module
# Okta event hooks for security monitoring and admin activity auditing.
#
# Resource inventory:
# 1. okta_event_hook.security       — Security event monitor (conditional)
# 2. okta_event_hook.admin_activity — Admin activity monitor (conditional)
#
# Both hooks are conditional on:
# a) The risk-profile-driven enable flag being true
# b) A valid HTTPS endpoint URL being provided
#
# Without an endpoint, the hook is not created even if enabled by profile.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Security Event Monitor
# Monitors account lockouts, session starts, MFA changes, policy updates,
# and membership changes. Sends events to the configured HTTPS endpoint.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "security" {
  count = local.effective.enable_security_event_hook && var.security_hook_endpoint != null ? 1 : 0

  name = "[Narrative] Security Event Monitor"
  events = [
    "user.account.lock",
    "user.session.start",
    "user.mfa.factor.deactivate",
    "policy.lifecycle.update",
    "group.user_membership.add",
    "application.user_membership.add",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.security_hook_endpoint
    version = "1.0.0"
  }

  status = "ACTIVE"
}

# -----------------------------------------------------------------------------
# 2. Admin Activity Monitor
# Monitors policy, application, and group lifecycle changes (create, update,
# delete). Provides an audit trail for administrative actions.
# -----------------------------------------------------------------------------

resource "okta_event_hook" "admin_activity" {
  count = local.effective.enable_admin_activity_hook && var.admin_hook_endpoint != null ? 1 : 0

  name = "[Narrative] Admin Activity Monitor"
  events = [
    "policy.lifecycle.create",
    "policy.lifecycle.update",
    "policy.lifecycle.delete",
    "application.lifecycle.create",
    "application.lifecycle.update",
    "application.lifecycle.delete",
    "group.lifecycle.create",
    "group.lifecycle.update",
    "group.lifecycle.delete",
  ]

  channel = {
    type    = "HTTP"
    uri     = var.admin_hook_endpoint
    version = "1.0.0"
  }

  status = "ACTIVE"
}
