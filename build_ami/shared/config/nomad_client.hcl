# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"

#tls {
#  http = true
#  rpc  = true
#  verify_https_client = false  # For development purposes, set to true in production
#  verify_server_hostname = false # For development purposes, set to true in production
#
#  ca_file = "/certs_key/nomad-agent-ca.pem"
#  cert_file = "/certs_key/us-east-1-client-nomad.pem"
#  key_file = "/certs_key/private/us-east-1-client-nomad-key.pem"
#}

acl {
  enabled = true
}

# Enable the client
client {
  enabled = true
  options {
    "driver.raw_exec.enable"    = "1"
    "docker.privileged.enabled" = "true"
  }
}

plugin "docker" {
  config {
    auth {
      helper = "ecr-login"
    }
  }
}

consul {
  address = "127.0.0.1:8500"
}

vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
}
