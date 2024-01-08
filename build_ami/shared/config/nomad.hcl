data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"

#tls {
#  http = true
#  rpc  = true
#  verify_https_client = false  # For development purposes, set to true in production
#  verify_server_hostname = false # For development purposes, set to true in production
#
#  ca_file = "/certs_key/nomad-agent-ca.pem"
#  cert_file = "/certs_key/global-server-nomad.pem"
#  key_file = "/certs_key/global-server-nomad-key.pem"
#}

acl {
  enabled = true
}

# Enable the server
server {
  enabled          = true
  encrypt          = "NOMAD_GOSSIP_ENCRYPT_KEY"
  bootstrap_expect = SERVER_COUNT
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
  enabled          = false
  address          = "http://active.vault.service.consul:8200"
}

