# =============================================================================
# Narrative Terraform Modules — Okta
# Top-level variables passed to all modules
# =============================================================================

# -----------------------------------------------------------------------------
# Provider
# -----------------------------------------------------------------------------

variable "okta_org_name" {
  description = "Okta org name (e.g., 'dev-12345' from dev-12345.okta.com)"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL (okta.com, oktapreview.com, or okta-emea.com)"
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token with Super Admin privileges"
  type        = string
  sensitive   = true
}

# -----------------------------------------------------------------------------
# Organization
# -----------------------------------------------------------------------------

variable "org_display_name" {
  description = "Organization display name used in branding and policies"
  type        = string
}

variable "org_domain" {
  description = "Primary domain for the organization"
  type        = string
}

# -----------------------------------------------------------------------------
# Risk Profile
# -----------------------------------------------------------------------------

variable "risk_profile" {
  description = "Risk profile tier — sets defaults for all modules. Standard is baseline security, Elevated adds phishing-resistant MFA and geo-blocking, Strict enforces hardware keys and allowlist-only access."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

# -----------------------------------------------------------------------------
# Groups Module Overrides
# -----------------------------------------------------------------------------

variable "enable_department_groups" {
  description = "Create department-based groups with auto-assignment rules"
  type        = bool
  default     = null
}

variable "departments" {
  description = "List of departments to create groups for"
  type        = list(string)
  default     = ["Engineering", "Finance", "Human Resources", "IT Operations", "Sales", "Customer Support", "Legal & Compliance"]
}

variable "enable_contractor_group" {
  description = "Create a contractors group"
  type        = bool
  default     = true
}

variable "enable_executive_group" {
  description = "Create an executive leadership group"
  type        = bool
  default     = true
}

variable "enable_geo_exception_groups" {
  description = "Create geo-blocking exception groups"
  type        = bool
  default     = true
}

variable "custom_groups" {
  description = "Additional custom groups"
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Authenticators Module Overrides
# -----------------------------------------------------------------------------

variable "mfa_method" {
  description = "Primary MFA method — overrides risk_profile default"
  type        = string
  default     = null
}

variable "enable_webauthn" {
  description = "Enable WebAuthn/FIDO2"
  type        = bool
  default     = null
}

variable "enable_email_recovery" {
  description = "Enable email recovery"
  type        = bool
  default     = true
}

variable "email_token_lifetime_minutes" {
  description = "Email token lifetime"
  type        = number
  default     = 5
}

# -----------------------------------------------------------------------------
# Password Policies Module Overrides
# -----------------------------------------------------------------------------

variable "password_min_length" {
  description = "Minimum password length for end users — overrides risk_profile default"
  type        = number
  default     = null
}

variable "password_max_age_days" {
  description = "Maximum password age in days for end users before rotation is required (0 to disable)"
  type        = number
  default     = null
}

variable "password_history_count" {
  description = "Number of previous passwords users cannot reuse — overrides risk_profile default"
  type        = number
  default     = null
}

variable "password_lockout_attempts" {
  description = "Failed login attempts before account lockout — overrides risk_profile default"
  type        = number
  default     = null
}

variable "password_lockout_duration_minutes" {
  description = "Minutes before a locked account auto-unlocks — overrides risk_profile default"
  type        = number
  default     = null
}

variable "admin_password_min_length" {
  description = "Minimum password length for administrator accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "admin_password_max_age_days" {
  description = "Maximum password age in days for admin accounts before rotation is required (0 to disable)"
  type        = number
  default     = null
}

variable "enable_lockout_admin_notification" {
  description = "Send admin notification on account lockout — overrides risk_profile default"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Sign-On Policies Module Overrides
# -----------------------------------------------------------------------------

variable "employee_idle_timeout_minutes" {
  description = "Idle session timeout in minutes for employee accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "admin_idle_timeout_minutes" {
  description = "Idle session timeout in minutes for administrator accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "max_session_lifetime_minutes" {
  description = "Maximum session lifetime in minutes before forced re-authentication — overrides risk_profile default"
  type        = number
  default     = null
}

variable "mfa_prompt_mode" {
  description = "MFA prompt behavior for employees — DEVICE, SESSION, or ALWAYS — overrides risk_profile default"
  type        = string
  default     = null
}

variable "mfa_remember_device" {
  description = "Allow employees to register trusted devices to skip MFA prompts — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "mfa_lifetime_minutes" {
  description = "How long a remembered employee device stays trusted in minutes (0 = every session) — overrides risk_profile default"
  type        = number
  default     = null
}

variable "contractor_idle_timeout_minutes" {
  description = "Idle session timeout in minutes for contractor accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "break_glass_max_session_minutes" {
  description = "Maximum session lifetime in minutes for break glass emergency accounts — overrides risk_profile default"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Network Module Overrides
# -----------------------------------------------------------------------------

variable "trusted_cidrs" {
  description = "Trusted IP CIDRs (office networks, VPN endpoints) — used to relax MFA for on-premises users and restrict admin/service account access"
  type        = list(string)
  default     = []
}

variable "ofac_countries" {
  description = "Countries under OFAC sanctions to block — overrides network module default [KP, IR, CU, SY]"
  type        = list(string)
  default     = ["KP", "IR", "CU", "SY"]
}

variable "enable_high_risk_blocking" {
  description = "Block authentication from high-risk countries — overrides risk_profile default (enabled for elevated/strict)"
  type        = bool
  default     = null
}

variable "high_risk_countries" {
  description = "Countries considered high-risk when enable_high_risk_blocking is true — overrides network module default [RU, CN, BY, VE, MM]"
  type        = list(string)
  default     = ["RU", "CN", "BY", "VE", "MM"]
}

variable "geo_mode" {
  description = "Geo-blocking mode — blocklist blocks specific countries, allowlist allows only approved countries (strict mode default)"
  type        = string
  default     = null
}

variable "allowlist_countries" {
  description = "Countries to allow in allowlist (strict) mode — only used when geo_mode is allowlist"
  type        = list(string)
  default     = []
}

variable "enable_tor_blocking" {
  description = "Block Tor exit nodes and anonymous proxies — overrides risk_profile default (enabled for elevated/strict)"
  type        = bool
  default     = null
}

variable "threat_insight_action" {
  description = "Okta ThreatInsight response to suspicious IPs — none, audit, or block"
  type        = string
  default     = "block"
}

# -----------------------------------------------------------------------------
# Behaviors Module Overrides
# -----------------------------------------------------------------------------

variable "velocity_threshold_kmh" {
  description = "Impossible travel velocity threshold in km/h"
  type        = number
  default     = 805
}

variable "impossible_travel_action" {
  description = "Action for impossible travel events — overrides risk_profile default"
  type        = string
  default     = null
}

variable "new_device_action" {
  description = "Action for new device events — overrides risk_profile default"
  type        = string
  default     = null
}

variable "new_city_action" {
  description = "Action for new city events — overrides risk_profile default"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Apps Module Variables
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# Auth Server Module Overrides
# -----------------------------------------------------------------------------

variable "auth_server_name" {
  description = "Name for the custom authorization server"
  type        = string
  default     = "custom"
}

variable "auth_server_description" {
  description = "Description for the custom authorization server"
  type        = string
  default     = "Custom authorization server"
}

variable "auth_server_scopes" {
  description = "Custom scopes to create on the authorization server"
  type        = list(string)
  default     = ["read", "write", "admin"]
}

variable "access_token_lifetime_minutes" {
  description = "Access token lifetime in minutes — overrides risk_profile default"
  type        = number
  default     = null
}

variable "refresh_token_lifetime_days" {
  description = "Refresh token lifetime in days — overrides risk_profile default"
  type        = number
  default     = null
}

variable "service_token_lifetime_minutes" {
  description = "Service-to-service token lifetime in minutes — overrides risk_profile default"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# User Schema Module Variables
# -----------------------------------------------------------------------------

variable "enable_employee_id" {
  description = "Create the employee_id custom profile attribute"
  type        = bool
  default     = true
}

variable "enable_manager_email" {
  description = "Create the manager_email custom profile attribute"
  type        = bool
  default     = true
}

variable "enable_start_date" {
  description = "Create the start_date custom profile attribute"
  type        = bool
  default     = true
}

variable "enable_end_date" {
  description = "Create the end_date custom profile attribute"
  type        = bool
  default     = true
}

variable "enable_office_location" {
  description = "Create the office_location custom profile attribute"
  type        = bool
  default     = true
}

variable "enable_risk_level" {
  description = "Create the risk_level custom profile attribute"
  type        = bool
  default     = true
}

variable "enable_last_access_review_date" {
  description = "Create the last_access_review_date custom profile attribute"
  type        = bool
  default     = true
}
