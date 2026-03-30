# =============================================================================
# [Narrative] User Schema Module
# Custom user profile attributes for identity lifecycle and governance.
#
# Attribute inventory:
# 1. employee_id             — Unique HR identifier (read-only, unique)
# 2. manager_email           — Direct manager email (read-only)
# 3. start_date              — Employment start date (read-only)
# 4. end_date                — Employment end date (read-only)
# 5. office_location         — Physical office location (read-only)
# 6. risk_level              — User risk tier: low/medium/high/critical (read-only)
# 7. last_access_review_date — Last access certification date (read-only)
#
# All attributes are sourced from PROFILE_MASTER (HR system) and set to
# READ_ONLY to prevent end-user modification.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Employee ID
# Unique identifier from the HR system. Used for cross-system correlation.
# -----------------------------------------------------------------------------

resource "okta_user_schema_property" "employee_id" {
  count       = var.enable_employee_id ? 1 : 0
  index       = "employee_id"
  title       = "Employee ID"
  type        = "string"
  description = "[Narrative] Unique employee identifier from HR system."
  master      = "PROFILE_MASTER"
  scope       = "NONE"
  user_type   = "default"
  permissions = "READ_ONLY"
  unique      = "UNIQUE_VALIDATED"
}

# -----------------------------------------------------------------------------
# 2. Manager Email
# Used for manager-based approval workflows and org hierarchy.
# -----------------------------------------------------------------------------

resource "okta_user_schema_property" "manager_email" {
  count       = var.enable_manager_email ? 1 : 0
  index       = "manager_email"
  title       = "Manager Email"
  type        = "string"
  description = "[Narrative] Direct manager email address from HR system."
  master      = "PROFILE_MASTER"
  scope       = "NONE"
  user_type   = "default"
  permissions = "READ_ONLY"
}

# -----------------------------------------------------------------------------
# 3. Start Date
# Employment start date — used for onboarding automation.
# -----------------------------------------------------------------------------

resource "okta_user_schema_property" "start_date" {
  count       = var.enable_start_date ? 1 : 0
  index       = "start_date"
  title       = "Start Date"
  type        = "string"
  description = "[Narrative] Employment start date from HR system."
  master      = "PROFILE_MASTER"
  scope       = "NONE"
  user_type   = "default"
  permissions = "READ_ONLY"
}

# -----------------------------------------------------------------------------
# 4. End Date
# Employment end date — used for offboarding and deprovisioning automation.
# -----------------------------------------------------------------------------

resource "okta_user_schema_property" "end_date" {
  count       = var.enable_end_date ? 1 : 0
  index       = "end_date"
  title       = "End Date"
  type        = "string"
  description = "[Narrative] Employment end date from HR system."
  master      = "PROFILE_MASTER"
  scope       = "NONE"
  user_type   = "default"
  permissions = "READ_ONLY"
}

# -----------------------------------------------------------------------------
# 5. Office Location
# Physical office for location-based policies and reporting.
# -----------------------------------------------------------------------------

resource "okta_user_schema_property" "office_location" {
  count       = var.enable_office_location ? 1 : 0
  index       = "office_location"
  title       = "Office Location"
  type        = "string"
  description = "[Narrative] Physical office location from HR system."
  master      = "PROFILE_MASTER"
  scope       = "NONE"
  user_type   = "default"
  permissions = "READ_ONLY"
}

# -----------------------------------------------------------------------------
# 6. Risk Level
# Assigned risk tier — drives adaptive access policies.
# -----------------------------------------------------------------------------

resource "okta_user_schema_property" "risk_level" {
  count       = var.enable_risk_level ? 1 : 0
  index       = "risk_level"
  title       = "Risk Level"
  type        = "string"
  description = "[Narrative] User risk classification for adaptive access policies."
  master      = "PROFILE_MASTER"
  scope       = "NONE"
  user_type   = "default"
  permissions = "READ_ONLY"

  enum = ["low", "medium", "high", "critical"]

  one_of {
    const = "low"
    title = "Low"
  }
  one_of {
    const = "medium"
    title = "Medium"
  }
  one_of {
    const = "high"
    title = "High"
  }
  one_of {
    const = "critical"
    title = "Critical"
  }
}

# -----------------------------------------------------------------------------
# 7. Last Access Review Date
# Tracks the most recent access certification — used for compliance reporting.
# -----------------------------------------------------------------------------

resource "okta_user_schema_property" "last_access_review_date" {
  count       = var.enable_last_access_review_date ? 1 : 0
  index       = "last_access_review_date"
  title       = "Last Access Review Date"
  type        = "string"
  description = "[Narrative] Date of most recent access certification review."
  master      = "PROFILE_MASTER"
  scope       = "NONE"
  user_type   = "default"
  permissions = "READ_ONLY"
}
