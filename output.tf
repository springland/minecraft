output "appserver_public_ip" {
  value = aws_instance.appserver.public_ip
}

output "appserver_public_dns" {
  value = aws_instance.appserver.public_dns
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.primary.zone_id
}