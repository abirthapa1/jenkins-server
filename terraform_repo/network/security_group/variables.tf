variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the vpc"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))

}

variable "egress_with_cidr_blocks" {
  description = "List of engress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))

}

variable "sg_tags" {
  description = "Tags for security Group"
  type        = map(string)
  default     = {}
}
