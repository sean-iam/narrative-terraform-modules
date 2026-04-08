output "request_policy_id" {
  description = "Access request governance policy ID"
  value       = local.effective.enable_request_policy ? okta_policy.access_request[0].id : null
}

output "certification_policy_id" {
  description = "Access certification governance policy ID"
  value       = local.effective.enable_certification_policy ? okta_policy.access_certification[0].id : null
}

output "effective_request_policy_action" {
  description = "Resolved access request policy action"
  value       = local.effective.request_policy_action
}

output "effective_certification_policy_action" {
  description = "Resolved certification failure action"
  value       = local.effective.certification_policy_action
}
