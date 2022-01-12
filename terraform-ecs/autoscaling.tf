locals {
  cluster_name = "shared-${var.environment}-ecs-cluster"
  user_data = <<EOF
 #! /bin/bash
 echo "ECS_CLUSTER=${local.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

data "aws_ami" "ecs-optimized" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.20211115-x86_64-ebs"]
  }
  owners = ["amazon"]
}

module "launch_template" {
  source = "git@github.com:kiawnna/terraform-aws-launch-template.git"
  image_id = data.aws_ami.ecs-optimized.id
  key_pair = var.key_pair
  environment = var.environment
  security_group_ids = [module.ec2_security_group.security_group_id]
  ebs_optimized = false
  instance_profile_name = aws_iam_instance_profile.ecs_host_instance_profile.name
  user_data = base64encode(local.user_data)
}

module "asg" {
  source = "git@github.com:kiawnna/terraform-aws-autoscaling-group.git"
  environment = var.environment
  launch_template_id = module.launch_template.launch_template_id
  subnet_ids = [module.network.private_subnet_id2, module.network.private_subnet_id]
}