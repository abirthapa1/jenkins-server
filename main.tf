terraform {
  required_version = ">=1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

## VALUES FOR VPC MODULE
module "network_vpc" {
  source = "./terraform_repo/network/vpc"

  vpc_name = "jenkins-server"
  cidr     = "10.0.0.0/16"

  azs = ["us-east-2a"]

  public_subnets  = ["10.0.1.0/24"]
  private_subnets = ["10.0.11.0/24"]

  vpc_tags = {
    Environment = "dev"
    Project     = "jenkins"
  }

}

## VALUES FOR SECURITY GROUP
module "network_sg" {
  source = "./terraform_repo/network/security_group"

  sg_name = "jenkins-server-sg"
  vpc_id  = module.network_vpc.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["http-80-tcp", "ssh-tcp"]
  ingress_with_cidr_blocks = []

  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]

  sg_tags = {
    Environment = "dev"
    Name        = "jenkins-server-sg"
  }
}

module "master_sg" {
  source = "./terraform_repo/network/security_group"

  sg_name = "jenkins-master-sg"
  vpc_id  = module.network_vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = []
  ingress_with_cidr_blocks = [{
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "allow traffic from tcp/8080"
    cidr_blocks = "0.0.0.0/0"
  }]

  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]

  sg_tags = {
    Environment = "dev"
    Name        = "jenkins-master-sg"
  }
}

## VALUES FOR EC2 INSTANCE
module "infra_ec2" {
  source = "./terraform_repo/infra"

  for_each = toset(["master-node", "java-node", "python-node"])

  jenkins_main_name = "jenkins-${each.key}"

  #jenkins_main_name = "jenkins-master"
  instance_type     = "t3.micro"
  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

  ### Adding the master security group only to the master node
  ### so that we can access the jenkins website on port 8080
  security_group = concat([module.network_sg.sg_id], (each.key == "master-node" ? [module.master_sg.sg_id] : []))
  key_name       = aws_key_pair.aws-key.key_name
  subnet_id      = module.network_vpc.public_subnets[0]

  root_block_device = {
    size = var.volume_size
    type = "gp3"
  }

}

resource "aws_key_pair" "aws-key" {
  key_name   = "jenkins"
  public_key = file(var.ssh_public_key)
}
