# =============================================================================
# [Narrative] Apps Module — Variables
# =============================================================================

variable "oidc_apps" {
  description = "OIDC web applications to configure"
  type = list(object({
    label                      = string
    redirect_uris              = list(string)
    post_logout_redirect_uris  = optional(list(string), [])
    grant_types                = optional(list(string), ["authorization_code", "refresh_token"])
    response_types             = optional(list(string), ["code"])
    token_endpoint_auth_method = optional(string, "client_secret_basic")
    group_ids                  = optional(list(string), [])
  }))
  default = []
}

variable "saml_apps" {
  description = "SAML applications to configure"
  type = list(object({
    label               = string
    sso_url             = string
    recipient           = string
    destination         = string
    audience            = string
    subject_name_format = optional(string, "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress")
    group_ids           = optional(list(string), [])
  }))
  default = []
}

variable "service_apps" {
  description = "OAuth2 service/M2M applications"
  type = list(object({
    label       = string
    grant_types = optional(list(string), ["client_credentials"])
  }))
  default = []
}

variable "bookmark_apps" {
  description = "Bookmark applications (portal links)"
  type = list(object({
    label     = string
    url       = string
    group_ids = optional(list(string), [])
  }))
  default = []
}
