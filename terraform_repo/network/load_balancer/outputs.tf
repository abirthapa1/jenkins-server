output "alb_id" {
  value = aws_lb.jenkins_alb.dns_name
}

output "alb_arn" {
  value = aws_lb.jenkins_alb.arn
}
