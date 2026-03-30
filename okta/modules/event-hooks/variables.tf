# =============================================================================
# [Narrative] Event Hooks Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — controls which event hooks are enabled by default."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

# -----------------------------------------------------------------------------
# Hook Enable Overrides
# -----------------------------------------------------------------------------

variable "enable_security_event_hook" {
  description = "Enable the security event monitoring hook"
  type        = bool
  default     = null
}

variable "enable_admin_activity_hook" {
  description = "Enable the admin activity monitoring hook"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Hook Endpoints
# -----------------------------------------------------------------------------

variable "security_hook_endpoint" {
  description = "HTTPS endpoint URL for security event hook"
  type        = string
  default     = null
}

variable "admin_hook_endpoint" {
  description = "HTTPS endpoint URL for admin activity hook"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      enable_security_event_hook = false
      enable_admin_activity_hook = false
    }
    elevated = {
      enable_security_event_hook = true
      enable_admin_activity_hook = false
    }
    strict = {
      enable_security_event_hook = true
      enable_admin_activity_hook = true
    }
  }

  # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
  effective = {
    enable_security_event_hook = var.enable_security_event_hook != null ? var.enable_security_event_hook : local.profile_defaults[var.risk_profile].enable_security_event_hook
    enable_admin_activity_hook = var.enable_admin_activity_hook != null ? var.enable_admin_activity_hook : local.profile_defaults[var.risk_profile].enable_admin_activity_hook
  }
}
