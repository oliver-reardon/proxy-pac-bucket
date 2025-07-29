locals {
  # Common tags applied to all resources
  base_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedAt   = timestamp()
  }

  # Merge base tags with custom tags
  common_tags = merge(local.base_tags, var.tags)

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}