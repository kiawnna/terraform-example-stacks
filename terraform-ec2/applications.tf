locals {
  applications = {
    first_app = {
      app_name: "test-app-1",
      port: 80,
      certificate_arn: "arn:aws:acm:us-west-1:147415077554:certificate/d45a4c26-9c7c-4bde-9ee7-022fb79403a4",
      priority: 589,
      hosted_zone_id = "HOSTEDZONEID",
      domain = "my.domain.com"
    }
  }
}

module "target_group" {
  for_each = local.applications
  source = "git@github.com:kiawnna/terraform-aws-target-group.git"
  load_balancer_arn = module.application_lb.load_balancer_arn
  port = each.value.port
  vpc_id = module.network.vpc_id
  app_name = each.value.app_name
  environment = var.environment
}

module "route53_record" {
  for_each = local.applications
  source = "git@github.com:kiawnna/terraform-aws-route53-record.git"
  hosted_zone_id = each.value.hosted_zone_id
  domain = each.value.domain
  alias_name = module.application_lb.lb_dns_name
  alias_zone_id = module.application_lb.lb_zone_id
}