data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

# Private network
data "openstack_networking_network_v2" "network" {
  name = var.network_name
}

# Security groups
locals {
  sg_count = length(var.security_groups)
}

data "openstack_networking_secgroup_v2" "security_groups" {
  count = local.sg_count
  name  = element(var.security_groups, count.index)
}

# External network
data "openstack_networking_port_v2" "router_port" {
  network_id   = data.openstack_networking_network_v2.network.id
  device_owner = "network:router_interface"
}

data "openstack_networking_router_v2" "router" {
  router_id = data.openstack_networking_port_v2.router_port.device_id
}

data "openstack_networking_network_v2" "external_network" {
  network_id = data.openstack_networking_router_v2.router.external_network_id
}

# Eodata
data "openstack_networking_network_v2" "eodata_network" {
  name = "eodata"
}