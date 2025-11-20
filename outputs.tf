## VPC outputs
output "vpc_id" {
  value = module.network_vpc.vpc_id
}

output "vpc_subnet" {
  value = module.network_vpc.public_subnets
}

## Security Group outputs
output "sg_id" {
  value = module.network_sg.sg_id
}

output "sg_arn" {
  value = module.network_sg.sg_arn
}

output "ec2_public_ip" {
  # value = module.infra_ec2.public_ip
  value = {
    for name, mod in module.infra_ec2 :
    name => mod.public_ip
  }
}

output "master_id" {
  # value = module.infra_ec2.master_id
  value = {
    for name, mod in module.infra_ec2 :
    name => mod.master_id
  }
}
