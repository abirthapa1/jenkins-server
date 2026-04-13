output "alb_id" {
  value = aws_lb.jenkins-alb.dns_name
}

output "alb_arn" {
  value = aws_lb.jenkins-alb.arn
}
