/* IAM Permissions */
data "aws_iam_policy_document" "loki_update_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "loki_update_task_role" {
  name               = "loki-update-task-role"
  assume_role_policy = data.aws_iam_policy_document.loki_update_assume_role_policy.json
}

/* container definition loki-updater */
data "template_file" "loki_update_container_definition" {
  template = file("${path.module}/templates/loki_update_container_definition.tmpl")

  vars = {
    ssh_private_key = data.aws_secretsmanager_secret_version.ssh.arn
  }
}

resource "aws_ecs_task_definition" "loki_update" {
  container_definitions    = data.template_file.loki_update_container_definition.rendered
  family                   = "loki_update"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  volume {
    name = "efs"
    efs_volume_configuration {
      file_system_id = data.aws_efs_file_system.efs.id
    }
  }
}
