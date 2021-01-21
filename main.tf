provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

module "myVpc" {
  source = "./modules/myVpc"
}

resource "aws_key_pair" "my_ec2_keypair" {
  key_name   = "${var.stack}-keypairs"
  public_key = file(var.ssh_pub_key)
}
data "template_file" "user_data" {
  template = file("./files/userdata.sh")
}

resource "aws_instance" "example" {
  ami                    = "ami-0a4a70bd98c6d6441"
  key_name               = aws_key_pair.my_ec2_keypair.key_name
  user_data              = data.template_file.user_data.rendered
  instance_type          = "t2.micro"
  subnet_id              = module.myVpc.subnet_id
  vpc_security_group_ids = module.myVpc.ec2_sg # list
  tags = {
    Name = "terraform-example"
  }
  provisioner "file" {
    content     = data.template_file.phpconfig.rendered
    destination = "/tmp/wp-config.php"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }
  provisioner "file" {
    content     = data.template_file.playbook.rendered
    destination = "/tmp/main.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }
}

data "template_file" "phpconfig" {
  template = file("./files/conf.wp-config.php.j2")

  vars = {
    db_port = aws_db_instance.mysql.port
    db_host = aws_db_instance.mysql.address
    db_user = var.username
    db_pass = var.password
    db_name = var.dbname
  }
}


data "template_file" "playbook" {
  template = file("./playbook/main.yml")

  vars = {
    db_port = aws_db_instance.mysql.port
    db_host = aws_db_instance.mysql.address
  }
}


resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.dbname
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = module.myVpc.mysql_sg
  db_subnet_group_name   = module.myVpc.subnet_group
  skip_final_snapshot    = true
}