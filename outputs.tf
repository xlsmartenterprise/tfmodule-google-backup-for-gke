output "backup_plan_id" {
  description = "The ID of the backup plan"
  value       = google_gke_backup_backup_plan.this.id
}

output "backup_plan_name" {
  description = "The name of the backup plan"
  value       = google_gke_backup_backup_plan.this.name
}

output "backup_plan_location" {
  description = "The location of the backup plan"
  value       = google_gke_backup_backup_plan.this.location
}

output "backup_plan_state" {
  description = "The state of the backup plan"
  value       = google_gke_backup_backup_plan.this.state
}