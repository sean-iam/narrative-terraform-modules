# =============================================================================
# [Narrative] Apps Module — Variables
# =============================================================================

variable "oidc_apps" {
  description = "OIDC web applications to configure"
  type = list(object({
    display_name   = string
    redirect_uris  = list(string)
    logout_url     = optional(string, null)
    grant_types    = optional(list(string), ["authorization_code"])
    group_ids      = optional(list(string), [])
  }))
  default = []
}

variable "saml_apps" {
  description = "SAML enterprise applications to configure"
  type = list(object({
    display_name    = string
    sign_on_url     = string
    identifier_uris = list(string)
    reply_urls      = list(string)
    group_ids       = optional(list(string), [])
  }))
  default = []
}

variable "service_apps" {
  description = "Service principal / M2M applications"
  type = list(object({
    display_name = string
  }))
  default = []
}

variable "linked_sso_apps" {
  description = "Linked SSO applications (portal links)"
  type = list(object({
    display_name = string
    login_url    = string
    group_ids    = optional(list(string), [])
  }))
  default = []
}
