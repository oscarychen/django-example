variable "bucket_name" {
  type    = string
  default = "django-example-terraform-state"
}

variable "table_name" {
  type    = string
  default = "django-example-terraform-lock"
}
