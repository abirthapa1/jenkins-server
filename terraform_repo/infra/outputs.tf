output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "master_id" {
  value = module.ec2_instance.id
}
