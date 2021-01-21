provider "aws" {
  version = "~> 2.0"
  access_key = var.access_key 
  secret_key = var.secret_key 
  region     = var.region
}

module "myVpc" {
    source = "./modules/myVpc"
}

resource "aws_instance" "example" {
  ami           = "ami-0a4a70bd98c6d6441"
  instance_type = "t2.micro"
  subnet_id              = module.myVpc.subnet_id
  vpc_security_group_ids = module.myVpc.sg_ids # list
  tags = {
    Name = "terraform-example"
  }
}