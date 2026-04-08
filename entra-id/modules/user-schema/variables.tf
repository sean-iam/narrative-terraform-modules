# =============================================================================
# [Narrative] User Schema Module — Variables
# =============================================================================

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
