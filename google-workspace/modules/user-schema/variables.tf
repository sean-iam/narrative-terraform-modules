# =============================================================================
# [Narrative] User Schema Module — Variables
# =============================================================================
# No risk profile — all attributes are the same across profiles.
# Each attribute can be individually toggled.

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
