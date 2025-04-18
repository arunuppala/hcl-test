variable "region" { default = "us-west-2" }
variable "env" { default = "dev" }

variable "app_name" {
  description = "Name of the application"
  type        = list(string)
  default     = []
}