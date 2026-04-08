# =============================================================================
# [Narrative] User Schema Module — Outputs
# =============================================================================

output "schema_id" {
  description = "Custom schema ID"
  value       = googleworkspace_schema.narrative_iga.schema_id
}

output "schema_name" {
  description = "Custom schema name"
  value       = googleworkspace_schema.narrative_iga.schema_name
}
