## Example variables
environment = "dev"
region = "us-east-1"
key_pair = "kia-us-east-1"
load_balancer_cert_arn = "arn:aws:acm:us-east-1:266245855374:certificate/05a4299f-3a8a-4206-8ec0-5b2887313f20"
applications = {
  testapp1 = {
    app_name = "test-app-1",,
    container_port = 80,
    container_cpu = 256,
    container_memory = 512,
    container_image = "",
    domain = "testapp1.learn2cloud.io"
    hosted_zone_id = "Z067219834Z3PY1OF42HM"
    certificate_arn = "arn:aws:acm:us-east-1:266245855374:certificate/05a4299f-3a8a-4206-8ec0-5b2887313f20"
  }
}
max_scaling_step_size = 2
min_scaling_step_size = 1
target_capacity = 80