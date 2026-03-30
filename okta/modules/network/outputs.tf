# =============================================================================
# [Narrative] Network Module — Outputs
# =============================================================================

output "trusted_zone_id" {
  description = "Trusted network zone ID"
  value       = okta_network_zone.trusted.id
}

output "ofac_zone_id" {
  description = "OFAC blocklist zone ID"
  value       = okta_network_zone.ofac_blocklist.id
}

output "high_risk_zone_id" {
  description = "High-risk country blocklist zone ID"
  value       = local.effective.enable_high_risk_blocking ? okta_network_zone.high_risk_blocklist[0].id : null
}

output "tor_zone_id" {
  description = "Tor/anonymizer blocklist zone ID"
  value       = local.effective.enable_tor_blocking ? okta_network_zone.tor_anonymizer[0].id : null
}
