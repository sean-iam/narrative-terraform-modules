# =============================================================================
# [Narrative] Event Hooks Module
# Diagnostic settings for Entra ID audit and sign-in log streaming.
#
# Entra ID equivalent of Okta event hooks. Uses Azure Monitor diagnostic
# settings to stream directory logs to Log Analytics and/or Storage Accounts.
#
# Resource inventory:
# 1. azurerm_monitor_aad_diagnostic_setting.audit_logs    — Audit log stream
# 2. azurerm_monitor_aad_diagnostic_setting.sign_in_logs  — Sign-in log stream
#
# Both streams are conditional on:
# a) The risk-profile-driven enable flag being true
# b) At least one destination (Log Analytics or Storage Account) being provided
#
# Without a destination, the stream is not created even if enabled by profile.
#
# Note: This module requires the azurerm provider in addition to azuread,
# as diagnostic settings are an Azure Monitor (ARM) resource.
# =============================================================================

locals {
  has_destination = var.log_analytics_workspace_id != null || var.storage_account_id != null
}

# -----------------------------------------------------------------------------
# 1. Audit Log Streaming
# Captures directory changes: user/group/app creation/deletion/modification,
# role assignments, policy changes, consent grants, and more.
# Essential for security monitoring and compliance auditing.
# -----------------------------------------------------------------------------

resource "azurerm_monitor_aad_diagnostic_setting" "audit_logs" {
  count = local.effective.enable_audit_log_streaming && local.has_destination ? 1 : 0

  name = "[Narrative] Audit Log Stream"

  log_analytics_workspace_id = var.log_analytics_workspace_id
  storage_account_id         = var.storage_account_id

  enabled_log {
    category = "AuditLogs"

    retention_policy {
      enabled = var.storage_account_id != null
      days    = var.storage_account_id != null ? 365 : 0
    }
  }

  enabled_log {
    category = "ProvisioningLogs"

    retention_policy {
      enabled = var.storage_account_id != null
      days    = var.storage_account_id != null ? 365 : 0
    }
  }
}

# -----------------------------------------------------------------------------
# 2. Sign-In Log Streaming
# Captures all authentication events: interactive sign-ins, non-interactive
# sign-ins, service principal sign-ins, and managed identity sign-ins.
# High volume — storage costs should be considered.
# -----------------------------------------------------------------------------

resource "azurerm_monitor_aad_diagnostic_setting" "sign_in_logs" {
  count = local.effective.enable_sign_in_log_streaming && local.has_destination ? 1 : 0

  name = "[Narrative] Sign-In Log Stream"

  log_analytics_workspace_id = var.log_analytics_workspace_id
  storage_account_id         = var.storage_account_id

  enabled_log {
    category = "SignInLogs"

    retention_policy {
      enabled = var.storage_account_id != null
      days    = var.storage_account_id != null ? 90 : 0
    }
  }

  enabled_log {
    category = "NonInteractiveUserSignInLogs"

    retention_policy {
      enabled = var.storage_account_id != null
      days    = var.storage_account_id != null ? 90 : 0
    }
  }

  enabled_log {
    category = "ServicePrincipalSignInLogs"

    retention_policy {
      enabled = var.storage_account_id != null
      days    = var.storage_account_id != null ? 90 : 0
    }
  }

  enabled_log {
    category = "ManagedIdentitySignInLogs"

    retention_policy {
      enabled = var.storage_account_id != null
      days    = var.storage_account_id != null ? 90 : 0
    }
  }
}
