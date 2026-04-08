# =============================================================================
# [Narrative] Network Module
# Trusted networks, IP allowlists, and context-aware access configuration.
#
# Google Workspace network controls are managed through:
# 1. Trusted IP ranges — allow or restrict access by IP
# 2. Context-aware access — conditional access based on device/network/location
# 3. IP allowlists — restrict admin/service account access to known IPs
#
# Context-aware access requires Google Cloud Identity Premium or
# Google Workspace Enterprise. If unavailable, IP-based controls
# are used as the baseline.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Network Policy OU
# Organizational unit for network-scoped access policies.
# Documents the intended IP allowlist and context-aware access settings.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "network_policy" {
  name                 = "Network Policy"
  description          = "[Narrative] Network policy OU. Trusted CIDRs: ${length(local.effective.trusted_cidrs)} ranges. IP allowlist enforced: ${local.effective.enforce_ip_allowlist}. Context-aware access: ${local.effective.enable_context_aware_access}."
  parent_org_unit_path = "/"
}

# -----------------------------------------------------------------------------
# 2. Admin IP Restriction OU
# Admin access restricted to trusted IPs in elevated/strict profiles.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "admin_ip_restriction" {
  count                = local.effective.enforce_ip_allowlist ? 1 : 0
  name                 = "Admin IP Restricted"
  description          = "[Narrative] Admin accounts restricted to trusted IP ranges only. ${length(local.effective.trusted_cidrs)} CIDR ranges configured."
  parent_org_unit_path = googleworkspace_org_unit.network_policy.org_unit_path
}

# -----------------------------------------------------------------------------
# 3. Context-Aware Access OU
# Conditional access based on device posture, network, and location.
# Requires Cloud Identity Premium or Workspace Enterprise.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "context_aware" {
  count                = local.effective.enable_context_aware_access ? 1 : 0
  name                 = "Context-Aware Access"
  description          = "[Narrative] Context-aware access policies. Device trust required. Network context evaluated. Requires Cloud Identity Premium."
  parent_org_unit_path = googleworkspace_org_unit.network_policy.org_unit_path
}
