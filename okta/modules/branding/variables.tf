# =============================================================================
# [Narrative] Branding Module — Variables
# =============================================================================

variable "primary_color" {
  description = "Primary brand color hex code for the Okta sign-in page"
  type        = string
  default     = "#1a1a2e"
}

variable "secondary_color" {
  description = "Secondary/link color hex code for the Okta sign-in page"
  type        = string
  default     = "#38bdf8"
}

variable "enable_security_notifications" {
  description = "Enable Okta security notification emails (new device, factor enrollment/reset, password change, suspicious activity)"
  type        = bool
  default     = true
}

variable "custom_domain" {
  description = "Custom domain for Okta sign-in (e.g., login.example.com). Set to null to skip custom domain configuration."
  type        = string
  default     = null
}
