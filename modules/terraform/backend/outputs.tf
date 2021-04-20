# modules/terraform/backend/outputs.tf

output "bucket" {
  value = local.backend_bucket
}
