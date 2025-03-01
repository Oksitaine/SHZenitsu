#################################
# PROVIDER AND CONNECT
#################################

terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "1.6.0"
    }
  }
}

##########################################################
# this null_resource with be patched in the new version of the terraform provider of ovh
##########################################################

# Create fake ssh key for the vm instance only for the API OVH REQUIREMENT
resource "null_resource" "create_ssh_key" {
  # Le trigger ci-dessous force la ré-exécution de la commande si l'une des variables change.
  triggers = {
    project_id           = var.service_public_cloud_id
    ssh_key_name         = var.virtual_machine.ssh_key
    ssh_key_public       = var.virtual_machine.ssh_key_public
  }

  provisioner "local-exec" {
    command = <<EOT
            curl -X POST "https://eu.api.ovh.com/v1/cloud/project/${var.service_public_cloud_id}/sshkey" \
            -H "accept: application/json" \
            -H "authorization: Bearer ${var.ovh_token_oauth}" \
            -H "content-type: application/json" \
            -d '{"name":"${var.virtual_machine.ssh_key}","publicKey":"${var.virtual_machine.ssh_key_public}"}'
            EOT
  }
}

##########################################################
# this null_resource with be patched in the new version of the terraform provider of ovh
##########################################################




resource "ovh_cloud_project_instance" "vm" {
    depends_on = [
      null_resource.create_ssh_key
    ]


    service_name = var.service_public_cloud_id
    name = var.virtual_machine.name
    region = var.virtual_machine.region
    billing_period = var.virtual_machine.billing_period
    flavor {
        flavor_id = var.virtual_machine.flavor_id
    }
    boot_from {
        image_id = var.virtual_machine.image_id
    }
    network {
        public = var.virtual_machine.network_public
    }
    ssh_key {
        name = var.virtual_machine.ssh_key
    }
    user_data = file(var.virtual_machine.user_data)
}