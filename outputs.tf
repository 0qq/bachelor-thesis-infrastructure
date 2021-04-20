# outputs.tf

output "container_registry_username" {
  value = module.container_registry.username
}


output "container_registry_password" {
  value     = module.container_registry.password
  sensitive = true
}


output "container_registry_url" {
  value = module.container_registry.url
}
