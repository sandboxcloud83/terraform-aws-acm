# --- Prerequisite: LOOK UP an existing Route 53 Hosted Zone ---
# Instead of creating a resource, we use a data source to find
# the pre-existing hosted zone. This makes the example declarative.
data "aws_route53_zone" "example" {
  name = var.test_domain_name
}

# --- Module Invocation ---
# The module call remains the same, but it now receives the domain
# name from the variable, which refers to an existing resource.
module "acm_certificate_example" {
  source = "../"
  domain_name               = data.aws_route53_zone.example.name
  subject_alternative_names = ["www.${data.aws_route53_zone.example.name}"]
  tags = {
    "Terraform-Example" = "acm"
    "Managed-By"        = "Terraform"
  }
}
