variable "availability_zone" {
     default = "ap-south-1a"
}
variable "instance_tenancy" {
    default = "default"
}
variable "dns_support" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpc_cidrblock" {
    type = string
    default = "10.0.0.0/16"
}
variable "public_subnet_cidrblock" {
    type = string
    default = "10.0.0.0/24"
}
variable "private_subnet1_cidrblock" {
    type = string
    default = "10.0.1.0/24"
}
variable "private_subnet2_cidrblock" {
    type = string
    default = "10.0.2.0/24"
}
variable "destination_cidrblock" {
    type = string
    default = "0.0.0.0/0"
}
variable "ingress_cidrblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egress_cidrblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "map_publicip" {
    type = bool
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

