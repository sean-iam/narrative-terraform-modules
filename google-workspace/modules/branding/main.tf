# =============================================================================
# [Narrative] Branding Module
# Custom logos, login page customization, and brand settings.
#
# Google Workspace branding is managed via the Admin SDK and the
# Admin Console. The googleworkspace provider does not have dedicated
# branding resources. This module creates organizational units that
# document the intended branding configuration.
#
# Resource inventory:
# 1. Branding Policy OU — documents brand colors and logo settings
# 2. Login Page OU — documents custom login page configuration
#
# Manual steps required:
# - Upload logo via Admin Console > Account > Profile
# - Configure login page via Admin Console > Customization
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Branding Policy OU
# Documents the intended brand configuration.
# -----------------------------------------------------------------------------

resource "googleworkspace_org_unit" "branding_policy" {
  name                 = "Branding Policy"
  description          = "[Narrative] Brand configuration. Primary color: ${var.primary_color}. Secondary color: ${var.secondary_color}. Logo URL: ${var.logo_url != null ? var.logo_url : "not set"}. Custom login page: ${var.custom_login_page_enabled}."
  parent_org_unit_path = "/"
}
