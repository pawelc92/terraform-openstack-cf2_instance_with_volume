terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = ">= 1.32.0"
    }
  }
}

# Port
resource "openstack_networking_port_v2" "private_network_port" {
  name               = "${var.name}-port"
  network_id         = data.openstack_networking_network_v2.network.id
  admin_state_up     = true
  security_group_ids = data.openstack_networking_secgroup_v2.security_groups.*.id
}

# Floating IP
resource "openstack_networking_floatingip_v2" "floating_ip" {
  count = var.associate_floating_ip ? 1 : 0
  pool  = data.openstack_networking_network_v2.external_network.name
}

resource "openstack_networking_floatingip_associate_v2" "floating_ip_association" {
  count       = var.associate_floating_ip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.floating_ip[count.index].address
  port_id     = openstack_networking_port_v2.private_network_port.id
}

# Volume
resource "openstack_blockstorage_volume_v2" "bootable_volume" {
  image_id = var.image_name
  size     = var.volume_size
}

# Instance
resource "openstack_compute_instance_v2" "instance" {
  name      = var.name
  key_pair  = var.key_pair
  flavor_id = data.openstack_compute_flavor_v2.flavor.id

  block_device {
    uuid                  = openstack_blockstorage_volume_v2.bootable_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.private_network_port.id
  }
}

# Eodata
resource "openstack_compute_interface_attach_v2" "eodata_attach" {
  count       = var.attach_eodata ? 1 : 0
  instance_id = openstack_compute_instance_v2.instance.id
  network_id  = data.openstack_networking_network_v2.eodata_network.id
}