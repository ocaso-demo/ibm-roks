output "cluster_id" {
  description = "Cluster ID"
  value       = resource.ibm_container_vpc_cluster.cluster.id
}

output "cluster_name" {
  description = "Cluster Name"
  value       = resource.ibm_container_vpc_cluster.cluster.name
}

output "cluster_url" {
  description = "Cluster URL"
  value       = "https://cloud.ibm.com/kubernetes/clusters/${resource.ibm_container_vpc_cluster.cluster.id}/overview?platformType=openshift"
}

output "openshift_web_console" {
  description = "Cluster URL"
  value       = resource.ibm_container_vpc_cluster.cluster.public_service_endpoint_url
}

output "ocp_version" {
  description = "OCP Version"
  value       = resource.ibm_container_vpc_cluster.cluster.kube_version
}

output "compute_nodes_flavor" {
  description = "Worker Node Flavor"
  value       = resource.ibm_container_vpc_cluster.cluster.flavor
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

# output "next_steps" {
#   description = "Next Steps"
#   value       = "https://github.com/${var.git_org}/multi-tenancy-gitops#select-resources-to-deploy"
# }