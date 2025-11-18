output "sg_id" {
  value = module.jenkins_server_sg.security_group_id
}

output "sg_arn" {
  value = module.jenkins_server_sg.security_group_arn
}
