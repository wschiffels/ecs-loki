## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_loki_bucket"></a> [loki\_bucket](#module\_loki\_bucket) | ../common/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudwatch_log_subscription_filter.lambdafunction_logfilter_aws_log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_cloudwatch_log_subscription_filter.lambdafunction_logfilter_ecs_log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_ecs_cluster.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.loki_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.loki_update_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.attach_AmazonECSTaskExecutionRolePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_AmazonSSMReadOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_CloudWatchLogsFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_SecretsManagerReadWrite](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_promtail_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_s3Access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.lambda_promtail_invoke_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_permission.lambda_promtail_allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lb.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.loki_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.alertmanager_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.alertmanager_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudwatch_log_groups.ecs_log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_groups) | data source |
| [aws_cloudwatch_log_groups.lambda_log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_groups) | data source |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_file_system) | data source |
| [aws_iam_policy_document.assume-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.loki_update_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret_version.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_security_groups.prometheus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_subnet.private-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.private-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.loki_container_definition](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.loki_update_container_definition](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | n/a | `any` | n/a | yes |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | Controls if containerInsights is enabled or disabled | `bool` | `false` | no |
| <a name="input_default_capacity_provider_strategy"></a> [default\_capacity\_provider\_strategy](#input\_default\_capacity\_provider\_strategy) | The capacity provider strategy to use by default for the cluster. Can be one or more. | `list(map(any))` | <pre>[<br>  {<br>    "capacity_provider": "FARGATE",<br>    "weight": 1<br>  },<br>  {<br>    "capacity_provider": "FARGATE_SPOT",<br>    "weight": 1<br>  }<br>]</pre> | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `any` | n/a | yes |
| <a name="input_ecs_log_group_filter_exceptions"></a> [ecs\_log\_group\_filter\_exceptions](#input\_ecs\_log\_group\_filter\_exceptions) | A list of cloudwatch loggroups (ECS) to NOT create substcription filters for | `list(any)` | `[]` | no |
| <a name="input_lambda_log_group_filter_exceptions"></a> [lambda\_log\_group\_filter\_exceptions](#input\_lambda\_log\_group\_filter\_exceptions) | A list of cloudwatch loggroups (Lambda) to NOT create substcription filters for. This list must always include '/aws/lambda/lambda\_promtail' | `list(any)` | <pre>[<br>  "/aws/lambda/promtail-lambda-function"<br>]</pre> | no |
| <a name="input_lambda_promtail_image"></a> [lambda\_promtail\_image](#input\_lambda\_promtail\_image) | The ECR image URI to pull and use for lambda-promtail. | `string` | `"docker-promtail:latest"` | no |
| <a name="input_loki_bucket_lifecycle"></a> [loki\_bucket\_lifecycle](#input\_loki\_bucket\_lifecycle) | enables lifecycle management for loki bucket | `string` | `"Disabled"` | no |
| <a name="input_loki_bucket_lifecycle_expiration_days"></a> [loki\_bucket\_lifecycle\_expiration\_days](#input\_loki\_bucket\_lifecycle\_expiration\_days) | loki bucket lifecycle expiration days | `number` | `90` | no |
| <a name="input_loki_cpu_limit"></a> [loki\_cpu\_limit](#input\_loki\_cpu\_limit) | the cpu limit for loki | `number` | n/a | yes |
| <a name="input_loki_desired_count"></a> [loki\_desired\_count](#input\_loki\_desired\_count) | the amount of loki containers | `number` | `1` | no |
| <a name="input_loki_image"></a> [loki\_image](#input\_loki\_image) | the image to use for loki | `string` | n/a | yes |
| <a name="input_loki_image_tag"></a> [loki\_image\_tag](#input\_loki\_image\_tag) | the image tag to use for loki | `string` | n/a | yes |
| <a name="input_loki_keep_stream"></a> [loki\_keep\_stream](#input\_loki\_keep\_stream) | Determines whether to keep the CloudWatch Log Stream value as a Loki label when writing logs from lambda-promtail. | `string` | `"true"` | no |
| <a name="input_loki_memory_limit"></a> [loki\_memory\_limit](#input\_loki\_memory\_limit) | the memory limit for loki | `number` | n/a | yes |
| <a name="input_loki_write_address"></a> [loki\_write\_address](#input\_loki\_write\_address) | This is the Loki Write API compatible endpoint that you want to write logs to, either promtail or Loki. http://loki.<domain>.app/loki/api/v1/push | `string` | n/a | yes |
| <a name="input_run_on_spot"></a> [run\_on\_spot](#input\_run\_on\_spot) | (optional) run grafana on FARGATE\_SPOT | `bool` | `false` | no |

## Outputs

No outputs.
