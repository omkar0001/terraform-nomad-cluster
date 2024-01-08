packer {
  required_version = ">= 0.12.0"
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "ami_id" {
  type    = string
  default = "ami-053b0d53c279acc90"
}

variable "ami_name_prefix" {
  type    = string
  default = "nomad-aws"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "consul_module_version" {
  type    = string
  default = "v0.11.0"
}

variable "consul_version" {
  type    = string
  default = "1.16.2"
}

variable "nomad_module_version" {
  type    = string
  default = "v0.10.0"
}

variable "nomad_version" {
  type    = string
  default = "1.6.2"
}

source "amazon-ebs" "ubuntu22-ami" {
  ami_description = "AMI that has Nomad and Consul installed based on Ubuntu Server 22.04 LTS (HVM),EBS General Purpose (SSD) Volume Type. "
  ami_name        = "${var.ami_name_prefix}-ubuntu22.04 LTS"
  instance_type   = "t2.micro"
  region          = "${var.aws_region}"
  source_ami      = "${var.ami_id}"
  ssh_username    = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ubuntu22-ami"]

  provisioner "shell" {
    inline = ["sudo apt-get install -y git"]
    only   = ["ubuntu22-ami"]
  }

  provisioner "shell" {
    inline = ["sudo apt-get install -y amazon-ecr-credential-helper"]
    only   = ["ubuntu22-ami"]
  }

  provisioner "shell" {
    inline = ["sudo mkdir /ops", "sudo chmod 777 /ops"]
  }

  provisioner "file" {
    destination = "/ops"
    source      = "${path.root}/shared"
  }

  provisioner "shell" {
    script           = "${path.root}/shared/scripts/setup.sh"
  }
}
