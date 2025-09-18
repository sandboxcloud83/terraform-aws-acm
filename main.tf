# --- 1. Find the Route 53 Hosted Zone for the domain ---
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# --- 2. Request the ACM Certificate ---
resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method

  tags = merge(
    { "Name" = var.domain_name },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# --- 3. Create the DNS validation records in Route 53 ---
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.selected.zone_id
    }
  }

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  zone_id = each.value.zone_id
  ttl     = 60

  allow_overwrite = true
}

# --- 4. Wait for the certificate to be validated using the DNS records ---
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
