# =============================================================================
# [Narrative] Branding Module
# Company branding for the Entra ID sign-in experience.
#
# Resource inventory:
# 1. azuread_organization_branding  — Default sign-in page branding
#
# Note: The azuread provider supports company branding configuration
# including colors, text, and layout. Logo and background image uploads
# must be done via the Azure portal or Microsoft Graph API as they require
# binary file uploads.
# =============================================================================

# -----------------------------------------------------------------------------
# Company Branding — Default Locale
# Customizes the Entra ID sign-in page appearance.
# Logo and background images should be uploaded via Azure portal.
# -----------------------------------------------------------------------------

# Note: The azuread provider's support for organization branding may vary.
# If azuread_organization_branding is not available in your provider version,
# configure branding via the Azure portal:
# Azure Portal > Entra ID > Company Branding > Configure
#
# Recommended settings per Narrative standard:
# - Sign-in page background color: ${var.background_color}
# - Sign-in page text color: derived from primary brand
# - Username hint: "someone@${var.org_display_name}"
# - Sign-in page text: ${var.sign_in_page_text != null ? var.sign_in_page_text : "Not configured"}

# Placeholder resource to track branding configuration in state
resource "terraform_data" "branding_config" {
  input = {
    org_display_name                  = var.org_display_name
    primary_color                     = var.primary_color
    background_color                  = var.background_color
    enable_self_service_password_reset = var.enable_self_service_password_reset
    sign_in_page_text                 = var.sign_in_page_text
  }

  lifecycle {
    replace_triggered_by = [
      terraform_data.branding_config.input
    ]
  }
}
