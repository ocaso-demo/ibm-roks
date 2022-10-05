variable "git_org" {
  description = "***Public GitHub Org Name***. We recommend to create a new github organization for all your gitops repos. Instructions: [How to setup a new organization on GitHub?](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch)"
  type        = string
}

variable "git_api_token" {
  description = "***Public GitHub Access API token***. Please grant 'repo', 'admin:repo_hook', 'admin:org_hook', and 'read:org' scopes to this token. Instructions: [How to create a personal access token?](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)"
  type        = string
  sensitive   = true
}

variable "nfs" {
  description = "Select NFS Size"
  type        = number
  default     = 500
}

variable "compute_nodes_count" {
  description = "Worker Node Count"
  type        = number
  default     = 3
}

variable "compute_nodes_flavor" {
  description = "Worker Node Flavor"
  type        = string
  default     = "b3c.8x32"
}

variable "ocp_version" {
  description = "OpenShift Version"
  type        = string
  default     = "4.8"
}
