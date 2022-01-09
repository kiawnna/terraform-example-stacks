module "application_lb" {
  source = "git@github.com:kiawnna/terraform-aws-load-balancer.git"
  environment = var.environment
  subnets = [module.network.public_subnet_id1, module.network.public_subnet_id2]
  cert_arn = var.load_balancer_cert_arn
  security_groups = [module.load_balancer_security_group.security_group_id]
}