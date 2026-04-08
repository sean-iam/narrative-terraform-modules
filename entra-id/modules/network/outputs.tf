# =============================================================================
# [Narrative] Network Module — Outputs
# =============================================================================

output "trusted_location_id" {
  description = "Trusted named location ID"
  value       = azuread_named_location.trusted.id
}

output "ofac_location_id" {
  description = "OFAC blocklist named location ID"
  value       = azuread_named_location.ofac_blocklist.id
}

output "high_risk_location_id" {
  description = "High-risk country blocklist named location ID"
  value       = local.effective.enable_high_risk_blocking ? azuread_named_location.high_risk_blocklist[0].id : null
}
