# =============================================================================
# [Narrative] Behaviors Module
# Anomaly detection rules for impossible travel and new-city login patterns.
#
# Behavior inventory:
# 1. okta_behavior.velocity_anomaly — Impossible travel detection
# 2. okta_behavior.new_city         — New city anomalous location detection
#
# Note: Okta behaviors define detection rules only. Response actions (MFA
# step-up, session termination) are enforced in sign-on policy rules.
# This module outputs the recommended actions for consumption by the
# sign-on policies module.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Impossible Travel Detection
# Flags authentications where the user would need to travel faster than the
# velocity threshold (default 805 km/h, roughly Mach 0.65) between locations.
# -----------------------------------------------------------------------------

resource "okta_behavior" "velocity_anomaly" {
  name     = "[Narrative] Impossible Travel - Custom"
  type     = "VELOCITY"
  velocity = local.effective.velocity_threshold_kmh
  status   = "ACTIVE"
}

# -----------------------------------------------------------------------------
# 2. New City Detection
# Flags the first authentication from a city the user has not previously
# logged in from. Uses a single-authentication threshold for immediate
# detection.
# -----------------------------------------------------------------------------

resource "okta_behavior" "new_city" {
  name                      = "[Narrative] New City - Custom"
  type                      = "ANOMALOUS_LOCATION"
  number_of_authentications = 1
  location_granularity_type = "CITY"
  status                    = "ACTIVE"
}
