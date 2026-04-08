# =============================================================================
# Narrative Terraform Modules — Entra ID
# Top-level variables passed to all modules
# =============================================================================

# -----------------------------------------------------------------------------
# Provider
# -----------------------------------------------------------------------------

variable "tenant_id" {
  description = "Azure AD / Entra ID tenant ID (directory ID from Azure portal)"
  type        = string
}

variable "client_id" {
  description = "Service principal (app registration) client ID with Directory.ReadWrite.All and Policy.ReadWrite.ConditionalAccess permissions"
  type        = string
}

variable "client_secret" {
  description = "Service principal client secret"
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
  description = "Create department-based groups with dynamic membership rules"
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

variable "enable_fido2" {
  description = "Enable FIDO2 security keys"
  type        = bool
  default     = null
}

variable "enable_email_otp" {
  description = "Enable email OTP as an authentication method"
  type        = bool
  default     = true
}

variable "enable_phone_sms" {
  description = "Enable phone SMS as an authentication method"
  type        = bool
  default     = null
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

variable "password_lockout_duration_seconds" {
  description = "Seconds before a locked account auto-unlocks — overrides risk_profile default"
  type        = number
  default     = null
}

variable "enable_banned_password_list" {
  description = "Enable the Entra ID custom banned password list — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "banned_passwords" {
  description = "Custom banned password list (up to 1000 entries)"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Conditional Access Policies Module Overrides
# -----------------------------------------------------------------------------

variable "employee_sign_in_frequency_hours" {
  description = "Sign-in frequency in hours for employee accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "admin_sign_in_frequency_hours" {
  description = "Sign-in frequency in hours for administrator accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "persistent_browser_session" {
  description = "Allow persistent browser sessions for employees — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "require_mfa_for_admins" {
  description = "Require MFA for all admin role assignments — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "require_mfa_for_all_users" {
  description = "Require MFA for all users — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "contractor_sign_in_frequency_hours" {
  description = "Sign-in frequency in hours for contractor accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "block_legacy_auth" {
  description = "Block legacy authentication protocols — overrides risk_profile default"
  type        = bool
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

# -----------------------------------------------------------------------------
# Behaviors Module Overrides
# -----------------------------------------------------------------------------

variable "sign_in_risk_action" {
  description = "Action for sign-in risk events — overrides risk_profile default"
  type        = string
  default     = null
}

variable "user_risk_action" {
  description = "Action for user risk events — overrides risk_profile default"
  type        = string
  default     = null
}

variable "sign_in_risk_level" {
  description = "Minimum sign-in risk level to trigger action — overrides risk_profile default"
  type        = string
  default     = null
}

variable "user_risk_level" {
  description = "Minimum user risk level to trigger action — overrides risk_profile default"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Apps Module Variables
# -----------------------------------------------------------------------------

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
    display_name           = string
    sign_on_url            = string
    identifier_uris        = list(string)
    reply_urls             = list(string)
    group_ids              = optional(list(string), [])
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

# -----------------------------------------------------------------------------
# Auth Server Module Overrides
# -----------------------------------------------------------------------------

variable "app_registration_name" {
  description = "Name for the primary app registration (API)"
  type        = string
  default     = "Narrative API"
}

variable "app_registration_description" {
  description = "Description for the primary app registration"
  type        = string
  default     = "Custom API app registration"
}

variable "api_scopes" {
  description = "Custom OAuth2 scopes to create on the app registration"
  type        = list(string)
  default     = ["read", "write", "admin"]
}

variable "access_token_lifetime_minutes" {
  description = "Access token lifetime in minutes — overrides risk_profile default"
  type        = number
  default     = null
}

variable "id_token_lifetime_minutes" {
  description = "ID token lifetime in minutes — overrides risk_profile default"
  type        = number
  default     = null
}

variable "refresh_token_lifetime_days" {
  description = "Refresh token lifetime in days — overrides risk_profile default"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# User Schema Module Variables
# -----------------------------------------------------------------------------

variable "enable_employee_id" {
  description = "Create the employee_id directory extension attribute"
  type        = bool
  default     = true
}

variable "enable_manager_email" {
  description = "Create the manager_email directory extension attribute"
  type        = bool
  default     = true
}

variable "enable_start_date" {
  description = "Create the start_date directory extension attribute"
  type        = bool
  default     = true
}

variable "enable_end_date" {
  description = "Create the end_date directory extension attribute"
  type        = bool
  default     = true
}

variable "enable_office_location" {
  description = "Create the office_location directory extension attribute"
  type        = bool
  default     = true
}

variable "enable_risk_level" {
  description = "Create the risk_level directory extension attribute"
  type        = bool
  default     = true
}

variable "enable_last_access_review_date" {
  description = "Create the last_access_review_date directory extension attribute"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Branding Module Variables
# -----------------------------------------------------------------------------

variable "primary_color" {
  description = "Primary brand color hex code for the Entra ID sign-in page"
  type        = string
  default     = "#1a1a2e"
}

variable "background_color" {
  description = "Background color hex code for the Entra ID sign-in page"
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

# -----------------------------------------------------------------------------
# Event Hooks Module Overrides
# -----------------------------------------------------------------------------

variable "enable_audit_log_streaming" {
  description = "Enable audit log diagnostic settings — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "enable_sign_in_log_streaming" {
  description = "Enable sign-in log diagnostic settings — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "Azure Log Analytics workspace ID for log streaming destination"
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "Azure Storage Account ID for log archival destination"
  type        = string
  default     = null
}
