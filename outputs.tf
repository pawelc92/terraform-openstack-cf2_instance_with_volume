output "floating_ip" {
  value       = openstack_networking_floatingip_v2.floating_ip.*.address
  description = "Floating IP associated to the instance."
}
