output "alb_tg_arn" {
  value = aws_lb_target_group.alb_tg.arn
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_endpoint" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_id" {
  value = aws_lb.alb.id
}

