# =============================================================================
# Narrative Terraform Modules — Google Workspace
# Top-level variables passed to all modules
# =============================================================================

# -----------------------------------------------------------------------------
# Provider
# -----------------------------------------------------------------------------

variable "gw_customer_id" {
  description = "Google Workspace customer ID (e.g., 'C01234abc' from Admin Console > Account > Account settings)"
  type        = string
}

variable "gw_admin_email" {
  description = "Super admin email used for domain-wide delegation impersonation"
  type        = string
}

# -----------------------------------------------------------------------------
# Organization
# -----------------------------------------------------------------------------

variable "org_display_name" {
  description = "Organization display name used in branding and group descriptions"
  type        = string
}

variable "org_domain" {
  description = "Primary domain for the organization (e.g., acmecorp.com)"
  type        = string
}

variable "org_unit_path" {
  description = "Root organizational unit path (e.g., /). Most resources are scoped to this OU."
  type        = string
  default     = "/"
}

# -----------------------------------------------------------------------------
# Risk Profile
# -----------------------------------------------------------------------------

variable "risk_profile" {
  description = "Risk profile tier — sets defaults for all modules. Standard is baseline security, Elevated adds phishing-resistant 2SV and stricter controls, Strict enforces hardware keys and locked-down delegation."
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
  description = "Create department-based groups"
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

variable "custom_groups" {
  description = "Additional custom groups"
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Authenticators Module Overrides (2-Step Verification)
# -----------------------------------------------------------------------------

variable "two_sv_enforcement" {
  description = "2-Step Verification enforcement — overrides risk_profile default"
  type        = string
  default     = null
}

variable "allowed_two_sv_methods" {
  description = "Allowed 2SV methods — overrides risk_profile default"
  type        = string
  default     = null
}

variable "two_sv_grace_period_days" {
  description = "Grace period in days before 2SV is required for new users — overrides risk_profile default"
  type        = number
  default     = null
}

variable "enable_security_keys_only" {
  description = "Require only security keys (no phone-based 2SV) — overrides risk_profile default"
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
  description = "Maximum password age in days before rotation is required (0 to disable)"
  type        = number
  default     = null
}

variable "password_reuse_count" {
  description = "Number of previous passwords users cannot reuse — overrides risk_profile default"
  type        = number
  default     = null
}

variable "password_enforce_strong" {
  description = "Enforce strong password requirements — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "admin_password_min_length" {
  description = "Minimum password length for administrator accounts — overrides risk_profile default"
  type        = number
  default     = null
}

variable "admin_password_max_age_days" {
  description = "Maximum password age in days for admin accounts — overrides risk_profile default"
  type        = number
  default     = null
}

# -----------------------------------------------------------------------------
# Login Policies Module Overrides
# -----------------------------------------------------------------------------

variable "session_duration_hours" {
  description = "Web session duration in hours — overrides risk_profile default"
  type        = number
  default     = null
}

variable "admin_session_duration_hours" {
  description = "Admin console session duration in hours — overrides risk_profile default"
  type        = number
  default     = null
}

variable "enable_login_challenge" {
  description = "Enable login challenges for suspicious activity — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "require_reauth_for_sensitive" {
  description = "Require re-authentication for sensitive actions — overrides risk_profile default"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Network Module Overrides
# -----------------------------------------------------------------------------

variable "trusted_cidrs" {
  description = "Trusted IP CIDRs (office networks, VPN endpoints)"
  type        = list(string)
  default     = []
}

variable "enable_context_aware_access" {
  description = "Enable context-aware access policies — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "enforce_ip_allowlist" {
  description = "Restrict access to trusted IPs only — overrides risk_profile default"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Behaviors Module Overrides
# -----------------------------------------------------------------------------

variable "enable_suspicious_login_challenge" {
  description = "Enable login challenges for suspicious activity — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "account_recovery_method" {
  description = "Account recovery method — overrides risk_profile default"
  type        = string
  default     = null
}

variable "enable_less_secure_apps_block" {
  description = "Block less secure app access — overrides risk_profile default"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Auth Server Module Overrides (OAuth / API Access)
# -----------------------------------------------------------------------------

variable "enable_third_party_apps" {
  description = "Allow third-party app access — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "enable_domain_wide_delegation" {
  description = "Allow domain-wide delegation — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "api_client_access" {
  description = "API client access level — overrides risk_profile default"
  type        = string
  default     = null
}

variable "trusted_apps" {
  description = "List of trusted OAuth app client IDs"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# User Schema Module Variables
# -----------------------------------------------------------------------------

variable "enable_employee_id" {
  description = "Create the employee_id custom schema field"
  type        = bool
  default     = true
}

variable "enable_manager_email" {
  description = "Create the manager_email custom schema field"
  type        = bool
  default     = true
}

variable "enable_start_date" {
  description = "Create the start_date custom schema field"
  type        = bool
  default     = true
}

variable "enable_end_date" {
  description = "Create the end_date custom schema field"
  type        = bool
  default     = true
}

variable "enable_office_location" {
  description = "Create the office_location custom schema field"
  type        = bool
  default     = true
}

variable "enable_risk_level" {
  description = "Create the risk_level custom schema field"
  type        = bool
  default     = true
}

variable "enable_last_access_review_date" {
  description = "Create the last_access_review_date custom schema field"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Branding Module Variables
# -----------------------------------------------------------------------------

variable "primary_color" {
  description = "Primary brand color hex code for the Google Workspace login page"
  type        = string
  default     = "#1a1a2e"
}

variable "secondary_color" {
  description = "Secondary/accent color hex code"
  type        = string
  default     = "#38bdf8"
}

variable "logo_url" {
  description = "URL to the organization logo image"
  type        = string
  default     = null
}

variable "custom_login_page_enabled" {
  description = "Enable custom login page branding"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Event Hooks Module Overrides (Alert Center / Activity Rules)
# -----------------------------------------------------------------------------

variable "enable_security_alerts" {
  description = "Enable security alert rules — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "enable_admin_activity_alerts" {
  description = "Enable admin activity alert rules — overrides risk_profile default"
  type        = bool
  default     = null
}

variable "alert_notification_email" {
  description = "Email address for security alert notifications"
  type        = string
  default     = null
}

variable "audit_log_export_enabled" {
  description = "Enable audit log export to BigQuery or Cloud Storage"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Apps Module Variables
# -----------------------------------------------------------------------------

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
