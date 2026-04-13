variable "target_group_name" {
  description = "Name of the alb target group"
  type        = string
}

variable "target_group_port" {
  description = "Port number where targets receive traffic. Can be overridden for individual targets during registration."
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for communication between the load balancer and targets."
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# variable "target_control_port" {
#   description = "The port on which the target communicates its capacity. This value can't be modified after target group creation."
#   type        = number
# }

variable "health_check_path" {
  description = "Use the default path of '/' to perform health checks on the root, or specify a custom path if preferred."
  type        = string
}

### AWS ALB
variable "alb_name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "scheme" {
  description = "Make it internal or internet facing"
  type        = bool
}

variable "load_balancer_type" {
  description = "Application, Network or Gateway"
  type        = string
}

variable "alb_security_grp" {
  description = "Security group for the alb"
  type        = list(string)
}

variable "subnets" {
  description = "Public subnets"
  type        = list(string)
}
