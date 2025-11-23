# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-23

### Added
- Initial release of Backup for GKE Terraform module
- Backup plan resource configuration with retention policies
- Restore plan resource configuration with flexible restore options
- Support for scheduled backups using cron expressions
- Namespace-based backup scope configuration
- Configurable backup retention and deletion lock periods
- Volume data and secrets backup capabilities
- Restore configuration with conflict resolution policies
- Support for namespaced resource restore modes
- Volume data restore policy configuration

### Outputs
- `backup_plan_id` - The ID of the backup plan
- `backup_plan_name` - The name of the backup plan
- `backup_plan_location` - The location of the backup plan
- `backup_plan_state` - The state of the backup plan

### Requirements
- Terraform >= 1.5.0
- Google Provider >= 7.0.0, < 8.0.0
- Google Beta Provider >= 7.0.0, < 8.0.0