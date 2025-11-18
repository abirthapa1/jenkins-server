module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = var.jenkins_main_name
  instance_type = var.instance_type

  ami_ssm_parameter = var.ami_ssm_parameter

  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_group
  key_name                    = aws_key_pair.aws-key.key_name
  root_block_device           = var.root_block_device

  subnet_id = var.subnet_id
}

resource "aws_key_pair" "aws-key" {
  key_name   = "jenkins"
  public_key = file(var.ssh_public_key)
}
