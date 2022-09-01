resource "aws_ecs_cluster" "loki" {
  name               = "loki"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    iterator = strategy

    content {
      capacity_provider = strategy.value["capacity_provider"]
      weight            = lookup(strategy.value, "weight", null)
      base              = lookup(strategy.value, "base", null)
    }
  }


  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_service" "loki" {
  cluster                = aws_ecs_cluster.loki.id
  desired_count          = var.loki_desired_count
  enable_execute_command = true
  launch_type            = var.run_on_spot ? null : "FARGATE"
  name                   = "loki"
  task_definition        = aws_ecs_task_definition.loki.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.loki.arn
    container_name   = "loki"
    container_port   = 3100
  }

  network_configuration {
    subnets          = [data.aws_subnet.private-1a.id, data.aws_subnet.private-1b.id]
    assign_public_ip = false
    security_groups  = [aws_security_group.loki.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.loki.arn
  }

  dynamic "capacity_provider_strategy" {

    for_each = var.run_on_spot ? [var.run_on_spot] : []
    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    }
  }
}

data "template_file" "loki_container_definition" {
  template = file("${path.module}/templates/loki_container_definition.tmpl")

  vars = {
    loki_image        = var.loki_image
    loki_image_tag    = var.loki_image_tag
    alertmanager_user = "${aws_secretsmanager_secret_version.alertmanager_user.arn}:user::"
    alertmanager_pass = "${aws_secretsmanager_secret_version.alertmanager_user.arn}:password::"
  }
}

/* task definition loki */
resource "aws_ecs_task_definition" "loki" {
  container_definitions    = data.template_file.loki_container_definition.rendered
  family                   = "loki"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.loki_cpu_limit
  memory                   = var.loki_memory_limit

  volume {
    name = "efs"
    efs_volume_configuration {
      file_system_id = data.aws_efs_file_system.efs.id
      root_directory = "/loki"
    }
  }
}

resource "aws_service_discovery_private_dns_namespace" "loki" {
  name        = "loki.local"
  description = "Managed by Terraform"
  vpc         = data.aws_vpc.this.id
}

resource "aws_service_discovery_service" "loki" {
  name = "loki"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.loki.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

module "loki_bucket" {
  source = "../common/s3"

  bucket_name               = "${var.aws_environment}-loki-s3-bucket"
  bucket_versioning         = "Suspended"
  block_public_access       = true
  bucket_lifecycle          = var.loki_bucket_lifecycle
  lifecycle_expiration_days = var.loki_bucket_lifecycle_expiration_days
  aws_environment           = var.aws_environment
  tags = {
    Name = "${var.aws_environment}-loki-s3-bucket"
  }
}

/* Loadbalancer */
resource "aws_lb" "loki" {
  name = "loki-ecs-app-elb"

  security_groups = [
    "${aws_security_group.loki.id}"
  ]

  internal = true
  subnets = [
    data.aws_subnet.private-1a.id,
    data.aws_subnet.private-1b.id
  ]
}

resource "aws_lb_listener" "loki" {
  certificate_arn   = aws_acm_certificate.loki.arn
  load_balancer_arn = aws_lb.loki.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_lb_target_group.loki.arn
    type             = "forward"
  }
}

/* target group */
resource "aws_lb_target_group" "loki" {
  name        = "loki-ecs-app-tg"
  port        = 3100
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id

  health_check {
    protocol            = "HTTP"
    path                = "/ready"
    port                = "3100"
    healthy_threshold   = 5
    unhealthy_threshold = 10
    interval            = 15
    timeout             = 5
    matcher             = "200-399"
  }

  depends_on = [aws_lb.loki]
}

/*  security group */
resource "aws_security_group" "loki" {
  name        = "ecs-loki-fargate-sg"
  description = "security group for loki"
  vpc_id      = local.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port = 3100
    protocol  = "tcp"
    to_port   = 3100

    cidr_blocks = [
      data.aws_vpc.this.cidr_block,
      "10.0.0.0/16",
    ]
    security_groups = data.aws_security_groups.prometheus.ids
  }
  ingress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443

    cidr_blocks = [
      "10.0.200.0/22",
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* DNS */
resource "aws_route53_record" "loki_a" {

  zone_id = data.aws_route53_zone.selected.id
  name    = "loki.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.loki.dns_name
    zone_id                = aws_lb.loki.zone_id
    evaluate_target_health = true
  }
}
