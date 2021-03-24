locals {
  tags = merge(var.tags, { Terraform_module = "iam" })
}


resource "aws_iam_role" "role" {
  name = var.role_name
  path = "/"
  assume_role_policy = var.assume_role_policy

  tags = local.tags
}


resource "aws_iam_policy" "policy" {
  name = var.policy_name
  path = "/"
  policy = var.policy
}


resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_iam_instance_profile" "profile" {
  name = var.profile_name
  role = aws_iam_role.role.name
}
