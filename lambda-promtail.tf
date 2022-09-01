resource "aws_lambda_function" "lambda_promtail" {
  image_uri     = var.lambda_promtail_image
  function_name = "promtail-lambda-function"
  role          = aws_iam_role.iam_for_lambda.arn

  timeout      = 60
  memory_size  = 128
  package_type = "Image"


  environment {
    variables = {
      WRITE_ADDRESS = var.loki_write_address
      KEEP_STREAM   = var.loki_keep_stream
    }
  }

  vpc_config {
    subnet_ids         = [data.aws_subnet.private-1a.id, data.aws_subnet.private-1b.id]
    security_group_ids = [aws_security_group.loki.id]
  }

}

resource "aws_lambda_function_event_invoke_config" "lambda_promtail_invoke_config" {
  function_name          = aws_lambda_function.lambda_promtail.function_name
  maximum_retry_attempts = 2
}

resource "aws_lambda_permission" "lambda_promtail_allow_cloudwatch" {
  statement_id  = "lambda-promtail-allow-cloudwatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_promtail.function_name
  principal     = "logs.eu-central-1.amazonaws.com"
}

locals {
  lambda_log_group_filters = compact([
    for log in data.aws_cloudwatch_log_groups.lambda_log_groups.log_group_names : log if !contains(var.lambda_log_group_filter_exceptions, log)
  ])
  ecs_log_group_filters = compact([
    for log in data.aws_cloudwatch_log_groups.ecs_log_groups.log_group_names : log if !contains(var.ecs_log_group_filter_exceptions, log)
  ])
}

resource "aws_cloudwatch_log_subscription_filter" "lambdafunction_logfilter_aws_log_groups" {
  for_each        = toset(local.lambda_log_group_filters)
  name            = "lambdafunction_logfilter${each.key}"
  log_group_name  = each.key
  destination_arn = aws_lambda_function.lambda_promtail.arn
  # required but can be empty string
  filter_pattern = ""
  depends_on     = [aws_iam_role_policy.logs]

  lifecycle {
    ignore_changes = all
  }
}

# log subscription for /ecs-logs
resource "aws_cloudwatch_log_subscription_filter" "lambdafunction_logfilter_ecs_log_groups" {
  for_each        = toset(toset(local.ecs_log_group_filters))
  name            = "lambdafunction_logfilter${each.key}"
  log_group_name  = each.key
  destination_arn = aws_lambda_function.lambda_promtail.arn
  # required but can be empty string
  filter_pattern = ""
  depends_on     = [aws_iam_role_policy.logs]

  lifecycle {
    ignore_changes = all
  }

}
