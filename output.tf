output "cluster_id" {
  description = "Cluster ID"
  value       = module.roks_cluster.cluster_id
}

output "cluster_name" {
  description = "Cluster Name"
  value       = module.roks_cluster.cluster_name
}

output "cluster_url" {
  description = "Cluster URL"
  value       = module.roks_cluster.cluster_url
}

output "ocp_version" {
  description = "OCP Version"
  value       = module.roks_cluster.ocp_version
}

output "argo_url" {
  description = "Argo CD URL"
  value       = "https://${data.external.argo_info.result.route}"
}

output "argo_username" {
  description = "Argo CD Username"
  value       = "admin"
}

output "argo_password" {
  description = "Argo CD Password"
  value       = base64decode(data.external.argo_info.result.password)
}

# Special vars
output "desktop" {
  description = "ROKS Cluster"
  value       = module.roks_cluster.cluster_url
}

output "environmentid" {
  value = module.roks_cluster.cluster_id
}

output "envName" {
  value = module.roks_cluster.cluster_name
}

output "sharingportalid" {
  description = "Argo CD Username"
  value       = "admin"
}

output "sharingPortalPwd" {
  description = "Argo CD Password"
  value       = base64decode(data.external.argo_info.result.password)
}

output "next_steps" {
  description = "Next Steps"
  value       = "https://github.com/${var.git_org}/multi-tenancy-gitops#select-resources-to-deploy"
}

output "compute_nodes_flavor" {
  description = "Worker Node Flavor"
  value       = var.compute_nodes_flavor
}