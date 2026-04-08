# =============================================================================
# [Narrative] Network Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — sets defaults for network security settings."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

variable "group_ids" {
  description = "Map of group names to IDs from the groups module"
  type        = map(string)
}

variable "trusted_cidrs" {
  description = "Trusted IP CIDRs (office networks, VPN endpoints)"
  type        = list(string)
  default     = []
}

variable "enable_context_aware_access" {
  description = "Enable context-aware access policies (requires Cloud Identity Premium)"
  type        = bool
  default     = null
}

variable "enforce_ip_allowlist" {
  description = "Restrict admin and service account access to trusted IPs only"
  type        = bool
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      enable_context_aware_access = false
      enforce_ip_allowlist        = false
    }
    elevated = {
      enable_context_aware_access = true
      enforce_ip_allowlist        = true
    }
    strict = {
      enable_context_aware_access = true
      enforce_ip_allowlist        = true
    }
  }

  # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
  effective = {
    trusted_cidrs              = var.trusted_cidrs
    enable_context_aware_access = var.enable_context_aware_access != null ? var.enable_context_aware_access : local.profile_defaults[var.risk_profile].enable_context_aware_access
    enforce_ip_allowlist       = var.enforce_ip_allowlist != null ? var.enforce_ip_allowlist : local.profile_defaults[var.risk_profile].enforce_ip_allowlist
  }
}
