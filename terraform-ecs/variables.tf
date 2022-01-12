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
    container_port = number,
    container_cpu = string,
    container_memory = number,
    container_image = string,
    domain = string
    hosted_zone_id = string
  }))
}
variable "load_balancer_cert_arn" {
  type = string
}
variable "max_scaling_step_size" {
  type = number
}
variable "min_scaling_step_size" {
  type = number
}
variable "target_capacity" {
  type = number
}