# =============================================================================
# [Narrative] Approval Workflows Module
# Multi-level approval chains, escalation, timeout, and delegation.
#
# Terraform support: PARTIAL
# OIG approval workflows are configured through the Governance API
# (/api/v1/governance/workflows). This module creates Okta groups for
# approval chain roles and the policy framework. Workflow routing,
# escalation rules, and delegation settings require API/console config.
#
# Risk profile philosophy:
# - Standard: Single-level approval (manager), 72h timeout, no escalation
# - Elevated: Two-level approval (manager + app owner), 48h, auto-escalate
# - Strict: Three-level (manager + app owner + governance), 24h, escalation
# =============================================================================

# -----------------------------------------------------------------------------
# Approval Chain Groups
# Creates groups for each approval level. These are used by the OIG
# workflow engine to route approvals through the chain.
# -----------------------------------------------------------------------------

resource "okta_group" "approval_level_1" {
  name        = "[Narrative] Approval Level 1 — Direct Manager"
  description = "First-level approvers for access requests. Typically the requester's direct manager."
}

resource "okta_group" "approval_level_2" {
  count = local.effective.approval_levels >= 2 ? 1 : 0

  name        = "[Narrative] Approval Level 2 — Application Owner"
  description = "Second-level approvers. Typically the application or resource owner."
}

resource "okta_group" "approval_level_3" {
  count = local.effective.approval_levels >= 3 ? 1 : 0

  name        = "[Narrative] Approval Level 3 — Governance Admin"
  description = "Third-level approvers. Governance administrators for final approval on high-risk requests."
}

# -----------------------------------------------------------------------------
# Escalation Target Group
# When an approval times out, it escalates to this group.
# -----------------------------------------------------------------------------

resource "okta_group" "escalation_target" {
  count = local.effective.enable_escalation ? 1 : 0

  name        = "[Narrative] Approval Escalation Target"
  description = "Receives escalated approvals when the primary approver does not respond within ${local.effective.approval_timeout_hours} hours. Target: ${local.effective.escalation_target}."
}

# -----------------------------------------------------------------------------
# Approval Workflow Policy
# Creates the policy framework for approval routing.
# Actual workflow logic requires the OIG Governance API.
# -----------------------------------------------------------------------------

resource "okta_policy" "approval_workflow" {
  name        = "[Narrative] Approval Workflow"
  description = "Access request approval workflow. Levels: ${local.effective.approval_levels}. Timeout: ${local.effective.approval_timeout_hours}h. Escalation: ${local.effective.enable_escalation ? "enabled" : "disabled"}. Delegation: ${local.effective.enable_delegation ? "enabled" : "disabled"}."
  type        = "ACCESS_POLICY"
  status      = "ACTIVE"
  priority    = 6

  // Requires Okta Governance API v2024.06+ for:
  // - approval_levels configuration
  // - approval_timeout_hours
  // - escalation_target routing
  // - delegation rules
  // - timeout_action (deny/auto_approve)
  //
  // Workflow config endpoint: PUT /api/v1/governance/workflows/{id}
}

resource "okta_policy_rule" "approval_workflow_rule" {
  policy_id = okta_policy.approval_workflow.id
  name      = "[Narrative] Default Approval Rule"
  status    = "ACTIVE"
  priority  = 1

  // Workflow routing properties configured via Governance API.
  // Level 1: Direct manager (always required)
  // Level 2: Application owner (elevated/strict)
  // Level 3: Governance admin (strict only)
}
