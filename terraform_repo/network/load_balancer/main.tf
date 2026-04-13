resource "aws_lb_target_group" "jenkins-target-grp" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  # target_control_port = var.target_control_port
  health_check {
    path = var.health_check_path

  }

}

resource "aws_lb" "jenkins-alb" {
  name               = var.alb_name
  internal           = var.scheme
  load_balancer_type = var.load_balancer_type
  security_groups    = var.alb_security_grp
  subnets            = var.subnets

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "Dev"
  }
}

# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.test.arn
#   target_id        = "i-098dee07efca3af75"
#   port             = 80
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.test.arn
#   port              = "80"
#   protocol          = "HTTP"
#   # ssl_policy        = "ELBSecurityPolicy-2016-08"
#   # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.test.arn
#   }
# }
