# =============================================================================
# [Narrative] Network Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — sets defaults for all network security settings. Standard is baseline, Elevated adds geo/high-risk blocking, Strict flips to allowlist-only access."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

variable "trusted_cidrs" {
  description = "Trusted IP CIDRs (office networks, VPN endpoints)"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Geo Blocking Override Variables
# -----------------------------------------------------------------------------

variable "ofac_countries" {
  description = "Countries under OFAC sanctions. Authentication from these countries is blocked. Current list: North Korea, Iran, Cuba, Syria."
  type        = list(string)
  default     = ["KP", "IR", "CU", "SY"]
}

variable "enable_high_risk_blocking" {
  description = "Block authentication from high-risk countries. Enabled by default for elevated and strict profiles."
  type        = bool
  default     = null
}

variable "high_risk_countries" {
  description = "Countries considered high-risk. Blocked when enable_high_risk_blocking is true."
  type        = list(string)
  default     = ["RU", "CN", "BY", "VE", "MM"]
}

variable "geo_mode" {
  description = "Standard and Elevated block specific countries. Strict mode flips to allowlist-only — only countries you explicitly approve are allowed."
  type        = string
  default     = null
}

variable "allowlist_countries" {
  description = "Countries to allow when geo_mode is allowlist. Only used in strict mode."
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      enable_high_risk_blocking = false
      geo_mode                  = "blocklist"
    }
    elevated = {
      enable_high_risk_blocking = true
      geo_mode                  = "blocklist"
    }
    strict = {
      enable_high_risk_blocking = true
      geo_mode                  = "allowlist"
    }
  }

  # NOTE: Use ternary (not coalesce) for booleans — coalesce treats false as null
  effective = {
    enable_ofac_blocking      = true # Always enabled for all profiles
    ofac_countries            = var.ofac_countries
    enable_high_risk_blocking = var.enable_high_risk_blocking != null ? var.enable_high_risk_blocking : local.profile_defaults[var.risk_profile].enable_high_risk_blocking
    high_risk_countries       = var.high_risk_countries
    geo_mode                  = coalesce(var.geo_mode, local.profile_defaults[var.risk_profile].geo_mode)
    allowlist_countries       = var.allowlist_countries
    trusted_cidrs             = var.trusted_cidrs
  }
}
