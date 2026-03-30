# =============================================================================
# [Narrative] Network Module
# Network zones, OFAC geo-blocking, high-risk country blocking, Tor blocking,
# and ThreatInsight configuration.
#
# Zone inventory:
# 1. okta_network_zone.trusted        — IP type, POLICY usage — trusted CIDRs
# 2. okta_network_zone.ofac_blocklist — DYNAMIC type, BLOCKLIST — always created
# 3. okta_network_zone.high_risk_blocklist — DYNAMIC, BLOCKLIST — elevated/strict
# 4. okta_network_zone.tor_anonymizer — DYNAMIC, BLOCKLIST — elevated/strict
# 5. okta_threat_insight_settings     — block mode, exempts trusted zone
#
# Note: okta_network_zone does not support a description attribute.
# Zone purpose is conveyed through the name field.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Trusted Network Zone
# IP-type zone used by sign-on policies to relax MFA for known-good networks
# and to restrict service account / break-glass access.
# gateways are CIDR strings (e.g., "203.0.113.0/24").
# If no CIDRs provided, a non-routable placeholder is used so the zone can
# be created — clients should override with their actual office/VPN IPs.
# -----------------------------------------------------------------------------

resource "okta_network_zone" "trusted" {
  name  = "[Narrative] Trusted Networks"
  type  = "IP"
  usage = "POLICY"

  gateways = length(local.effective.trusted_cidrs) > 0 ? local.effective.trusted_cidrs : ["10.0.0.0/32"]
}

# -----------------------------------------------------------------------------
# 2. OFAC Blocklist Zone
# Always created — blocks authentication from OFAC-sanctioned countries.
# Exception group members can be exempted at the policy-rule level.
# dynamic_locations accepts a set of ISO 3166-1 alpha-2 country codes.
# -----------------------------------------------------------------------------

resource "okta_network_zone" "ofac_blocklist" {
  name  = "[Narrative] Geo Block - OFAC Sanctioned Countries"
  type  = "DYNAMIC"
  usage = "BLOCKLIST"

  dynamic_locations = toset(local.effective.ofac_countries)
}

# -----------------------------------------------------------------------------
# 3. High-Risk Country Blocklist Zone (conditional — elevated/strict)
# Blocks authentication from countries with elevated threat profiles.
# -----------------------------------------------------------------------------

resource "okta_network_zone" "high_risk_blocklist" {
  count = local.effective.enable_high_risk_blocking ? 1 : 0

  name  = "[Narrative] Geo Block - High Risk Countries"
  type  = "DYNAMIC"
  usage = "BLOCKLIST"

  dynamic_locations = toset(local.effective.high_risk_countries)
}

# -----------------------------------------------------------------------------
# 4. Tor / Anonymizer Blocklist Zone (conditional — elevated/strict)
# Blocks Tor exit nodes and anonymous proxy services.
# dynamic_proxy_type = "TorAnonymizer" enables Tor exit node blocking.
# -----------------------------------------------------------------------------

resource "okta_network_zone" "tor_anonymizer" {
  count = local.effective.enable_tor_blocking ? 1 : 0

  name               = "[Narrative] Block - Tor and Anonymizers"
  type               = "DYNAMIC"
  usage              = "BLOCKLIST"
  dynamic_proxy_type = "TorAnonymizer"
}

# -----------------------------------------------------------------------------
# 5. ThreatInsight Settings
# Configures Okta's built-in threat intelligence to block suspicious IPs.
# network_excludes exempts the trusted zone so legitimate automated traffic
# is not blocked by ThreatInsight signature matching.
# -----------------------------------------------------------------------------

resource "okta_threat_insight_settings" "main" {
  action           = local.effective.threat_insight_action
  network_excludes = [okta_network_zone.trusted.id]
}
