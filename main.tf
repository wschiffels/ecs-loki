data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.aws_environment]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    region = local.aws_region
    bucket = "terraform-tfstate-${local.aws_account_id}-${local.aws_region}"
    key    = "vpc/terraform.tfstate"
  }
}

data "aws_route53_zone" "selected" {
  name = var.domain_name
}

data "aws_security_groups" "prometheus" {
  filter {
    name   = "group-name"
    values = ["ecs-prometheus-fargate-sg"]
  }
}

data "aws_cloudwatch_log_groups" "lambda_log_groups" {
  log_group_name_prefix = "/aws/lambda"
}

data "aws_cloudwatch_log_groups" "ecs_log_groups" {
  log_group_name_prefix = "/aws/ecs"
}

data "aws_subnet" "private-1a" {
  tags = {
    Name = "*-private-eu-central-1a"
  }
}

data "aws_subnet" "private-1b" {
  tags = {
    Name = "*-private-eu-central-1b"
  }
}

data "aws_efs_file_system" "efs" {
  tags = {
    "terraform:module" = "prometheus"
  }
}

data "aws_secretsmanager_secret_version" "ssh" {
  secret_id = "${local.product}-prometheus-initContainer-ssh-key"
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.name
  product        = element(slice(split("-", var.domain_name), 0, 1), 0)
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
}
