# Random cluster name suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  cluster_name = "itzroks-${lower(var.user_id)}-${random_string.suffix.result}"
}

resource "local_file" "git_auth_key" {
  content  = var.git_api_token
  filename = "${path.module}/home/git_auth.key"
}

# Check githhub token
resource "null_resource" "git_auth_login" {
  provisioner "local-exec" {
    command = <<EOF
gh auth login --with-token < ${local_file.git_auth_key.filename}
git config --global user.email "${var.user_email}"
git config --global user.name "${var.user_email}"
EOF
    environment = {
      HOME = "${abspath(path.module)}/home"
    }
  }
}

# Download boostrap.sh
resource "null_resource" "bootstrap_script_download" {

  provisioner "local-exec" {
    command     = "curl -O ${var.bootstrap_script_source_url}"
    working_dir = "${path.module}/home"
  }

  depends_on = [
    null_resource.git_auth_login
  ]
}

# ROKS Cluster
module "roks_cluster" {
  source = "git::ssh://git@github.ibm.com/dte2-0/terraform-modules.git//ibm-roks-cluster"
  providers = {
    ibm = ibm.itz
  }

  ibmcloud_api_key         = var.ibmcloud_api_key
  resource_group_name      = var.resource_group_name
  shared_access_group_name = var.shared_access_group_name
  datacenter               = var.datacenter
  compute_nodes_count      = var.compute_nodes_count
  compute_nodes_flavor     = var.compute_nodes_flavor
  ocp_version              = var.ocp_version
  cluster_name             = local.cluster_name
  user_email               = var.user_email
  user_id                  = var.user_id
  requestId                = var.requestId

  depends_on = [
    null_resource.bootstrap_script_download
  ]
}

# NFS storage
module "nfs" {
  count  = var.nfs > 0 ? 1 : 0
  source = "git::ssh://git@github.ibm.com/dte2-0/terraform-modules.git//ibm-roks-nfs"

  ibmcloud_api_key = var.ibmcloud_api_key
  cluster_name     = module.roks_cluster.cluster_id
  storage_size     = var.nfs

  depends_on = [
    module.roks_cluster
  ]
}

# DTE Environment CRD
module "environment" {
  source = "git::ssh://git@github.ibm.com/dte2-0/terraform-modules.git//environment-crd"

  cloudAccount    = var.cloudAccount
  cloudTarget     = var.cloudTarget
  cloudpakStatus  = "not_installed"
  clusterName     = local.cluster_name
  clusterId       = module.roks_cluster.cluster_id
  clusterURL      = module.roks_cluster.cluster_url
  consoleURL      = module.roks_cluster.server_url
  datacenter      = var.datacenter
  owner           = var.user_email
  resourceGroup   = var.resource_group_name
  resourceGroupID = module.roks_cluster.resource_group_id
  template        = var.templateId
  workerCount     = var.compute_nodes_count
}

# Download kubeconfig for the cluster into home dir
resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = "./scripts/get-kubeconfig.sh || true"
    environment = {
      HOME        = "${abspath(path.module)}/home"
      API_KEY     = var.ibmcloud_api_key
      CLUSTERNAME = module.roks_cluster.cluster_id
    }
  }

  depends_on = [
    module.roks_cluster
  ]
}

# Run boostrap.sh
resource "null_resource" "argo_bootstrap" {

  provisioner "local-exec" {
    command = "chmod +x ./bootstrap.sh && ./bootstrap.sh || true"
    environment = {
      HOME                = "${abspath(path.module)}/home"
      GIT_ORG             = var.git_org
      GIT_TOKEN           = var.git_api_token
      IBM_ENTITLEMENT_KEY = var.ibm_entitlement_key
      OUTPUT_DIR          = "${abspath(path.module)}/home"
    }
    working_dir = "${path.module}/home"
  }

  depends_on = [
    module.nfs,
    null_resource.kubeconfig
  ]
}

data "external" "argo_info" {
  program = ["bash", "${path.module}/scripts/get-argo-info.sh"]
  query = {
    kubeconfig = "${abspath(path.module)}/home/.kube/config"
  }
  depends_on = [
    null_resource.argo_bootstrap
  ]
}
