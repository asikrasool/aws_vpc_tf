variable "availabilityZone" {
     default = "ap-south-1a"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "publicSubnetCIDRblock" {
    default = "10.0.0.0/24"
}
variable "privateSubnetCIDRblock" {
    default = "10.0.1.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}