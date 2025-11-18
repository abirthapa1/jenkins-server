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
