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
