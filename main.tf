terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.30.2"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = local.API_KEY
  region = "eu-de"
  resource_group = "RG_OpenShift"
}

# Random cluster name suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  VPCNAME = "gco-vpc-cp4data-frankfurt"
  CLUSTERNAME = "ocaso-demo-${random_string.suffix.result}"
  KUBEVERSION = "4.8.49_openshift"
  NODEFLAVOR = "bx2.4x16"
  NUMNODES = 1
  API_KEY = "API_KEY_PLACEHOLDER"
}

data "ibm_resource_group" "group" {
  name = "RG_OpenShift"
}

data "ibm_resource_group" "cos_group" {
  name = "RG_OCP_Storage_SSCale"
}

data "ibm_is_vpc" "vpc" {
  name = local.VPCNAME
}

data "ibm_is_subnet" "subnet1" {
  name = "service-network01"
}
data "ibm_is_subnet" "subnet2" {
  name = "service-network02"
}
data "ibm_is_subnet" "subnet3" {
  name = "service-network03"
}

data "ibm_resource_instance" "cos_instance" {
  name = "Cloud Object Storage-1v"
  location          = "global"
  resource_group_id = data.ibm_resource_group.cos_group.id
  service           = "cloud-object-storage"
}

# resource "ibm_container_vpc_cluster" "cluster" {
#   name                            = local.CLUSTERNAME
#   vpc_id                          = data.ibm_is_vpc.vpc.id
#   kube_version                    = local.KUBEVERSION
#   flavor                          = local.NODEFLAVOR
#   worker_count                    = local.NUMNODES
#   resource_group_id               = data.ibm_resource_group.group.id
#   # entitlement                     = "cloud_pak"
#   disable_public_service_endpoint = false
#   cos_instance_crn                = data.ibm_resource_instance.cos_instance.crn
#   force_delete_storage            = true
#   zones {
#     name                          = "eu-de-1"
#     subnet_id                     = data.ibm_is_subnet.subnet1.id
#   }
#   zones {
#     name                          = "eu-de-2"
#     subnet_id                     = data.ibm_is_subnet.subnet2.id
#   }
#   zones {
#     name                          = "eu-de-3"
#     subnet_id                     = data.ibm_is_subnet.subnet3.id
#   }
# }


# resource "null_resource" "test" {

#   provisioner "local-exec" {
#     command = "scripts/test.sh"
#     environment = {
#       HOME = "${abspath(path.module)}/home"
#     }
#   }
# }

# # Download kubeconfig for the cluster into home dir
# resource "null_resource" "kubeconfig" {

#   provisioner "local-exec" {
#     command = "scripts/get-kubeconfig.sh || true"
#     environment = {
#       HOME        = "${abspath(path.module)}/home"
#       API_KEY     = local.API_KEY
#       CLUSTERNAME = "ocaso-demo-gub436bh"
#       # CLUSTERNAME = resource.ibm_container_vpc_cluster.cluster.name
#     }
#   }

#   # depends_on = [
#   #   ibm_container_vpc_cluster.cluster
#   # ]
# }

# # Run boostrap.sh
# resource "null_resource" "argo_bootstrap" {

#   provisioner "local-exec" {
#     command = "chmod +x scripts/bootstrap.sh && scripts/bootstrap.sh || true"
#     environment = {
#       HOME = "${abspath(path.module)}/home"
#     }
#   }

#   depends_on = [
#     null_resource.kubeconfig
#   ]
# }

# data "external" "argo_info" {
#   program = ["sh", "${path.module}/scripts/get-argo-info.sh"]
#   query = {
#     kubeconfig = "${abspath(path.module)}/home/.kube/config"
#   }
#   depends_on = [
#     null_resource.argo_bootstrap
#   ]
# }
