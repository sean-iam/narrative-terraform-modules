# =============================================================================
# [Narrative] Conditional Access Policies Module
# Per-role MFA enforcement and session controls via Entra ID Conditional Access.
#
# Policy inventory (evaluated in display_name alphabetical order by Entra):
# 1. Block Legacy Authentication    — blocks IMAP, POP3, SMTP basic auth
# 2. Admin MFA Required             — MFA for all admin roles, short sessions
# 3. Executive MFA Required         — MFA for executive leadership (conditional)
# 4. Contractor Session Controls    — MFA + shorter sign-in frequency
# 5. Employee MFA Required          — MFA for all employees with session controls
# 6. Break Glass Exception          — excludes break glass from MFA policies
# 7. Service Account IP Restriction — restrict service accounts to trusted IPs
# 8. Geo-Block OFAC Countries       — block sign-in from sanctioned countries
# 9. Geo-Block High Risk Countries  — block sign-in from high-risk countries
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Block Legacy Authentication
# Blocks authentication protocols that cannot enforce MFA (IMAP, POP3,
# SMTP basic auth, Exchange ActiveSync basic auth, etc.).
# Always enabled — legacy auth is the #1 attack vector for credential stuffing.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "block_legacy_auth" {
  count        = local.effective.block_legacy_auth ? 1 : 0
  display_name = "[Narrative] Block Legacy Authentication"
  state        = "enabled"

  conditions {
    client_app_types = ["exchangeActiveSync", "other"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users  = ["All"]
      excluded_groups = [var.group_ids["break_glass"]]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

# -----------------------------------------------------------------------------
# 2. Admin MFA Required
# All administrator role groups. MFA always required.
# Short sign-in frequency. No persistent sessions.
# Admins are high-value targets and must re-authenticate frequently.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "admin_mfa" {
  count        = local.effective.require_mfa_for_admins ? 1 : 0
  display_name = "[Narrative] Admin - Require MFA"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_groups = [
        var.group_ids["global_admins"],
        var.group_ids["user_admins"],
        var.group_ids["application_admins"],
        var.group_ids["helpdesk_admins"],
        var.group_ids["security_admins"],
        var.group_ids["conditional_access_admins"],
      ]
      excluded_groups = [var.group_ids["break_glass"]]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  session_controls {
    sign_in_frequency        = local.effective.admin_sign_in_frequency_hours
    sign_in_frequency_period = "hours"
    persistent_browser_mode  = "never"
  }
}

# -----------------------------------------------------------------------------
# 3. Executive MFA Required (conditional)
# Similar to admins: MFA always, short sessions.
# Separate policy for distinct audit reporting on executive sign-on patterns.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "executive_mfa" {
  count = try(var.group_ids["executive_leadership"], null) != null ? 1 : 0

  display_name = "[Narrative] Executive - Require MFA"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_groups = [var.group_ids["executive_leadership"]]
      excluded_groups = [var.group_ids["break_glass"]]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  session_controls {
    sign_in_frequency        = local.effective.admin_sign_in_frequency_hours
    sign_in_frequency_period = "hours"
    persistent_browser_mode  = "never"
  }
}

# -----------------------------------------------------------------------------
# 4. Contractor Session Controls (conditional)
# MFA required. Shorter sign-in frequency than employees — third-party risk.
# No persistent sessions.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "contractor_mfa" {
  count = try(var.group_ids["contractors"], null) != null ? 1 : 0

  display_name = "[Narrative] Contractor - Require MFA + Session Controls"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_groups = [var.group_ids["contractors"]]
      excluded_groups = [var.group_ids["break_glass"]]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  session_controls {
    sign_in_frequency        = local.effective.contractor_sign_in_frequency_hours
    sign_in_frequency_period = "hours"
    persistent_browser_mode  = "never"
  }
}

# -----------------------------------------------------------------------------
# 5. Employee MFA Required
# All employees. MFA enforced. Session controls based on risk profile.
# Standard: 24-hour sign-in frequency with persistent browser
# Elevated: 12-hour sign-in frequency, no persistent browser
# Strict: 8-hour sign-in frequency, no persistent browser
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "employee_mfa" {
  count        = local.effective.require_mfa_for_all_users ? 1 : 0
  display_name = "[Narrative] Employee - Require MFA + Session Controls"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_groups = [var.group_ids["all_employees"]]
      excluded_groups = [var.group_ids["break_glass"]]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  session_controls {
    sign_in_frequency        = local.effective.employee_sign_in_frequency_hours
    sign_in_frequency_period = "hours"
    persistent_browser_mode  = local.effective.persistent_browser_session ? "always" : "never"
  }
}

# -----------------------------------------------------------------------------
# 6. Service Account IP Restriction
# Non-human identities — restricted to trusted network locations.
# No MFA (automated processes cannot complete interactive challenges).
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "service_account_ip_restriction" {
  count        = var.trusted_location_id != null ? 1 : 0
  display_name = "[Narrative] Service Account - Trusted Network Only"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients", "exchangeActiveSync", "other"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_groups = [var.group_ids["service_accounts"]]
    }

    locations {
      included_locations = ["All"]
      excluded_locations = [var.trusted_location_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

# -----------------------------------------------------------------------------
# 7. Geo-Block OFAC Countries
# Always created — blocks authentication from OFAC-sanctioned countries.
# Geo-exception group members are excluded.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "block_ofac" {
  count        = var.ofac_location_id != null ? 1 : 0
  display_name = "[Narrative] Geo Block - OFAC Sanctioned Countries"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients", "exchangeActiveSync", "other"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["All"]
      excluded_groups = compact([
        var.group_ids["break_glass"],
        try(var.group_ids["geo_exception_ofac"], null),
      ])
    }

    locations {
      included_locations = [var.ofac_location_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

# -----------------------------------------------------------------------------
# 8. Geo-Block High Risk Countries (conditional — elevated/strict)
# Blocks authentication from high-risk-threat countries.
# -----------------------------------------------------------------------------

resource "azuread_conditional_access_policy" "block_high_risk" {
  count        = var.high_risk_location_id != null ? 1 : 0
  display_name = "[Narrative] Geo Block - High Risk Countries"
  state        = "enabled"

  conditions {
    client_app_types = ["browser", "mobileAppsAndDesktopClients", "exchangeActiveSync", "other"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["All"]
      excluded_groups = compact([
        var.group_ids["break_glass"],
        try(var.group_ids["geo_exception_non_ofac"], null),
      ])
    }

    locations {
      included_locations = [var.high_risk_location_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}
