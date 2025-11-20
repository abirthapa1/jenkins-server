variable "jenkins_main_name" {
  description = "Name of the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type to be used"
  type        = string
}

variable "ami_ssm_parameter" {
  description = "Name of the ami to be used"
  type        = string
}

variable "security_group" {
  description = "Defines the security group"
  type        = list(string)
}

variable "subnet_id" {
  description = "gives the subnet ID"
  type        = string
}

variable "root_block_device" {
  description = "defines the block device"
  type        = map(string)
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  # default     = "~/.ssh/id_ed25519.pub"
}
