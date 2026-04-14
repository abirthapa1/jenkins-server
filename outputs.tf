## VPC outputs
output "vpc_id" {
  description = "Outputs VPCs id"
  value       = module.network_vpc.vpc_id
}

output "vpc_public_subnets" {
  description = "Outputs the public subnets attached in VPC"
  value       = module.network_vpc.public_subnets
}

output "vpc_private_subnets" {
  description = "Outputs the private subnets attached in VPC"
  value       = module.network_vpc.private_subnets
}

###############
## SG OUTPUTS
###############
output "jenkins_master_sg_id" {
  description = "Outputs the jenkins master SG id"
  value       = module.jenkins_master_sg.sg_id
}

output "jenkins_agent_sg_id" {
  description = "Outputs the jenkins agents SG id"
  value       = module.jenkins_agent_sg.sg_id
}

output "alb_sg_id" {
  description = "Outputs the ALB SG id"
  value       = module.alb_sg.sg_id
}

output "bastion_sg_id" {
  description = "Outputs the bastion SG id"
  value       = module.bastion_sg.sg_id
}

output "jenkins_master_sg_arn" {
  description = "Outputs the jenkins master SG arn"
  value       = module.jenkins_master_sg.sg_arn
}

output "jenkins_agent_sg_arn" {
  description = "Outputs the jenkins agents SG arn"
  value       = module.jenkins_agent_sg.sg_arn
}

output "alb_sg_arn" {
  description = "Outputs the ALB SG arn"
  value       = module.alb_sg.sg_arn
}

output "bastion_sg_arn" {
  description = "Outputs the bastion SG arn"
  value       = module.bastion_sg.sg_arn
}

##############
## ALB OUTPUTS
##############
output "alb_id" {
  description = "Outputs the ALB id"
  value       = module.jenkins_ALB.alb_id

}
output "alb_arn" {
  value = module.jenkins_ALB.alb_arn
}

###############
## EC2 OUTPUTS
###############
# output "ec2_public_ip" {
#   # value = module.infra_ec2.public_ip
#   value = {
#     for name, mod in module.infra_ec2 :
#     name => mod.public_ip
#   }
# }

output "ec2_instance_id" {
  # value = module.infra_ec2.master_id
  value = {
    for name, mod in module.infra_ec2 :
    name => mod.ec2_instance_id
  }
}
