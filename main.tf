#################################
# PROVIDER AND CONNECT
#################################

terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "1.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0.0"
    }
  }
}

provider "ovh" {
  endpoint           = var.ovh_keys.endpoint
  application_key    = var.ovh_keys.application_key
  application_secret = var.ovh_keys.application_secret
  consumer_key       = var.ovh_keys.consumer_key
}

#################################
# OVH VM INSTANCE
#################################

module "ovh_vm" {
  source = "./terraform/module/ovh_vm"
  service_public_cloud_id = var.service_public_cloud
  ovh_token_oauth = var.ovh_token_oauth
  virtual_machine = var.virtual_machine
}

locals {
  ansible_command = <<EOF
    ansible-playbook -i ubuntu@${module.ovh_vm.ipv4_address}, ${path.module}/ansible/main.yml \
    -e "docker_username=${var.docker_login.username}" \
    -e "docker_password=${var.docker_login.password}"
  EOF
}

resource "null_resource" "ansible_run" {
  depends_on = [
    module.ovh_vm
  ]

  triggers = {
    ansible_command = local.ansible_command
    ansible_content = file("${path.module}/ansible/main.yml")
  }

  provisioner "local-exec" {
    command = local.ansible_command
  }
}