# =============================================================================
# [Narrative] Behaviors Module — Variables
# Identity Protection risk policies for sign-in risk, user risk, and
# impossible travel detection.
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — sets defaults for Identity Protection risk policy responses."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

variable "group_ids" {
  description = "Map of group names to object IDs"
  type        = map(string)
}

# -----------------------------------------------------------------------------
# Risk Policy Configuration
# -----------------------------------------------------------------------------

variable "sign_in_risk_action" {
  description = "Action when risky sign-in detected — allow, mfa_required, or block"
  type        = string
  default     = null
}

variable "user_risk_action" {
  description = "Action when risky user detected — allow, password_change, or block"
  type        = string
  default     = null
}

variable "sign_in_risk_level" {
  description = "Minimum sign-in risk level to trigger action — low, medium, or high"
  type        = string
  default     = null
}

variable "user_risk_level" {
  description = "Minimum user risk level to trigger action — low, medium, or high"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      sign_in_risk_action = "allow"
      user_risk_action    = "allow"
      sign_in_risk_level  = "high"
      user_risk_level     = "high"
    }
    elevated = {
      sign_in_risk_action = "mfa_required"
      user_risk_action    = "password_change"
      sign_in_risk_level  = "medium"
      user_risk_level     = "medium"
    }
    strict = {
      sign_in_risk_action = "block"
      user_risk_action    = "password_change"
      sign_in_risk_level  = "low"
      user_risk_level     = "low"
    }
  }

  effective = {
    sign_in_risk_action = coalesce(var.sign_in_risk_action, local.profile_defaults[var.risk_profile].sign_in_risk_action)
    user_risk_action    = coalesce(var.user_risk_action, local.profile_defaults[var.risk_profile].user_risk_action)
    sign_in_risk_level  = coalesce(var.sign_in_risk_level, local.profile_defaults[var.risk_profile].sign_in_risk_level)
    user_risk_level     = coalesce(var.user_risk_level, local.profile_defaults[var.risk_profile].user_risk_level)
  }
}
