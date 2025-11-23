# tfmodule-google-backup-for-gke

Terraform module for managing Google Kubernetes Engine (GKE) Backup and Restore plans. This module provides automated backup scheduling, retention policies, and restore capabilities for GKE clusters and their resources.

## Features

- **Automated Backup Plans**: Configure scheduled backups using cron expressions
- **Retention Management**: Set customizable backup retention periods and deletion lock days
- **Namespace-based Backups**: Selectively backup specific Kubernetes namespaces
- **Secrets Protection**: Automatically include Kubernetes secrets in backups
- **Restore Plans**: Pre-configured restore plans with flexible conflict resolution
- **Volume Data Policy**: Configurable volume data restore strategies
- **Resource Restore Modes**: Control how namespaced resources are restored
- **Conflict Resolution**: Define policies for handling cluster resource conflicts during restore

## Usage

### Basic Example
```hcl
module "gke_backup" {
  source = "github.com/your-org/tfmodule-google-backup-for-gke?ref=v1.0.0"

  backup_name              = "my-gke-backup-plan"
  restore_name             = "my-gke-restore-plan"
  region                   = "us-central1"
  cluster_id               = "projects/my-project/locations/us-central1/clusters/my-cluster"
  
  # Retention policy
  backup_delete_lock_days  = 7
  backup_retain_days       = 30
  
  # Schedule - Daily at 2 AM
  cron_schedule            = "0 2 * * *"
  
  # Backup scope
  namespaces               = "production"
  
  # Restore configuration
  volume_data_restore_policy          = "NO_VOLUME_DATA_RESTORATION"
  namespaced_resource_restore_mode    = "DELETE_AND_RESTORE"
  cluster_resource_conflict_policy    = "USE_EXISTING_VERSION"
}
```

### Production Example with Extended Retention
```hcl
module "gke_backup_production" {
  source = "github.com/your-org/tfmodule-google-backup-for-gke?ref=v1.0.0"

  backup_name              = "production-backup-plan"
  restore_name             = "production-restore-plan"
  region                   = "us-east1"
  cluster_id               = "projects/prod-project/locations/us-east1/clusters/prod-cluster"
  
  # Extended retention for production
  backup_delete_lock_days  = 14
  backup_retain_days       = 90
  
  # Backup twice daily - 2 AM and 2 PM
  cron_schedule            = "0 2,14 * * *"
  
  # Critical production namespace
  namespaces               = "production"
  
  # Production restore settings
  volume_data_restore_policy          = "RESTORE_VOLUME_DATA_FROM_BACKUP"
  namespaced_resource_restore_mode    = "FAIL_ON_CONFLICT"
  cluster_resource_conflict_policy    = "USE_EXISTING_VERSION"
}
```

### Multi-Namespace Backup Example
```hcl
module "gke_backup_staging" {
  source = "github.com/your-org/tfmodule-google-backup-for-gke?ref=v1.0.0"

  backup_name              = "staging-backup-plan"
  restore_name             = "staging-restore-plan"
  region                   = "europe-west1"
  cluster_id               = "projects/staging-project/locations/europe-west1/clusters/staging-cluster"
  
  # Standard retention
  backup_delete_lock_days  = 5
  backup_retain_days       = 30
  
  # Weekly backup - Every Sunday at 3 AM
  cron_schedule            = "0 3 * * 0"
  
  # Staging namespace
  namespaces               = "staging"
  
  # Staging restore settings
  volume_data_restore_policy          = "NO_VOLUME_DATA_RESTORATION"
  namespaced_resource_restore_mode    = "DELETE_AND_RESTORE"
  cluster_resource_conflict_policy    = "USE_BACKUP_VERSION"
}
```

### Disaster Recovery Example
```hcl
module "gke_backup_dr" {
  source = "github.com/your-org/tfmodule-google-backup-for-gke?ref=v1.0.0"

  backup_name              = "dr-backup-plan"
  restore_name             = "dr-restore-plan"
  region                   = "asia-southeast1"
  cluster_id               = "projects/dr-project/locations/asia-southeast1/clusters/dr-cluster"
  
  # Long-term retention for DR
  backup_delete_lock_days  = 30
  backup_retain_days       = 180
  
  # Daily backup at midnight
  cron_schedule            = "0 0 * * *"
  
  # Critical applications namespace
  namespaces               = "critical-apps"
  
  # DR restore settings with volume data
  volume_data_restore_policy          = "RESTORE_VOLUME_DATA_FROM_BACKUP"
  namespaced_resource_restore_mode    = "DELETE_AND_RESTORE"
  cluster_resource_conflict_policy    = "USE_BACKUP_VERSION"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup_name | The name of the Backup for GKE backup plan | `string` | n/a | yes |
| restore_name | The name of the Backup for GKE restore plan | `string` | n/a | yes |
| region | The region of the GKE cluster to back up | `string` | n/a | yes |
| cluster_id | The ID of the GKE cluster to back up (format: projects/PROJECT_ID/locations/LOCATION/clusters/CLUSTER_NAME) | `string` | n/a | yes |
| backup_delete_lock_days | The number of days to lock the backup from deletion | `number` | n/a | yes |
| backup_retain_days | The number of days to retain the backup | `number` | n/a | yes |
| cron_schedule | The cron schedule for the Backup for GKE backup plan (e.g., "0 2 * * *" for daily at 2 AM) | `string` | n/a | yes |
| namespaces | The namespace to include in the backup | `string` | n/a | yes |
| volume_data_restore_policy | The policy for restoring volume data. Valid values: NO_VOLUME_DATA_RESTORATION, RESTORE_VOLUME_DATA_FROM_BACKUP, REUSE_VOLUME_HANDLE_FROM_BACKUP | `string` | n/a | yes |
| namespaced_resource_restore_mode | The restore mode for namespaced resources. Valid values: DELETE_AND_RESTORE, FAIL_ON_CONFLICT, MERGE_SKIP_ON_CONFLICT, MERGE_REPLACE_VOLUME_ON_CONFLICT, MERGE_REPLACE_ON_CONFLICT | `string` | n/a | yes |
| cluster_resource_conflict_policy | The conflict policy for cluster resources during restore. Valid values: USE_EXISTING_VERSION, USE_BACKUP_VERSION | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backup_plan_id | The ID of the backup plan |
| backup_plan_name | The name of the backup plan |
| backup_plan_location | The location of the backup plan |
| backup_plan_state | The state of the backup plan |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 7.0.0, < 8.0.0 |
| google-beta | >= 7.0.0, < 8.0.0 |

## Notes

### Backup Configuration
- **Volume Data**: This module is configured to exclude volume data from backups (`include_volume_data = false`) by default
- **Secrets**: Kubernetes secrets are automatically included in backups (`include_secrets = true`)
- **Namespace Scope**: Currently supports single namespace per backup plan

### Cron Schedule Examples
- Daily at 2 AM: `0 2 * * *`
- Every 6 hours: `0 */6 * * *`
- Weekly on Sunday at 3 AM: `0 3 * * 0`
- Monthly on 1st at midnight: `0 0 1 * *`

### Volume Data Restore Policies
- **NO_VOLUME_DATA_RESTORATION**: Do not restore volume data (fastest)
- **RESTORE_VOLUME_DATA_FROM_BACKUP**: Restore volume data from backup
- **REUSE_VOLUME_HANDLE_FROM_BACKUP**: Reuse the volume handle from backup

### Namespaced Resource Restore Modes
- **DELETE_AND_RESTORE**: Delete existing resources and restore from backup
- **FAIL_ON_CONFLICT**: Fail the restore if conflicts are detected
- **MERGE_SKIP_ON_CONFLICT**: Merge resources, skip on conflict
- **MERGE_REPLACE_VOLUME_ON_CONFLICT**: Merge resources, replace volumes on conflict
- **MERGE_REPLACE_ON_CONFLICT**: Merge resources, replace on conflict

### Cluster Resource Conflict Policies
- **USE_EXISTING_VERSION**: Use the existing cluster resource version
- **USE_BACKUP_VERSION**: Use the backup version of cluster resources

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history and changes.