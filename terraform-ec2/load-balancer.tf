module "application_lb" {
  source = "git@github.com:kiawnna/terraform-aws-load-balancer.git"
  environment = var.environment
  subnets = [module.network.public_subnet_id1, module.network.public_subnet_id2]
  cert_arn = "arn:aws:acm:us-east-1:266245855374:certificate/82a78392-c867-4c97-bdc0-a0a4462c53f6"
  security_groups = []
}

