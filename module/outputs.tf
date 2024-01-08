output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "client_asg_name" {
  value = aws_autoscaling_group.client_asg.name
}

output "server_asg_name" {
  value = aws_autoscaling_group.server_asg.name
}
