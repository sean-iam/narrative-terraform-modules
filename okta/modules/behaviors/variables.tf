# =============================================================================
# [Narrative] Behaviors Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier — sets defaults for anomaly detection response actions."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

# -----------------------------------------------------------------------------
# Behavior Configuration
# -----------------------------------------------------------------------------

variable "velocity_threshold_kmh" {
  description = "Impossible travel velocity threshold in km/h. Authentications exceeding this speed between locations trigger anomaly detection."
  type        = number
  default     = 805
}

# -----------------------------------------------------------------------------
# Action Overrides (metadata — consumed by sign-on policies)
# -----------------------------------------------------------------------------

variable "impossible_travel_action" {
  description = "Action when impossible travel is detected — log, step_up_mfa, or terminate_session"
  type        = string
  default     = null
}

variable "new_device_action" {
  description = "Action when a new device is detected — log, step_up_mfa, or step_up_mfa_alert"
  type        = string
  default     = null
}

variable "new_city_action" {
  description = "Action when a login from a new city is detected — log, step_up_mfa, or step_up_mfa_alert"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Locals — Profile Defaults and Effective Values
# -----------------------------------------------------------------------------

locals {
  profile_defaults = {
    standard = {
      impossible_travel_action = "log"
      new_device_action        = "log"
      new_city_action          = "log"
    }
    elevated = {
      impossible_travel_action = "step_up_mfa"
      new_device_action        = "step_up_mfa"
      new_city_action          = "step_up_mfa"
    }
    strict = {
      impossible_travel_action = "terminate_session"
      new_device_action        = "step_up_mfa_alert"
      new_city_action          = "step_up_mfa_alert"
    }
  }

  effective = {
    velocity_threshold_kmh   = var.velocity_threshold_kmh
    impossible_travel_action = coalesce(var.impossible_travel_action, local.profile_defaults[var.risk_profile].impossible_travel_action)
    new_device_action        = coalesce(var.new_device_action, local.profile_defaults[var.risk_profile].new_device_action)
    new_city_action          = coalesce(var.new_city_action, local.profile_defaults[var.risk_profile].new_city_action)
  }
}
