variable "region" {
  type = string
  default = "ap-south-1"
}
variable "db_user" {
  type = string
  description = "DB Username"
}
variable "db_pass" {
  type = string
  description = "DB Password"
}
variable "db_name" {
  type = string
  description = "DB Name"
}
variable "root_user" {
  type = string
  description = "Root Username"
}
variable "root_pass" {
  type = string
  description = "Root Password"
}


variable "ssh_pub_key" {
  default     = "~/.ssh/id_rsa.pub"
  description = "user pub key"
}

variable "ssh_priv_key" {
  default     = "/home/asik/asikaws.pem"
  description = "user priv key"
}
variable "stack" {
  type = string
  description = "this is name for tags"
  default     = "terraform"
}

variable "secret_description" {
  description = "This field is the description for the secret manager object"
  default     = "secret manager for mysql/aurora"
}