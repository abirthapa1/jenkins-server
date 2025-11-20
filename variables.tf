variable "region" {
  description = "region defined"
  type        = string
  default     = "us-east-2"
}

variable "volume_size" {
  description = "Size of the EBS root volume"
  type        = number
  default     = 50
}

variable "ssh_public_key" {
  description = "pub key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
