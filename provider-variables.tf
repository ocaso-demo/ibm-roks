### Cloud Provider Credentials ####
variable "ibmcloud_api_key" {
  type = string
}

# Cloud Provider ID
variable "cloud_provider" {
  type    = string
  default = "ibmcloud"
}