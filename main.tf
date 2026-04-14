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

#####################
#### VPC DEFINED ####
####################
## VALUES FOR VPC MODULE
module "network_vpc" {
  source = "./terraform_repo/network/vpc"

  vpc_name = "jenkins-server"
  cidr     = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  vpc_tags = {
    Environment = "dev"
    Project     = "jenkins"
  }

  enable_nat_gateway = true

}

#########################
#### SECURITY GROUP ####
#######################
## VALUES FOR SECURITY GROUP

### BASTION
module "bastion_sg" {
  source  = "./terraform_repo/network/security_group"
  sg_name = "bastion_sg"

  vpc_id = module.network_vpc.vpc_id

  ingress_with_cidr_blocks = [{
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "SSH for admins"
  }]

  egress_with_cidr_blocks = []

  egress_with_source_security_group_id = [{
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = module.jenkins_master_sg.sg_id
    cidr_blocks              = "0.0.0.0/0"
    description              = "SSH to Jenkins master only"
  }]

}

### JENKINS MASTER SG
module "jenkins_master_sg" {
  source  = "./terraform_repo/network/security_group"
  sg_name = "jenkins_master_sg"

  vpc_id = module.network_vpc.vpc_id

  ingress_with_cidr_blocks = []

  ingress_with_source_security_group_id = [{
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = module.bastion_sg.sg_id
    description              = "SSH from bastion only"
    }, {
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    source_security_group_id = module.alb_sg.sg_id
    description              = "Web GUI from ALB"
  }]

  egress_with_cidr_blocks = [{
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
    description = "outbound Http for plugins and git"
  }]



  egress_with_source_security_group_id = [{
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = module.jenkins_agent_sg.sg_id
  }]

}

### JENKIN AGENT SG
module "jenkins_agent_sg" {
  source  = "./terraform_repo/network/security_group"
  sg_name = "jenkins_agent_sg"

  vpc_id = module.network_vpc.vpc_id

  ingress_with_cidr_blocks = []
  ingress_with_source_security_group_id = [{
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = module.jenkins_master_sg.sg_id
    description              = "SSH from Jenkins master"
  }]
  egress_with_cidr_blocks = [{
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
    description = "Outbound http for builds git, artifacts"
  }]
}


### ALB SG
module "alb_sg" {
  source  = "./terraform_repo/network/security_group"
  sg_name = "alb_sg"

  vpc_id = module.network_vpc.vpc_id

  ingress_with_cidr_blocks = [{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "Accessing the Alb"
  }]

  egress_with_cidr_blocks = []

  egress_with_source_security_group_id = [{
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    source_security_group_id = module.jenkins_master_sg.sg_id
  }]

}



#####################
#### ALB DEFINED ####
#####################

### ALB
module "jenkins_ALB" {
  source                = "./terraform_repo/network/load_balancer"
  target_group_name     = "jenkins"
  target_group_port     = 8080
  target_group_protocol = "HTTP"
  vpc_id                = module.network_vpc.vpc_id

  # target_control_port = 8080
  health_check_path = "/login"

  alb_name           = "jenkins-alb"
  scheme             = false
  load_balancer_type = "application"
  alb_security_grp   = [module.alb_sg.sg_id]
  subnets            = module.network_vpc.public_subnets

}

############################
#### INSTANCES DEFINED ####
##########################

## VALUES FOR BASTION
module "bastion_ec2" {
  source        = "./terraform_repo/infra"
  instance_name = "bastion-host"

  instance_type     = "t3.micro"
  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  security_group    = [module.bastion_sg.sg_id]
  subnet_id         = module.network_vpc.public_subnets[0]
  key_name          = aws_key_pair.aws-key.key_name

  associate_public_ip_address = true
  root_block_device = {
    size = var.volume_size
    type = "gp3"
  }

}

## VLAUES FOR MASTER AND AGENTS
module "infra_ec2" {
  source = "./terraform_repo/infra"

  for_each = toset(["master-node", "java-node", "python-node"])

  instance_name = "jenkins-${each.key}"

  #jenkins_main_name = "jenkins-master"
  instance_type     = "t3.micro"
  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

  ### Adding the master security group only to the master node
  ### so that we can access the jenkins website on port 8080
  security_group = concat([module.jenkins_agent_sg.sg_id], (each.key == "master-node" ? [module.jenkins_master_sg.sg_id] : []))
  key_name       = aws_key_pair.aws-key.key_name
  subnet_id      = module.network_vpc.private_subnets[0]

  associate_public_ip_address = false



  root_block_device = {
    size = var.volume_size
    type = "gp3"
  }

}

resource "aws_key_pair" "aws-key" {
  key_name   = "jenkins"
  public_key = file(var.ssh_public_key)
}
