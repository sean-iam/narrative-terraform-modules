# =============================================================================
# [Narrative] Behaviors Module — Outputs
# =============================================================================

output "velocity_anomaly_id" {
  description = "Behavior ID for impossible travel detection"
  value       = okta_behavior.velocity_anomaly.id
}

output "new_city_id" {
  description = "Behavior ID for new city detection"
  value       = okta_behavior.new_city.id
}

# -----------------------------------------------------------------------------
# Action metadata — consumed by sign-on policies to configure rule responses
# -----------------------------------------------------------------------------

output "impossible_travel_action" {
  description = "Recommended action for impossible travel events"
  value       = local.effective.impossible_travel_action
}

output "new_device_action" {
  description = "Recommended action for new device events"
  value       = local.effective.new_device_action
}

output "new_city_action" {
  description = "Recommended action for new city events"
  value       = local.effective.new_city_action
}
