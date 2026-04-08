# =============================================================================
# [Narrative] Apps Module — Variables
# =============================================================================

variable "group_ids" {
  description = "Map of group names to IDs (from groups module)"
  type        = map(string)
}

variable "pre_installed_apps" {
  description = "Google Workspace apps to pre-install for all users"
  type        = list(string)
  default     = []
}

variable "saml_apps" {
  description = "SAML applications to configure"
  type = list(object({
    app_name     = string
    display_name = string
    acs_url      = string
    entity_id    = string
    start_url    = optional(string, "")
    name_id      = optional(string, "EMAIL")
    group_ids    = optional(list(string), [])
  }))
  default = []
}

variable "blocked_apps" {
  description = "Third-party apps to block by OAuth client ID"
  type        = list(string)
  default     = []
}

variable "app_access_ou_restrictions" {
  description = "Map of app name to list of OUs that can access it"
  type        = map(list(string))
  default     = {}
}
