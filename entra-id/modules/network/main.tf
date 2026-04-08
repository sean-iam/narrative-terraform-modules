# =============================================================================
# [Narrative] Network Module
# Named locations for Conditional Access: trusted IPs, OFAC geo-blocking,
# high-risk country blocking.
#
# Location inventory:
# 1. azuread_named_location.trusted           — IP-based trusted networks
# 2. azuread_named_location.ofac_blocklist    — OFAC-sanctioned countries
# 3. azuread_named_location.high_risk_blocklist — High-risk countries (elevated/strict)
#
# Note: Entra ID uses named locations (IP-based and country-based) which are
# then referenced by Conditional Access policies. Unlike Okta, there is no
# ThreatInsight or Tor-specific blocking — these are handled via Conditional
# Access risk-based policies (see behaviors module).
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Trusted Network Location
# IP-based named location used by Conditional Access policies to identify
# sign-ins from known-good networks (office, VPN).
# If no CIDRs provided, uses a non-routable placeholder so the location
# can be created — clients should override with actual office/VPN IPs.
# -----------------------------------------------------------------------------

resource "azuread_named_location" "trusted" {
  display_name = "[Narrative] Trusted Networks"

  ip {
    ip_ranges = length(local.effective.trusted_cidrs) > 0 ? local.effective.trusted_cidrs : ["10.0.0.0/32"]
    trusted   = true
  }
}

# -----------------------------------------------------------------------------
# 2. OFAC Blocklist Location
# Always created — identifies authentication from OFAC-sanctioned countries.
# Referenced by Conditional Access to block sign-ins.
# -----------------------------------------------------------------------------

resource "azuread_named_location" "ofac_blocklist" {
  display_name = "[Narrative] Geo Block - OFAC Sanctioned Countries"

  country {
    countries_and_regions                 = local.effective.ofac_countries
    include_unknown_countries_and_regions = false
  }
}

# -----------------------------------------------------------------------------
# 3. High-Risk Country Blocklist Location (conditional — elevated/strict)
# Identifies authentication from countries with elevated threat profiles.
# Referenced by Conditional Access to block sign-ins.
# -----------------------------------------------------------------------------

resource "azuread_named_location" "high_risk_blocklist" {
  count        = local.effective.enable_high_risk_blocking ? 1 : 0
  display_name = "[Narrative] Geo Block - High Risk Countries"

  country {
    countries_and_regions                 = local.effective.high_risk_countries
    include_unknown_countries_and_regions = false
  }
}
