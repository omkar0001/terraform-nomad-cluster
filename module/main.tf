locals {
  machines = {
    nomad_server = merge(var.nomad_server, {
      user_data = templatefile("${path.module}/user-data-server.sh", {
        server_count = var.nomad_server.count
        region       = "us-east-1"
        retry_join = chomp(
          join(
          " ",
          formatlist("%s=%s", keys(var.retry_join), values(var.retry_join)),
          ))
        })
    })
    nomad_client = merge(var.nomad_client, {
      user_data = templatefile("${path.module}/user-data-client.sh", {
        region = "us-east-1"
        retry_join = chomp(
        join(
        " ",
        formatlist("%s=%s ", keys(var.retry_join), values(var.retry_join)),
        ))
      })
    })
    bastion = var.bastion
  }
}


locals {
  nomad_machines = {
    nomad_server = local.machines.nomad_server
    nomad_client = local.machines.nomad_client
  }
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
  number  = true
}

resource "aws_key_pair" "key" {
  for_each = local.machines
  key_name   = "nomad-${each.key}-${random_string.random.result}"
  public_key = each.value.public_key
}

resource "aws_launch_template" "launch_template" {
  for_each = local.machines
  name_prefix   = each.key
  image_id      = each.value.ami
  instance_type = each.value.instance_type
  vpc_security_group_ids    = [aws_security_group.security_group[each.key].id]
}

resource "aws_placement_group" "placement_group" {
  name     = "placement-group-${var.name}"
  strategy = "cluster"
}


resource "aws_autoscaling_group" "autoscaling_group" {
  for_each = local.nomad_machines
  name                      = "asg-${each.key}-${var.name}"
  max_size                  = each.value.count
  min_size                  = each.value.count
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = each.value.count
  force_delete              = true
  placement_group           = aws_placement_group.placement_group.id
  launch_template           = aws_launch_template.launch_template[each.key].id
  vpc_zone_identifier       = var.private_subnet_ids
  user_data = each.value.user_data

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  tag {
    key                 = var.retry_join.tag_key
    value               = var.retry_join.tag_value
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "nomad-${each.key}-${var.name}-${random_string.random.result}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}


resource "aws_instance" "bastion" {
  ami           = var.bastion.ami
  instance_type = var.bastion.instance_type
  key_name      = aws_key_pair.key["bastion"].key_name
  launch_template {
    id      = aws_launch_template.launch_template["bastion"].id
    version = "$Latest"
  }
  tags = {
    Name = "bastion-${var.name}-${random_string.random.result}"
  }
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids    = [aws_security_group.security_group["bastion"].id]
}
