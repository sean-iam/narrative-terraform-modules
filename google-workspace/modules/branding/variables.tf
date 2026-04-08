# =============================================================================
# [Narrative] Branding Module — Variables
# =============================================================================

variable "primary_color" {
  description = "Primary brand color hex code"
  type        = string
  default     = "#1a1a2e"
}

variable "secondary_color" {
  description = "Secondary/accent color hex code"
  type        = string
  default     = "#38bdf8"
}

variable "logo_url" {
  description = "URL to the organization logo image. Must be uploaded manually via Admin Console."
  type        = string
  default     = null
}

variable "custom_login_page_enabled" {
  description = "Enable custom login page branding"
  type        = bool
  default     = true
}
