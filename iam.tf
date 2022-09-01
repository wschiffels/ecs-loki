/* Promtail Lambda Permissions */
data "aws_iam_policy_document" "assume-role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "promtail" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AttachNetworkInterface"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*:*:*"
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-promtail-role"

  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}


resource "aws_iam_policy" "promtail" {
  name   = "promtail-permissions-policy"
  policy = data.aws_iam_policy_document.promtail.json
}

resource "aws_iam_role_policy_attachment" "attach_promtail_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.promtail.arn
}

resource "aws_iam_role_policy" "logs" {
  name   = "lambda-promtail-logs"
  role   = "loki-ecsTaskExecutionRole"
  policy = data.aws_iam_policy_document.loki.json
}

/* Loki ECS Permissions */
data "aws_iam_policy_document" "task_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "loki" {
  statement {
    sid    = ""
    effect = "Allow"
    resources = [
      module.loki_bucket.arn,
      "${module.loki_bucket.arn}/*"
    ]
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
  }
}

/* Task Excecution Role*/
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "loki-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "attach_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "attach_SecretsManagerReadWrite" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "attach_AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "attach_CloudWatchLogsFullAccess" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

/* Task Role */
resource "aws_iam_role" "task_role" {
  name               = "loki-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.task_role.json
}

resource "aws_iam_policy" "loki" {
  name   = "loki-s3-access"
  policy = data.aws_iam_policy_document.loki.json
}

resource "aws_iam_role_policy_attachment" "attach_s3Access" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.loki.arn
}
