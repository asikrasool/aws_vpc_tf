provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

module "my_vpc" {
  source = "./modules/my_vpc"
}

resource "aws_key_pair" "my_ec2_keypair" {
  key_name   = "${var.stack}-keypairs"
  public_key = file(var.ssh_pub_key)
}
data "template_file" "user_data" {
  template = file("./files/userdata.tpl")
}

data "aws_ami" "linux_ami" {
    most_recent = true
    owners = ["${element(split(";", var.ami_id_filter[var.linux_distro]), 1)}"]
    filter {
        name   = "name"
        values = ["${element(split(";", var.ami_id_filter[var.linux_distro]), 0)}"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}

resource "aws_instance" "example" {
  ami                    = "${data.aws_ami.linux_ami.id}"
  key_name               = aws_key_pair.my_ec2_keypair.key_name
  user_data              = data.template_file.user_data.rendered
  instance_type          = "t2.micro"
  subnet_id              = module.my_vpc.subnet_id
  vpc_security_group_ids = module.my_vpc.ec2_sg # list
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
  provisioner "file" {
    content     = data.template_file.apache.rendered
    destination = "/tmp/apache.conf.j2"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /bin/bash /var/lib/cloud/instance/scripts/part-001 >> installer.log",
      "ansible-playbook /tmp/main.yml >> /tmp/play.log"
    ]

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
    db_user = var.db_user
    db_pass = random_password.db_root_pass.result
    db_name = var.db_name
  }
}


data "template_file" "playbook" {
  template = file("./playbook/main.yml")

  vars = {
    db_port   = aws_db_instance.mysql.port
    db_host   = aws_db_instance.mysql.address
    db_user   = var.db_user
    db_pass   = var.db_pass
    db_name   = var.db_name
    root_user = var.root_user
    root_pass = random_password.db_root_pass.result

  }
}

data "template_file" "apache" {
  template = file("./files/apache.conf.j2")
}
resource "random_password" "db_root_pass" {
  length = 16
  special = true
  min_special = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}


resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = var.root_user
  password               = random_password.db_root_pass.result
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = module.my_vpc.mysql_sg
  db_subnet_group_name   = module.my_vpc.subnet_group
  skip_final_snapshot    = true
}