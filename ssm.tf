resource "aws_secretsmanager_secret" "alertmanager_user" {
  name                    = "${var.aws_environment}-alertmanager-basic-auth"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "alertmanager_user" {
  secret_id = aws_secretsmanager_secret.alertmanager_user.id
  secret_string = jsonencode({
    user     = "Prometheus"
    password = "ilikerandompasswords"
  })
}
