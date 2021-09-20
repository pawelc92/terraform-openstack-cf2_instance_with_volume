# CF2 Instance With Volume

Create an instance with bootable volume. Easily associate a floating IP address automatically selected from the external pool attached to your router.

## Example Usage

### Single Instance

Create single simple instance with bootable volume.

```hcl
module "cf2_instance_with_volume" {
  source  = "pawelc92/cf2_instance_with_volume/openstack"
  version = "1.1.2"

  name         = "my-instance"
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
```

### Multiple Instances

Create multiple instances by adding the count argument to the module. Add count.index to the name to keep the names unique.

```hcl
module "cf2_instance_with_volume" {
  source  = "pawelc92/cf2_instance_with_volume/openstack"
  version = "1.1.2"
  count   = 2

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
```