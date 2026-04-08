# =============================================================================
# [Narrative] Behaviors Module
# Identity Protection risk-based Conditional Access policies.
#
# Entra ID Identity Protection detects:
# - Sign-in risk: impossible travel, anonymous IP, malware-linked IP,
#   unfamiliar sign-in properties, password spray, leaked credentials
# - User risk: leaked credentials, anomalous user activity
#
# Unlike Okta behaviors (which are detection-only rules consumed by sign-on
# policies), Entra ID risk detection is built into the platform. This module
# creates Conditional Access policies that respond to detected risk levels.
#
# Policy inventory:
# 1. Sign-In Risk Policy — responds to risky sign-in events
# 2. User Risk Policy    — responds to risky user state
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Sign-In Risk Policy
# Responds to real-time sign-in risk detected by Identity Protection.
# Standard: log only (allow). Elevated: require MFA. Strict: block.
# Risk levels: low, medium, high — controlled by sign_in_risk_level variable.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "sign_in_risk" {
  count        = local.effective.sign_in_risk_action != "allow" ? 1 : 0
  display_name = "[Narrative] Identity Protection - Sign-In Risk Response"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [var.group_ids["break_glass"]]
    }

    sign_in_risk_levels = local.effective.sign_in_risk_level == "low" ? [
      "low", "medium", "high",
    ] : local.effective.sign_in_risk_level == "medium" ? [
      "medium", "high",
    ] : [
      "high",
    ]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = local.effective.sign_in_risk_action == "block" ? ["block"] : ["mfa"]
  }
}

# -----------------------------------------------------------------------------
# 2. User Risk Policy
# Responds to accumulated user risk detected by Identity Protection.
# Standard: log only (allow). Elevated: require password change.
# Strict: require password change at low risk threshold.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "user_risk" {
  count        = local.effective.user_risk_action != "allow" ? 1 : 0
  display_name = "[Narrative] Identity Protection - User Risk Response"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [var.group_ids["break_glass"]]
    }

    user_risk_levels = local.effective.user_risk_level == "low" ? [
      "low", "medium", "high",
    ] : local.effective.user_risk_level == "medium" ? [
      "medium", "high",
    ] : [
      "high",
    ]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = local.effective.user_risk_action == "block" ? ["block"] : ["passwordChange"]
  }
}
