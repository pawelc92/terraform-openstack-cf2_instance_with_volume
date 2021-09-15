module "cf2_instance_with_volume" {
  source = "pawelc92/cf2_instance_with_volume/openstack"
  count  = 2

  name         = "my-instance-${count.index}"
  volume_size  = 5
  image_name   = "Ubuntu 20.04 LTS"
  flavor_name  = "eo1.xsmall"
  key_pair     = "my-ssh-key"
  network_name = "my-private-network"

  security_groups = [
    "default",
    "allow_ping_ssh_rdp"
  ]

  attach_eodata         = false
  associate_floating_ip = false
}