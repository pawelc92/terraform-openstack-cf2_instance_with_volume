# Port
# resource "openstack_networking_port_v2" "private_network_port" {
#   name               = "${var.name}-port"
#   network_id         = data.openstack_networking_network_v2.network.id
#   admin_state_up     = true
#   security_group_ids = data.openstack_networking_secgroup_v2.security_groups.*.id
# }

# resource "openstack_networking_floatingip_associate_v2" "floating_ip_association" {
#   count       = var.associate_floating_ip ? 1 : 0
#   floating_ip = openstack_networking_floatingip_v2.floating_ip[count.index].address
#   port_id     = openstack_networking_port_v2.private_network_port.id
# }

# resource "openstack_blockstorage_volume_v2" "bootable_volume" {
#   image_id = var.image_name
#   size     = var.volume_size
# }

# Instance
data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

data "openstack_images_image_v2" "image" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_compute_instance_v2" "basic_instance" {
  count = var.volume_size > 0 ? 0 : 1
  name      = var.name
  key_pair  = var.key_pair
  flavor_id = data.openstack_compute_flavor_v2.flavor.id
  image_id  = openstack_images_image_v2.image.id

  network {
    # port = openstack_networking_port_v2.private_network_port.id
    name = var.network_name
  }

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

resource "openstack_compute_instance_v2" "instance_with_volume" {
  count = var.volume_size > 0 ? 1 : 0
  name      = var.name
  key_pair  = var.key_pair
  flavor_id = data.openstack_compute_flavor_v2.flavor.id

  block_device {
    uuid                  = openstack_images_image_v2.image.id
    source_type           = "image"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = var.network_name
  }

  lifecycle {
    ignore_changes = [
      block_device[0].uuid
    ]
  }
}

# Floating IP
resource "openstack_networking_floatingip_v2" "floating_ip" {
  count = var.associate_floating_ip ? 1 : 0
  pool  = data.openstack_networking_network_v2.external_network.name
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip_association" {
  count       = var.associate_floating_ip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.floating_ip[count.index].address
  instance_id = var.volume_size > 0 ? openstack_compute_instance_v2.instance_with_volume.id : openstack_compute_instance_v2.basic_instance.id
}

# Eodata
# resource "openstack_compute_interface_attach_v2" "eodata_attach" {
#   count       = var.attach_eodata ? 1 : 0
#   instance_id = openstack_compute_instance_v2.instance.id
#   network_id  = data.openstack_networking_network_v2.eodata_network.id
# }