variable "region" {
  default = "ap-south-1"
}
variable "username" {
  description = "DB username"
}

variable "password" {
  description = "DB password"
}

variable "dbname" {
  description = "db name"
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
  description = "this is name for tags"
  default     = "terraform"
}