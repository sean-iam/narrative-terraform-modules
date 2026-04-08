# =============================================================================
# [Narrative] Password Policies Module — Outputs
# =============================================================================

output "effective_password_min_length" {
  description = "Resolved minimum password length"
  value       = local.effective.password_min_length
}

output "effective_password_max_age_days" {
  description = "Resolved password max age in days (0 = no expiration)"
  value       = local.effective.password_max_age_days
}

output "effective_lockout_attempts" {
  description = "Resolved smart lockout threshold"
  value       = local.effective.password_lockout_attempts
}

output "effective_lockout_duration_seconds" {
  description = "Resolved smart lockout duration in seconds"
  value       = local.effective.password_lockout_duration_seconds
}

output "effective_password_history_count" {
  description = "Resolved password history count"
  value       = local.effective.password_history_count
}

output "banned_password_list_enabled" {
  description = "Whether the custom banned password list is enabled"
  value       = local.effective.enable_banned_password_list
}
