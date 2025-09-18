# Terraform AWS ACM Module

A Terraform module to create and validate an AWS Certificate Manager (ACM) certificate using DNS validation with Route 53.

This module simplifies the process of provisioning a public SSL/TLS certificate by automating the creation of the necessary DNS records in a pre-existing Route 53 hosted zone and waiting for the validation to complete.

## ✨ Features

-   Creates an ACM certificate for a primary domain and subject alternative names (SANs).
-   Automates the creation of DNS validation records in a Route 53 hosted zone.
-   Waits for the certificate to be successfully validated before completing, ensuring the certificate ARN is ready for use by other resources.
-   Allows for custom tags to be applied to the certificate.

## Usage Example

```terraform
module "my_app_certificate" {
  source = "git::[https://github.com/your-org/terraform-aws-acm.git?ref=v1.0.0](https://github.com/your-org/terraform-aws-acm.git?ref=v1.0.0)"

  domain_name = "myapp.example.com"
  subject_alternative_names = [
    "[www.myapp.example.com](https://www.myapp.example.com)",
    "api.myapp.example.com"
  ]

  tags = {
    "Project"     = "MyApp"
    "Environment" = "Production"
  }
}
```

## 📚 HashiCorp Terraform Registry Documentation

This module is built on top of the following AWS provider resources. For more detailed information, please refer to the official HashiCorp documentation:

-   **[aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)**: Main resource for requesting the certificate.
-   **[aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)**: Resource used to create the DNS validation records.
-   **[aws_acm_certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation)**: Resource that completes the validation process.
-   **[aws_route53_zone (Data Source)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone)**: Used to look up the hosted zone ID.

## 📥 Inputs

| Name                          | Description                                                                          | Type           | Default | Required |
| ----------------------------- | ------------------------------------------------------------------------------------ | -------------- | ------- | :------: |
| `domain_name`                 | The domain name for which the certificate should be issued.                          | `string`       | n/a     |   yes    |
| `subject_alternative_names`   | A list of additional domain names to be included in the certificate.                 | `list(string)` | `[]`    |    no    |
| `validation_method`           | The method to use for validation. Only `DNS` is supported by this module's automation. | `string`       | `"DNS"` |    no    |
| `tags`                        | A map of tags to apply to the certificate.                                           | `map(string)`  | `{}`    |    no    |

## 📤 Outputs

| Name              | Description                                       |
| ----------------- | ------------------------------------------------- |
| `certificate_arn` | The ARN of the validated ACM certificate.         |