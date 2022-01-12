module "task_execution_role" {
  source = "../../terraform-aws-iam-role"
  service = "ecs-tasks.amazonaws.com"
  policy = data.aws_iam_policy_document.task_execution_policy.json
  role_name = "task-execution-role-${var.environment}"
  environment = var.environment
  managed_policies_list = []
}

data "aws_iam_policy_document" "task_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }
}

module "task_role" {
  source = "../../terraform-aws-iam-role"
  service = "ecs-tasks.amazonaws.com"
  policy = data.aws_iam_policy_document.task_policy.json
  role_name = "task-role-${var.environment}"
  environment = var.environment
  managed_policies_list = []
}

data "aws_iam_policy_document" "task_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:*"
    ]
    resources = [
      "*"
    ]
  }
}

module "ecs_host_role" {
  source = "../../terraform-aws-iam-role"
  service = "ec2.amazonaws.com"
  policy = data.aws_iam_policy_document.ecs_host_policy.json
  role_name = "ecs-host-role-${var.environment}"
  environment = var.environment
  managed_policies_list = []
}

data "aws_iam_policy_document" "ecs_host_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:CompleteLayerUpload",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_instance_profile" "ecs_host_instance_profile" {
  name = "beanstalk-ec2-terraform-eb-${var.environment}-inst-prof"
  role = module.ecs_host_role.role_name
}