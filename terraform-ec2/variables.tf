variable "environment" {
  type = string
}
variable "region" {
  type = string
}
variable "key_pair" {
  type = string
}
variable "applications" {
  type = map(object({
    app_name = string,
    port = number,
    certificate_arn = string,
    priority = number,
    hosted_zone_id = string,
    domain = string
  }))
}
variable "launch_template_image_id" {
  type = string
  default = ""
}
variable "load_balancer_cert_arn" {
  type = string
}