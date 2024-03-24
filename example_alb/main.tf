# main.tf

// Replace the values in the locals with the values you want to use.
locals {
  public_key_path = "./nomad_test.pub"
  public_subnets  = ["subnet-123", "subnet-456"]
  private_subnets = ["subnet-abc", "subnet-def"]
  vpc_id          = "vpc-123"
  ami             = "ami-123"
  instance_type   = "t2.micro"
  port            = 8081
}

data "local_file" "public_key" {
  filename = local.public_key_path
}

module "nomad_cluster" {
  source              = "../module"
  name                = "test-nomad-cluster"
  private_subnet_ids  = local.private_subnets
  public_subnet_ids   = local.public_subnets
  vpc_id              = local.vpc_id

  nomad_client = {
      ami  = local.ami
      instance_type = local.instance_type
      public_key = data.local_file.public_key.content
      count = 1
      nomad_ingresses = [{
        from_port = local.port
        to_port = local.port
        protocol = "tcp"
        cidr_blocks = [
          "0.0.0.0/0"]
      }]

  }

  nomad_server = {
     ami  = local.ami
     instance_type = local.instance_type
     public_key = data.local_file.public_key.content
     count = 1
  }

  bastion = {
      ami  = local.ami
      instance_type = local.instance_type
      public_key = data.local_file.public_key.content
  }
}
