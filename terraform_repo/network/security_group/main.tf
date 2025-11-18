## Security Group Wrapper

module "jenkins_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = var.sg_name
  vpc_id = var.vpc_id

  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_rules       = var.ingress_rules

  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

  egress_with_cidr_blocks = var.egress_with_cidr_blocks

  tags = var.sg_tags
}
