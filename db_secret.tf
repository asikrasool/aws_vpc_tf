resource "aws_secretsmanager_secret" "db_secret" {
  description = var.secret_description
  name        = "${var.stack}-secret"
  recovery_window_in_days = "0"
}

resource "aws_secretsmanager_secret_version" "secret" {
  lifecycle {
    ignore_changes = [
      "secret_string"
    ]
  }
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = <<EOF
{
  "username": "${var.db_user}",
  "engine": "mysql",
  "dbname": "${var.db_name}",
  "host": aws_db_instance.mysql.address,
  "password": random_password.db_root_pass.result
  "port": aws_db_instance.mysql.port,
}
EOF
}