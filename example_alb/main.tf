# main.tf

data "local_file" "public_key" {
  filename = "./nomad_test.pub"
}

locals {
  public_subnets  = ["subnet-123", "subnet-456"]
  private_subnets = ["subnet-abc", "subnet-def"]
  vpc_id          = "vpc-123"
  ami             = "ami-123"
  port            = 81
}


module "nomad_cluster" {
  source              = "../module"
  name                = "test-nomad-cluster"
  private_subnet_ids  = local.private_subnets
  public_subnet_ids   = local.public_subnets
  vpc_id              = local.vpc_id

  nomad_client = {
      ami  = local.ami
      instance_type = "t2.micro"
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
     instance_type = "t2.micro"
     public_key = data.local_file.public_key.content
     count = 1
  }

  bastion = {
      ami  = local.ami
      instance_type = "t2.micro"
      public_key = data.local_file.public_key.content
  }
}
