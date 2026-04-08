# =============================================================================
# [Narrative] Password Policies Module — Main
# Entra ID tenant-wide password protection and smart lockout configuration.
#
# Unlike Okta which supports per-group password policies, Entra ID uses a
# single tenant-wide policy with these controls:
# 1. Smart Lockout — adaptive lockout based on sign-in patterns
# 2. Custom Banned Password List — organization-specific blocked terms
# 3. Password expiration — tenant-wide via group policy or per-user
#
# Note: The azuread provider does not expose all password policy settings
# directly. Some settings (like smart lockout thresholds) are configured
# via the Azure AD admin center or Microsoft Graph API. This module manages
# what the provider supports and documents the recommended configuration.
# =============================================================================

# -----------------------------------------------------------------------------
# Organizational Branding Properties — Password Expiration
# Entra ID password expiration is configured at the organization level.
# This resource sets the tenant-wide password policy.
# -----------------------------------------------------------------------------

# Note: The azuread provider does not have a direct resource for password
# policy configuration. Password expiration and history are managed via
# the Microsoft 365 admin center or Microsoft Graph API.
#
# The following local values document the intended configuration per risk
# profile. Use these values when configuring via the Azure portal or Graph:
#
# Smart Lockout Threshold: ${local.effective.password_lockout_attempts} attempts
# Smart Lockout Duration: ${local.effective.password_lockout_duration_seconds} seconds
# Password Expiration: ${local.effective.password_max_age_days} days (0 = never)
# Password History: ${local.effective.password_history_count} passwords
# Minimum Length Guidance: ${local.effective.password_min_length} characters

# -----------------------------------------------------------------------------
# Custom Banned Password List
# Azure AD Password Protection blocks common weak passwords plus custom terms.
# The custom list supplements Microsoft's global banned list.
# Managed via azuread_directory_role_eligibility_schedule_request for
# Password Protection, but the direct resource is the organization settings.
# -----------------------------------------------------------------------------

# Note: Custom banned password lists are configured via the Azure portal
# (Authentication Methods > Password Protection) or Microsoft Graph API.
# The Terraform azuread provider does not currently expose a direct resource
# for this. The module outputs the intended configuration for manual setup
# or Graph API automation.

# Placeholder resource to track the password policy configuration in state.
# This ensures the module can be referenced by other modules and outputs
# the effective configuration values.

resource "terraform_data" "password_policy_config" {
  input = {
    password_min_length               = local.effective.password_min_length
    password_max_age_days             = local.effective.password_max_age_days
    password_history_count            = local.effective.password_history_count
    password_lockout_attempts         = local.effective.password_lockout_attempts
    password_lockout_duration_seconds = local.effective.password_lockout_duration_seconds
    enable_banned_password_list       = local.effective.enable_banned_password_list
    banned_passwords                  = var.banned_passwords
  }

  lifecycle {
    replace_triggered_by = [
      terraform_data.password_policy_config.input
    ]
  }
}
