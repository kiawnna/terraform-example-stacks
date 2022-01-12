module "ecs_cluster" {
  source = "../../terraform-aws-ecs-cluster"
  capacity_provider_names = [module.capacity_provider.capacity_provider_name]
  capacity_provider_weight = 1
  default_capacity_provider_name = module.capacity_provider.capacity_provider_name
  environment = var.environment
}

module "capacity_provider" {
  source = "../../terraform-aws-capacity-provider"
  auto_scaling_group_arn = module.asg.autoscaling_group_arn
  environment = var.environment
  max_scaling_step_size = var.max_scaling_step_size
  min_scaling_step_size = var.min_scaling_step_size
  target_capacity = var.target_capacity
}