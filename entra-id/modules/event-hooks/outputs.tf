# =============================================================================
# [Narrative] Event Hooks Module — Outputs
# =============================================================================

output "audit_log_stream_id" {
  description = "Audit log diagnostic setting ID (null if not created)"
  value       = local.effective.enable_audit_log_streaming && local.has_destination ? azurerm_monitor_aad_diagnostic_setting.audit_logs[0].id : null
}

output "sign_in_log_stream_id" {
  description = "Sign-in log diagnostic setting ID (null if not created)"
  value       = local.effective.enable_sign_in_log_streaming && local.has_destination ? azurerm_monitor_aad_diagnostic_setting.sign_in_logs[0].id : null
}

output "audit_log_streaming_enabled" {
  description = "Whether audit log streaming is active"
  value       = local.effective.enable_audit_log_streaming && local.has_destination
}

output "sign_in_log_streaming_enabled" {
  description = "Whether sign-in log streaming is active"
  value       = local.effective.enable_sign_in_log_streaming && local.has_destination
}
