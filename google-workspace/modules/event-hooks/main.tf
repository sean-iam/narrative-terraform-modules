# =============================================================================
# [Narrative] Event Hooks Module
# Alert center rules, audit log exports, and activity rules.
# Google Workspace equivalent of Okta event hooks.
#
# Google Workspace monitoring capabilities:
# 1. Security alerts — Alert Center rules for suspicious activity
# 2. Admin activity alerts — monitoring admin console changes
# 3. Audit log export — BigQuery or Cloud Storage export
#
# Alert Center rules are managed via the Admin SDK Alert Center API.
# The googleworkspace provider does not have native Alert Center resources.
# This module creates OUs documenting the intended monitoring configuration
# and manages the notification settings where possible.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Security Alerts Policy OU
# Documents the intended security alert configuration.
# Standard: basic alerts disabled by default
# Elevated: security alerts enabled
# Strict: all security and admin alerts enabled
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "security_alerts" {
  count                = local.effective.enable_security_alerts ? 1 : 0
  name                 = "Security Alerts"
  description          = "[Narrative] Security alert rules enabled. Monitoring: suspicious logins, device compromises, data exports, phishing attempts. Notification email: ${var.alert_notification_email != null ? var.alert_notification_email : "not configured"}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2. Admin Activity Alerts Policy OU
# Monitors admin console changes for audit trail.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "admin_activity_alerts" {
  count                = local.effective.enable_admin_activity_alerts ? 1 : 0
  name                 = "Admin Activity Alerts"
  description          = "[Narrative] Admin activity alert rules enabled. Monitoring: user creation/deletion, group changes, security setting changes, delegation changes. Notification email: ${var.alert_notification_email != null ? var.alert_notification_email : "not configured"}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 3. Audit Log Export Policy OU
# Documents audit log export configuration (BigQuery/Cloud Storage).
# Actual export must be configured via Admin Console > Reporting.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "audit_export" {
  count                = var.audit_log_export_enabled ? 1 : 0
  name                 = "Audit Log Export"
  description          = "[Narrative] Audit log export enabled. Logs should be exported to BigQuery or Cloud Storage for long-term retention and SIEM integration."
  parent_org_unit_path = "/"
}
