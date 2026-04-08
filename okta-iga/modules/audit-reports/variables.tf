# =============================================================================
# [Narrative] Audit Reports Module — Variables
# =============================================================================

variable "risk_profile" {
  description = "Risk profile tier"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "elevated", "strict"], var.risk_profile)
    error_message = "Must be standard, elevated, or strict."
  }
}

variable "enable_scheduled_reports" {
  description = "Enable scheduled governance reports"
  type        = bool
  default     = null
}

variable "report_frequency" {
  description = "Report generation frequency"
  type        = string
  default     = null

  validation {
    condition     = var.report_frequency == null || contains(["weekly", "monthly", "quarterly"], var.report_frequency)
    error_message = "Must be weekly, monthly, or quarterly."
  }
}

variable "report_recipients" {
  description = "Email addresses for scheduled reports"
  type        = list(string)
  default     = []
}

variable "enable_compliance_dashboard" {
  description = "Enable the governance compliance dashboard"
  type        = bool
  default     = null
}

variable "enable_siem_export" {
  description = "Enable SIEM export of governance events"
  type        = bool
  default     = null
}

variable "siem_endpoint" {
  description = "HTTPS endpoint for SIEM export"
  type        = string
  default     = null
}

locals {
  profile_defaults = {
    standard = {
      enable_scheduled_reports    = false
      report_frequency            = "quarterly"
      enable_compliance_dashboard = false
      enable_siem_export          = false
    }
    elevated = {
      enable_scheduled_reports    = true
      report_frequency            = "monthly"
      enable_compliance_dashboard = true
      enable_siem_export          = false
    }
    strict = {
      enable_scheduled_reports    = true
      report_frequency            = "weekly"
      enable_compliance_dashboard = true
      enable_siem_export          = true
    }
  }

  effective = {
    enable_scheduled_reports    = var.enable_scheduled_reports != null ? var.enable_scheduled_reports : local.profile_defaults[var.risk_profile].enable_scheduled_reports
    report_frequency            = coalesce(var.report_frequency, local.profile_defaults[var.risk_profile].report_frequency)
    enable_compliance_dashboard = var.enable_compliance_dashboard != null ? var.enable_compliance_dashboard : local.profile_defaults[var.risk_profile].enable_compliance_dashboard
    enable_siem_export          = var.enable_siem_export != null ? var.enable_siem_export : local.profile_defaults[var.risk_profile].enable_siem_export
  }
}
