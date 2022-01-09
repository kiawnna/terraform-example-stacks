############----------------------------------------------------------------------------------------############
# Each of the below modules will be deployed for each application listed in the applications variable, which is
# a map or map.
############----------------------------------------------------------------------------------------############
module "target_group" {
  for_each = var.applications
  source = "git@github.com:kiawnna/terraform-aws-target-group.git"

  load_balancer_arn = module.application_lb.load_balancer_arn
  port = each.value.port
  vpc_id = module.network.vpc_id
  app_name = each.value.app_name
  environment = var.environment
}
module "listener_rule" {
  for_each = var.applications
  source = "git@github.com:kiawnna/terraform-aws-listener-rule.git"

  target_group_arn = module.target_group[each.key].target_group_arn
  listener_arn = module.application_lb.listener_443_arn
  domain = each.value.domain
}
module "route53_record" {
  for_each = var.applications
  source = "git@github.com:kiawnna/terraform-aws-route53-record.git"

  hosted_zone_id = each.value.hosted_zone_id
  domain = each.value.domain
  alias_name = module.application_lb.lb_dns_name
  alias_zone_id = module.application_lb.lb_zone_id
}