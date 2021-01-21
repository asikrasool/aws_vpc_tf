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
variable "privateSubnet1CIDRblock" {
    default = "10.0.1.0/24"
}
variable "privateSubnet2CIDRblock" {
    default = "10.0.2.0/24"
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
variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22, 80]
}
variable stack {
  description = "this is name for tags"
  default     = "terraform"
}
