variable "pool_name" {
    type = string
}

variable "template_name" {
    type = string
}
variable "networks" {
    type = list
    default = []
}

variable "disks" {
    type = list(object({
        size_gb = number
        storage = string
        label = string
    }))
    default = []
}

variable "vm_name" {
  type = string
}

variable "vm_description" {
  type = string
  default = ""
}

variable "vm_cpus" {
    type = number
}
variable "vm_memory_gb" {
    type = number
}

variable "vm_cloud_config" {
  type = string
  default = ""
}

variable "vm_cloud_network_config" {
  type = string
  default = ""
}

variable "tags" {
    type = list(string)
    default = []
}

variable "wait_for_ip" {
    type = bool
    default = true
}

variable "prevent_destroy" {
  type = bool
  default = true
}

variable "ignore_change" {
  default = "all"
}

