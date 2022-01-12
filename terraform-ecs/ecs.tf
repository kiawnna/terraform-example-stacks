module "ecs_cluster" {
  source = "git@github.com:kiawnna/terraform-aws-ecs-cluster.git"
  capacity_provider_names = [module.capacity_provider.capacity_provider_name]
  default_capacity_provider_name = module.capacity_provider.capacity_provider_name
  environment = var.environment
}

module "capacity_provider" {
  source = "git@github.com:kiawnna/terraform-aws-capacity-provider.git"
  auto_scaling_group_arn = module.asg.autoscaling_group_arn
  environment = var.environment
}