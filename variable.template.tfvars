#################################
# GLOBAL VARIABLES
#################################

variable "ovh_keys" {
    type = map(string)
    description = "Oauth token for ovh api"
    default = {
        # TODO : This one is for connect to your ovh account with terraform
        # Follow this link for get the api key : https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*
        endpoint = "ovh-eu"
        application_key = "your_ovh_application_key"
        application_secret = "your_ovh_application_secret"
        consumer_key = "your_ovh_consumer_key"
    }
}

variable "service_public_cloud" {
    type = string
    description = "The ID for detect the good project in the public cloud account in OVH"
    default = "your_public_cloud_project_id"
}

#################################
# OVH VM INSTANCE VARIABLES
#################################

variable "ovh_token_oauth" {
    type = string
    description = "The token for the OVH API"
    default = "your_ovh_token_oauth"
}

variable "docker_login" {
    type = object({
        username = string
        password = string
    })
    description = "The login for the docker"
    default = {
        username = "your_docker_username"
        password = "your_docker_password"
    }
}

variable "virtual_machine" {
    type = object({
        name = string
        region = string
        billing_period = string
        flavor_id = string
        image_id = string
        network_public = bool
        ssh_key = string
        ssh_key_public = string
        user_data = string
    })
    description = "The virtual machine configuration"
    default = {
        name = "your_vm_name"
        region = "your_vm_region"
        billing_period = "your_vm_billing_period"
        flavor_id = "your_vm_flavor_id"
        image_id = "your_vm_image_id"
        network_public = true
        ssh_key = "your_vm_ssh_key"
        ssh_key_public = "your_vm_ssh_key_public"
        user_data = "your_vm_user_data"
    }
}