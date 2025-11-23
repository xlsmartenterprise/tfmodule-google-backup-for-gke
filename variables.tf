variable "backup_name" {
    description = "The name of the Backup for GKE backup plan."
    type = string
}

variable "restore_name" {
    description = "The name of the Backup for GKE restore plan."
    type = string
}

variable "region" {
    description = "The region of the GKE cluster to back up."
    type = string
}

variable "cluster_id" {
    description = "The ID of the GKE cluster to back up."
    type = string
}

variable "backup_delete_lock_days" {
    description = "The number of days to lock the backup from deletion."
    type = number
}

variable "backup_retain_days" {
    description = "The number of days to retain the backup."
    type = number
}

variable "cron_schedule" {
    description = "The cron schedule for the Backup for GKE backup plan."
    type = string
}

variable "namespaces" {
    description = "The namespaces to include in the backup."
    type = string
}

variable "volume_data_restore_policy" {
    description = "The policy for restoring volume data."
    type = string
}
variable "namespaced_resource_restore_mode" {
    description = "The restore mode for namespaced resources."
    type = string
}

variable "cluster_resource_conflict_policy" {
    description = "The conflict policy for cluster resources during restore."
    type = string
}