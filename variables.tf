variable "aws_environment" {}

variable "domain_name" {}

variable "loki_write_address" {
  type        = string
  description = "This is the Loki Write API compatible endpoint that you want to write logs to, either promtail or Loki. http://loki.<domain>.app/loki/api/v1/push"
}

variable "lambda_promtail_image" {
  type        = string
  description = "The ECR image URI to pull and use for lambda-promtail."
  default     = "docker-promtail:latest"
}

variable "loki_keep_stream" {
  type        = string
  description = "Determines whether to keep the CloudWatch Log Stream value as a Loki label when writing logs from lambda-promtail."
  default     = "true"
}

variable "loki_image" {
  type        = string
  description = "the image to use for loki"
}

variable "loki_image_tag" {
  type        = string
  description = "the image tag to use for loki"
}

variable "loki_cpu_limit" {
  type        = number
  description = "the cpu limit for loki"
}

variable "loki_memory_limit" {
  type        = number
  description = "the memory limit for loki"
}

variable "loki_desired_count" {
  type        = number
  description = "the amount of loki containers"
  default     = 1
}

variable "loki_bucket_lifecycle_expiration_days" {
  default     = 90
  description = "loki bucket lifecycle expiration days"
  type        = number
}

variable "loki_bucket_lifecycle" {
  default     = "Disabled"
  description = "enables lifecycle management for loki bucket"
  type        = string
}

variable "lambda_log_group_filter_exceptions" {
  type        = list(any)
  description = "A list of cloudwatch loggroups (Lambda) to NOT create substcription filters for. This list must always include '/aws/lambda/lambda_promtail'"
  default     = ["/aws/lambda/promtail-lambda-function"]
}

variable "ecs_log_group_filter_exceptions" {
  type        = list(any)
  description = "A list of cloudwatch loggroups (ECS) to NOT create substcription filters for"
  default     = []
}

variable "run_on_spot" {
  type        = bool
  description = "(optional) run grafana on FARGATE_SPOT"
  default     = false
}

variable "default_capacity_provider_strategy" {
  description = "The capacity provider strategy to use by default for the cluster. Can be one or more."
  type        = list(map(any))
  default = [
    {
      capacity_provider = "FARGATE",
      weight            = 1
    },
    {
      capacity_provider = "FARGATE_SPOT",
      weight            = 1
    }
  ]
}

variable "container_insights" {
  description = "Controls if containerInsights is enabled or disabled"
  type        = bool
  default     = false
}
