variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "db_user" {
  type        = string
  description = "DB Username"
}
variable "db_pass" {
  type        = string
  description = "DB Password"
}
variable "db_name" {
  type        = string
  description = "DB Name"
}
variable "root_user" {
  type        = string
  description = "Root Username"
}
variable "root_pass" {
  type        = string
  description = "Root Password"
}

variable "ssh_pub_key" {
  default     = "~/.ssh/id_rsa.pub"
  description = "User SSH Public Key"
}

variable "ssh_priv_key" {
  default     = "/home/asik/asikaws.pem"
  description = "User SSH Private Key"
}

variable "linux_distro" {
    type = "string"
    default = "ubuntu20"
    description = "Linux Distro name for AMI"
}

variable "ami_id_filter" {
    type = "map"
    default = {
        "ubuntu20" = "ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*;099720109477"
        "ubuntu19" = "ubuntu/images/hvm-ssd/ubuntu-*-19.04-amd64-server-*;099720109477"
        "ubuntu18" = "ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*;099720109477"
        "ubuntu16" = "ubuntu/images/hvm-ssd/ubuntu-*-16.04-amd64-server-*;099720109477"
        "ubuntu14" = "ubuntu/images/hvm-ssd/ubuntu-*-14.04-amd64-server-*;099720109477"
        "debian9"  = "debian-stretch-*;379101102735"
        "debian8"  = "debian-jessie-*;379101102735"
        "centos7"  = "CentOS Linux 7*;679593333241"
        "centos6"  = "CentOS Linux 6*;679593333241"
        "rhel8"    = "RHEL-8.?*;309956199498"
        "rhel7"    = "RHEL-7.?*GA*;309956199498"
        "rhel6"    = "RHEL-6.?*GA*;309956199498"
    }
}

variable "stack" {
  type        = string
  description = "this is name for tags"
  default     = "terraform"
}

variable "secret_description" {
  description = "This field is the description for the secret manager object"
  default     = "secret manager for mysql/aurora"
}