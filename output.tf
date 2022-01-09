output "appserver_public_ip" {
  value = aws_instance.appserver.public_ip
}

output "appserver_public_dns" {
  value = aws_instance.appserver.public_dns
}

