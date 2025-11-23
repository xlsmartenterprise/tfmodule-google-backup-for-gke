resource "google_gke_backup_backup_plan" "this" {
  name      = var.backup_name
  cluster   = var.cluster_id
  location  = var.region
  
  retention_policy {
    backup_delete_lock_days = var.backup_delete_lock_days
    backup_retain_days      = var.backup_retain_days
  }

  backup_schedule {
    cron_schedule = var.cron_schedule
  }
  
  backup_config {
        include_volume_data = false
        include_secrets     = true

  selected_namespaces {
        namespaces = [var.namespaces]
    }
  }
}

resource "google_gke_backup_restore_plan" "this" {
  name        = var.restore_name
  location    = var.region
  backup_plan = google_gke_backup_backup_plan.this.id
  cluster     = var.cluster_id

  restore_config {
    selected_namespaces {
      namespaces = [var.namespaces]
    }
    volume_data_restore_policy        = var.volume_data_restore_policy
    namespaced_resource_restore_mode  = var.namespaced_resource_restore_mode
    cluster_resource_conflict_policy  = var.cluster_resource_conflict_policy
  }
}