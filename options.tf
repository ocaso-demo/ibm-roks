variable "nfs_options" {
  type = list(object({
    value      = number
    prettyName = string
  }))
  default = [
    {
      value      = 0
      prettyName = "None"
    },
    {
      value      = 500
      prettyName = "500 GB"
    },
    {
      value      = 1000
      prettyName = "1 TB"
    },
    {
      value      = 2000
      prettyName = "2 TB"
    },
    {
      value      = 4000
      prettyName = "4 TB"
    }
  ]
}

variable "compute_nodes_count_options" {
  type = list(object({
    value      = number
    prettyName = string
  }))
  default = [
    {
      value      = 3
      prettyName = "3"
    },
    {
      value      = 5
      prettyName = "5"
    },
    {
      value      = 8
      prettyName = "8"
    }
  ]
}

variable "compute_nodes_flavor_options" {
  type = list(object({
    value      = string
    prettyName = string
  }))
  default = [
    {
      value      = "b3c.8x32"
      prettyName = "b3c.8x32 (8 vCPU x 32GB - 100GB Secondary Storage)"
    },
    {
      value      = "b3c.16x64"
      prettyName = "b3c.16x64 (16 vCPU x 64GB - 100GB Secondary Storage)"
    },
    {
      value      = "b3c.16x64.300gb"
      prettyName = "b3c.16x64.300gb (16 vCPU x 64GB - 300GB Secondary Storage)"
    },
    {
      value      = "b3c.32x128"
      prettyName = "b3c.32x128 (32 vCPU x 128GB - 100GB Secondary Storage)"
    }
  ]
}

variable "ocp_version_options" {
  type = list(object({
    value      = string
    prettyName = string
  }))
  default = [
    {
      value      = "4.8"
      prettyName = "OpenShift 4.8"
    },
    {
      value      = "4.9"
      prettyName = "OpenShift 4.9"
    },
    {
      value      = "4.10"
      prettyName = "OpenShift 4.10"
    },
  ]
}
