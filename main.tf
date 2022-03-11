data "xenorchestra_pool" "pool" {
  name_label = var.pool_name
}

data "xenorchestra_template" "template" {
  name_label = var.template_name
  pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "net" {
  count = length(var.networks)
  name_label = var.networks[count.index]
  pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_sr" "disk" {
  count = length(var.disks)
  name_label = var.disks[count.index].storage
  pool_id = data.xenorchestra_pool.pool.id
}

locals {
  disks = [
    for key, value in var.disks : merge(value, {
      sr_id = data.xenorchestra_sr.disk[key].id
    })
  ]
}

resource "xenorchestra_vm" "vm" {

    lifecycle {
      create_before_destroy = true
      prevent_destroy = true
      ignore_changes = ["template", "disk", "network"]
    }

    memory_max = var.vm_memory_gb * 1024 * 1024 * 1024
    cpus  = var.vm_cpus
    name_label = var.vm_name
    name_description = var.vm_description
    auto_poweron = true
    template = data.xenorchestra_template.template.id
    wait_for_ip = var.wait_for_ip

    dynamic "network" {
      for_each = data.xenorchestra_network.net
      content {
        network_id = network.value.id
      }
    }

    dynamic "disk" {
      for_each = local.disks
      content {
        sr_id = disk.value.sr_id
        name_label = disk.value.label
        size = disk.value.size_gb * 1024 * 1024 * 1024
      }
    }

    cloud_config = var.vm_cloud_config
    cloud_network_config = var.vm_cloud_network_config

    tags = var.tags   
}

output "ip" {
  value = xenorchestra_vm.vm.network[0].ipv4_addresses[0]
}

output "ips" {
  value = xenorchestra_vm.vm.ipv4_addresses
}

output "networks" {
  value = xenorchestra_vm.vm.network
}
