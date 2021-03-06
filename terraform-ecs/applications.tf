module "task_definition" {
  source = "git@github.com:kiawnna/terraform-aws-task-definition.git"
  for_each = var.applications

  app_name = each.value.app_name
  container_definitions = <<-EOF
[
  {
    "name": "${each.value.app_name}-${var.environment}",
    "image": "${each.value.container_image}",
    "memory": ${each.value.container_memory},
    "cpu": ${each.value.container_cpu},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${each.value.container_port}
      }
    ]
  }
]
EOF
  environment = var.environment
  task_execution_role_arn = module.task_execution_role.role_arn
  task_role_arn = module.task_role.role_arn
}
module "target_group" {
  source = "../../terraform-aws-target-group"
  for_each = var.applications

  app_name = each.value.app_name
  environment = var.environment
  load_balancer_arn = module.application_lb.load_balancer_arn
  port = 80
  vpc_id = module.network.vpc_id
  target_type = "ip"
  health_check_timeout = 60
  health_check_interval = 120
}
module "service" {
  source = "git@github.com:kiawnna/terraform-aws-ecs-service.git"
  for_each = var.applications

  container_name = "${each.value.app_name}-${var.environment}"
  app_name = each.value.app_name
  capacity_provider_name = module.capacity_provider.capacity_provider_name
  capacity_provider_weight = 100
  container_port = each.value.container_port
  ecs_cluster_id = module.ecs_cluster.cluster_id
  environment = var.environment
  target_group_arn = module.target_group[each.key].target_group_arn
  task_definition_arn = module.task_definition[each.key].task_definition_arn
  task_desired_count = "1"
  security_groups = [module.ecs_services_security_group.security_group_id]
  subnets = [module.network.private_subnet_id, module.network.private_subnet_id2]
}
module "listener_rule" {
  source = "../../terraform-aws-listener-rule"
  for_each = var.applications
  domain = each.value.domain
  listener_arn = module.application_lb.listener_443_arn
  target_group_arn = module.target_group[each.key].target_group_arn
}
module "route53_record" {
  for_each = var.applications
  source = "../../terraform-aws-route53-record"
  alias_name = module.application_lb.lb_dns_name
  alias_zone_id = module.application_lb.lb_zone_id
  domain = each.value.domain
  hosted_zone_id = each.value.hosted_zone_id
}