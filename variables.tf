variable "number_of_instances" {
  type        = number
  default     = 1
  description = "Number of instances to be created. If the number is greater than 1, the number will be appended to the instance name."
}

variable "instance_name" {
  type        = string
  default     = "cf2_instance_with_volume"
  description = "Instance name. If the number of instances is greater than 1, the number will be appended to the name of each instance."
}

variable "flavor_name" {
  type        = string
  default     = "eo1.xsmall"
  description = "Flavor name."
}

variable "key_pair_name" {
  type        = string
  description = "The name of an existing ssh key in the project."
}

variable "image_name" {
  type        = string
  default     = "Ubuntu 20.04 LTS"
  description = "Image name."
}

variable "network_name" {
  type        = string
  description = "The name of the network to be attached to the instance."
}

variable "attach_eodata" {
  type        = bool
  default     = false
  description = "True if the eodata network is to be attached to the instance. Attention! You must manually mount the eodata resource in the operating system."
}

variable "associate_floating_ip" {
  type        = bool
  default     = false
  description = "True if floating IP is to be associated to the instance. Floating IP will be automatically assigned from the external pool in which the router of the network attached to the instance is located."
}

variable "volume_size_in_gb" {
  type        = number
  default     = 5
  description = "Volume size expressed in gigabytes."
}

variable "security_groups" {
  type        = list(any)
  default     = ["default"]
  description = "List of groups attached to the instance network port. This does not apply to the eodata network port."
}