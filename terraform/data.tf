#
##      --- Récupération des secrets ---
#

data "aws_secretsmanager_secret" "env" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "env_version" {
  secret_id = data.aws_secretsmanager_secret.env.id
}