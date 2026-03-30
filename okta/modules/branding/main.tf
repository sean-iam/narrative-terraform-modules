# =============================================================================
# [Narrative] Branding Module
# Theme customization and security notification email configuration.
#
# Resource inventory:
# 1. okta_brand (data)                    — Default brand lookup
# 2. okta_theme.main                      — Theme colors (if supported)
# 3. okta_security_notification_emails    — Security event email alerts
#
# Note: The okta_brand and okta_theme resources require the Okta provider to
# support branding APIs. If your Okta org/plan does not support custom
# branding, the theme resource may fail at apply time — the security
# notification emails will still work independently.
# =============================================================================

# -----------------------------------------------------------------------------
# 1–2. Brand Theme
# Look up the default brand and apply custom colors.
# The Okta provider 4.x uses data.okta_brands to list brands, then
# okta_theme to customize. If the branding API is unavailable, comment
# out these resources and rely on the Okta admin console for theme changes.
# -----------------------------------------------------------------------------

# TODO: Uncomment when targeting an Okta org that supports branding API.
# The okta_brands data source and okta_theme resource may not be available
# in all Okta editions or provider versions. Theme customization can be
# done manually in the Okta admin console as a fallback.
#
# data "okta_brands" "all" {}
#
# resource "okta_theme" "main" {
#   brand_id                = tolist(data.okta_brands.all.brands)[0].id
#   primary_color_hex       = var.primary_color
#   secondary_color_hex     = var.secondary_color
#   sign_in_page_touch_point_variant     = "OKTA_DEFAULT"
#   end_user_dashboard_touch_point_variant = "OKTA_DEFAULT"
#   error_page_touch_point_variant       = "OKTA_DEFAULT"
#   email_template_touch_point_variant   = "OKTA_DEFAULT"
# }

# -----------------------------------------------------------------------------
# 3. Security Notification Emails
# Configures Okta to send security-relevant notification emails to end users
# when suspicious or notable account events occur.
# -----------------------------------------------------------------------------

resource "okta_security_notification_emails" "main" {
  count = var.enable_security_notifications ? 1 : 0

  send_email_for_new_device_enabled        = true
  send_email_for_factor_enrollment_enabled = true
  send_email_for_factor_reset_enabled      = true
  send_email_for_password_changed_enabled  = true
  report_suspicious_activity_enabled       = true
}
