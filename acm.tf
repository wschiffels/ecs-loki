resource "aws_acm_certificate" "loki" {
  domain_name       = "loki.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "loki" {
  for_each = {
    for dvo in aws_acm_certificate.loki.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = data.aws_route53_zone.selected.id
  name    = each.value.name
  type    = each.value.type
  ttl     = "60"
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "loki" {
  certificate_arn         = aws_acm_certificate.loki.arn
  validation_record_fqdns = [for record in aws_route53_record.loki : record.fqdn]
}
