# =============================================================================
# [Narrative] Branding Module — Variables
# =============================================================================

variable "org_display_name" {
  description = "Organization display name for branding"
  type        = string
}

variable "primary_color" {
  description = "Primary brand color hex code for the sign-in page"
  type        = string
  default     = "#1a1a2e"
}

variable "background_color" {
  description = "Background color hex code for the sign-in page"
  type        = string
  default     = "#ffffff"
}

variable "enable_self_service_password_reset" {
  description = "Enable self-service password reset for all users"
  type        = bool
  default     = true
}

variable "sign_in_page_text" {
  description = "Custom text to display on the sign-in page"
  type        = string
  default     = null
}
