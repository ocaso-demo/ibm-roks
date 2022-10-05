variable "resource_group_name" {
  type    = string
  default = "dteroks"
}

variable "shared_access_group_name" {
  type    = string
  default = "dteroks-users"
}

variable "datacenter" {
  type    = string
  default = "sjc03"
}

variable "user_email" {
  type = string
}

variable "user_id" {
  type = string
}

variable "requestId" {
  type    = string
  default = "NoRequestID"
}

variable "templateId" {
  type    = string
  default = "NoTemplateID"
}

variable "cloudAccount" {
  type    = string
  default = ""
}

variable "cloudTarget" {
  type    = string
  default = ""
}

variable "ibm_cp_image_registry" {
  type    = string
  default = "cp.icr.io"
}

variable "ibm_entitlement_key" {
  description = "IBM Entitled Registry Key"
  type        = string
  sensitive   = true
}

variable "bootstrap_script_source_url" {
  description = "bootstrap.sh script source URL"
  type        = string
  default     = "https://raw.githubusercontent.com/cloud-native-toolkit/multi-tenancy-gitops/master/scripts/bootstrap.sh"
}

