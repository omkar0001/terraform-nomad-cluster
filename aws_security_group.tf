locals {
  all_traffic = {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ssh = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  consul = {
    from_port       = 8500
    to_port         = 8500
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

    nomad = {
      from_port = 4646
      to_port = 4646
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    }

  egresses = {
    bastion = concat(var.bastion.egresses, [local.all_traffic])
    nomad_server = concat(var.nomad_server.egresses, [local.all_traffic])
    nomad_client = concat(var.nomad_client.egresses, [local.all_traffic])
  }

  ingresses = {
    bastion = concat(var.bastion.ingresses, [local.ssh])
    nomad_server = concat(var.nomad_server.ingresses, [
      local.ssh,
      local.consul,
      local.nomad
    ])
    nomad_client = concat(var.nomad_client.ingresses, [
      local.ssh,
      local.consul,
      local.nomad
    ])
  }
  ingresses_egresses = {
    bastion = {
      ingress = local.ingresses.bastion
      egress = local.egresses.bastion
    }
    nomad_server = {
      ingress = local.ingresses.nomad_server
      egress = local.egresses.nomad_server
    }
    nomad_client = {
      ingress = local.ingresses.nomad_client
      egress = local.egresses.nomad_client
    }
  }
}

resource "aws_security_group" "security_group" {
  name   = "nomad_security_group_${var.name}"
  vpc_id = var.vpc_id
  for_each = local.ingresses_egresses

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
