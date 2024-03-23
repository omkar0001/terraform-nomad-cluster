variable "name" {
  default = "nomad"
}

variable "retry_join" {
  description = "Used by Consul to automatically form a cluster."
  type        = map(string)

  default = {
    provider  = "aws"
    tag_key   = "ConsulAutoJoin"
    tag_value = "auto-join"
  }
}

variable "vpc_id" {
    description = "The VPC ID to launch resources in"
    type = string
}

variable "private_subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type = list(string)
  default = []
}

variable "public_subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type = list(string)
  default = []
}

variable "nomad_server" {
  type = object({
    ami  = string
    instance_type = string
    public_key = string
    count = number
    policy_arns =  list(string)
    target_group_arns = list(string)
    ingresses = list(object({
      from_port = number
      to_port   = number
      protocol  = string
      cidr_blocks = list(string)
    }))

    egresses = list(object({
      from_port = number
      to_port   = number
      protocol  = string
      cidr_blocks = list(string)
    }))
  })
}

variable "nomad_client" {
  type = object({
    ami  = string
    instance_type = string
    public_key = string
    count = number
    policy_arns =  list(string)
    target_group_arns = list(string)
    ingresses = list(object({
      from_port = number
      to_port   = number
      protocol  = string
      cidr_blocks = list(string)
    }))

    egresses = list(object({
      from_port = number
      to_port   = number
      protocol  = string
      cidr_blocks = list(string)
    }))
  })
}

variable "bastion" {
  type = object({
    ami    = string
    instance_type = string
    public_key = string
    target_group_arns = list(string)
    ingresses = list(object({
      from_port = number
      to_port   = number
      protocol  = string
      cidr_blocks = list(string)
    }))

    egresses = list(object({
      from_port = number
      to_port   = number
      protocol  = string
      cidr_blocks = list(string)
    }))
    policy_arns =  list(string)
  })
}
