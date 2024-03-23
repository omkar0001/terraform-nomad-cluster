output "bastion_ip" {
  value = module.nomad_cluster.bastion_ip
}

output "client_asg_name" {
  value = module.nomad_cluster.client_asg_name
}

output "server_asg_name" {
  value = module.nomad_cluster.server_asg_name
}

output "alb_address" {
  value = aws_lb.alb.dns_name
}
