variable "domain_name" {
  description = "The domain name for which the certificate should be issued."
  type        = string
}

variable "subject_alternative_names" {
  description = "A list of additional domain names to be included in the certificate."
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "The method to use for validation. At this moment, only DNS is fully supported by this module."
  type        = string
  default     = "DNS"
}

variable "tags" {
  description = "A map of tags to apply to the certificate."
  type        = map(string)
  default     = {}
}
