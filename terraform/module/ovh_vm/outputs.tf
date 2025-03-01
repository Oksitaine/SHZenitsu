# Outputs the IPV4 and the IPV6 of the VM
output "ipv4_address" {
    description = "The IPv4 address of the VM"
    value = [for item in ovh_cloud_project_instance.vm.addresses : item if item.version == 4][0].ip
}

output "ipv6_address" {
    description = "The IPv6 address of the VM"
    value = [for item in ovh_cloud_project_instance.vm.addresses : item if item.version == 6][0].ip
}