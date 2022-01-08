# Launches a wordpress ami.
data "aws_ami" "wordpress-ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["bitnami-wordpress-5.8.2-30-r14-linux-debian-10-x86_64-hvm-ebs-nami-7d426cb7-9522-4dd7-a56b-55dd8cc1c8d0"]
  }
  owners = ["amazon-marketplace"]
}

module "launch_template" {
  source = "git@github.com:kiawnna/terraform-aws-launch-template.git"
  environment = var.environment
  image_id = data.aws_ami.amazon-2.id
  key_pair = var.key_pair
  security_group_ids = [module.ec2_security_group.security_group_id]
}

# Need to figure out how to port the target group arns from a for each into this module.
module "asg" {
  source = "git@github.com:kiawnna/terraform-aws-autoscaling-group.git"
  environment = var.environment
  launch_template_id = module.launch_template.launch_template_id
  target_group_arns = [""]
  subnet_ids = [module.network.private_subnet_id2, module.network.private_subnet_id]
}