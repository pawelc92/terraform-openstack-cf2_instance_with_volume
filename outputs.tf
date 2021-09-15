output "instance_id" {
  value       = openstack_compute_instance_v2.instance.id
  description = "Instance ID."
}

output "fixed_ip_v4" {
  value       = openstack_networking_port_v2.private_network_port.fixed_ip
  description = "Fixed IP v4 attached to the instance."
  depends_on  = []
}

output "floating_ip" {
  value       = openstack_networking_floatingip_v2.floating_ip.*.address
  description = "Floating IP address associated to the instance."
}
