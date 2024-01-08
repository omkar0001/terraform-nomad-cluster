data "local_file" "public_key" {
  filename = "./nomad_test.pub"
}

module "nomad_cluster" {
  source              = "../module"
  name                = "test-nomad-cluster"
  private_subnet_ids  = ["subnet-074082bac8e6de447", "subnet-09ef5d11c68ccdd7f"]
  public_subnet_ids   = ["subnet-076e407f852c899d3", "subnet-09efbeb3268a96406"]
  vpc_id              = "vpc-01a58c15a57aed303"

  nomad_client = {
      ami  = "ami-0165e8599a72f29e8"
      instance_type = "t2.micro"
      public_key = data.local_file.public_key.content
      count = 1
  }

  nomad_server = {
     ami  = "ami-0165e8599a72f29e8"
     instance_type = "t2.micro"
     public_key = data.local_file.public_key.content
     count = 1
  }

  bastion = {
      ami  = "ami-0165e8599a72f29e8"
      instance_type = "t2.micro"
      public_key = data.local_file.public_key.content
  }
}
