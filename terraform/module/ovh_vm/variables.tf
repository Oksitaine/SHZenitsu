
variable "service_public_cloud_id" {
    type = string
    description = "The ID for detect the good project in the public cloud account in OVH"
}

variable "ovh_token_oauth" {
    type = string
    description = "The token for the OVH API"
}

variable "virtual_machine" {
    type = object({
        name = string
        region = string
        billing_period = string

        # IMPORTANT !
        # FOR GET THE GOOD FLAVOR ID FOR YOUR MACHINE, NEED TO MAKE A REQUEST TO THE FOLOWING API 
        # https://api.ovh.com/1.0/cloud/project/{{SERVICE_NAME}}/flavor
        # NEED ACCESS_TOKEN IN THE HEADER REQUEST
        flavor_id = string

        # IMPORTANT !
        # FOR GET THE GOOD IMAGE ID FOR YOUR MACHINE, NEED TO MAKE A REQUEST TO THE FOLOWING API 
        # https://api.ovh.com/1.0/cloud/project/{{SERVICE_NAME}}/image
        # NEED ACCESS_TOKEN IN THE HEADER REQUEST
        image_id = string

        network_public = bool

        # OVH requires an SSH key value, but it won't be used since their API doesn't work properly
        # The actual SSH setup is handled through user_data script instead
        # This value can be ignored - it's just here to satisfy the API requirement
        ssh_key = string
        ssh_key_public = string

        # This user_data executes a script when the VM starts
        # WARNING: Do not modify ssh.bash as it fixes SSH connectivity issues with OVH's API
        # All custom scripts should be managed through Ansible instead
        user_data = string
    })
    description = "The virtual machine configuration"
}