# Required variables
variable "flavor_name" {
  type        = string
  description = "Flavor name."
}

variable "key_pair" {
  type        = string
  description = "The name of a key pair to put on the server. The key pair must already be created and associated with the tenant's account. Changing this creates a new instance."
}

variable "image_name" {
  type        = string
  description = "Image name. Changing this creates a new instance and volume."
}

variable "network_name" {
  type        = string
  description = "A name of a private network to be attached to the instance."
}

variable "volume_size" {
  type        = number
  description = "The size of the volume to create (in gigabytes). Changing this creates a new instance and volume."
}

# Optional variables
variable "name" {
  type        = string
  default     = "cf2_instance_with_volume"
  description = "A unique name for the instance."
}

variable "security_groups" {
  type        = list(any)
  default     = ["default"]
  description = "An array of one or more security groups to add to the instance. Adds security groups only to the private network port indicated in network_name. If empty, the 'default' security group is added by default."
}

variable "associate_floating_ip" {
  type        = bool
  default     = false
  description = "Set 'true' to associate floating IP to the instance. Automatically assigns floating IP from the external pool in which the router of the private network attached to the instance is located."
}

variable "attach_eodata" {
  type        = bool
  default     = false
  description = "Set 'true' to attach the eodata network to the instance. Attention! You must manually mount the eodata resource in the operating system."
}