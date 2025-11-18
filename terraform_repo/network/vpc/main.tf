## VPC WRAPPER

#It creates a default sg"
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  #   enable_nat_gateway = var.enable_nat_gateway
  #   single_nat_gateway = var.single_nat_gateway

  tags = var.vpc_tags
}
