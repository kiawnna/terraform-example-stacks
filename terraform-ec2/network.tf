provider "aws" {
 version = "~> 3.71.0"
 region  = var.region
}

module "network" {
  source = "git@github.com:kiawnna/terraform-aws-network.git"
  environment = var.environment
}

module "ec2_security_group" {
  source = "git@github.com:kiawnna/terraform-aws-security-group.git"
  environment = var.environment
  vpc_id = module.network.vpc_id
  security_group_name = "${var.environment}-ec2-sg"
  sg_ingress_rules = [
    {
      description = "Allow traffic from load balancer security group."
      from_port = 0
      to_port = 0
      protocol = "-1"
      security_groups = [module.load_balancer_security_group.security_group_id]
    },
    {
      description = "Allow traffic from bastion security group."
      from_port = 0
      to_port = 0
      protocol = "-1"
      security_groups = [module.baston_security_group.security_group_id]
    }]
  egress_rules = [
    {
      description = "Allow all outbound traffic."
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_block = "0.0.0.0/0"
    }]
}

module "load_balancer_security_group" {
  source = "git@github.com:kiawnna/terraform-aws-security-group.git"
  environment = var.environment
  vpc_id = module.network.vpc_id
  security_group_name = "${var.environment}-load-balancer-sg"
  ingress_rules = [
    {
      description = "Allow all traffic from internet"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      description = "Allow secure traffic from internet"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_block = "0.0.0.0/0"
    }]
  egress_rules = [
    {
      description = "Allow all outbound traffic."
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_block = "0.0.0.0/0"
    }]
}

module "baston_security_group" {
  source = "git@github.com:kiawnna/terraform-aws-security-group.git"
  environment = var.environment
  vpc_id = module.network.vpc_id
  security_group_name = "${var.environment}-baston-sg"
  ingress_rules = [
    {
      description = "Allow SSH traffic from my anywhere."
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_block = "0.0.0.0/0"
    }]
  egress_rules = [
    {
      description = "Allow all outbound traffic."
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_block = "0.0.0.0/0"
    }]
}


# This will grab the amazon linux 2 ami, good for a bastion instance.
# Sse the same key pair here as for your launch template above.
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}
module "bastion" {
  source = "git@github.com:kiawnna/terraform-aws-ec2-instance.git"
  ami_id = data.aws_ami.amazon-2.id
  key_pair = var.key_pair
  environment = var.environment
  subnet_id = module.network.public_subnet_id1
  security_group_ids = [module.baston_security_group.security_group_id]
}

## Each application would need a target group and route 53.
