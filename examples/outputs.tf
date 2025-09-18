output "validated_certificate_arn" {
  description = "The ARN of the certificate created and validated by the module."
  value       = module.acm_certificate_example.certificate_arn
}
