resource "aws_secretsmanager_secret" "db_secret" {
  description         = "${var.secret_description}"
  name                = "${var.stack}-secret"
  #tags                = "${var.tags}"
  #policy =
}

resource "aws_secretsmanager_secret_version" "secret" {
  lifecycle {
    ignore_changes = [
      "secret_string"
    ]
  }
  secret_id     = "${aws_secretsmanager_secret.db_secret.id}"
  secret_string = <<EOF
{
  "username": "${var.db_user}",
  "engine": "mysql",
  "dbname": "${var.db_name}",
  "host": aws_db_instance.mysql.address,
  "password": "${var.db_pass}",
  "port": aws_db_instance.mysql.port,
}
EOF
}