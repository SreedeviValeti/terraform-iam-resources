# Declare the required provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region  = "us-west-1"
  profile = "default"
}

# Create IAM Users

resource "aws_iam_user" "iam_users" {
  count = length(var.iam_users)
  name  = var.iam_users[count.index]
  path  = "/"
}

# Create IAM groups 

resource "aws_iam_group" "iam_groups" {
  count = length(var.iam_groups)
  name  = var.iam_groups[count.index]
  path  = "/"
}


# Attach IAM users to IAM Group

resource "aws_iam_user_group_membership" "guest_group_membership" {
  user = aws_iam_user.iam_users.2.name
  groups = [
    aws_iam_group.iam_groups.0.name
  ]
}

resource "aws_iam_user_group_membership" "admin_group_membership1" {
  user = aws_iam_user.iam_users.1.name
  groups = [
    aws_iam_group.iam_groups.1.name
  ]
}

resource "aws_iam_user_group_membership" "admin_group_membership2" {
  user = aws_iam_user.iam_users.0.name
  groups = [
    aws_iam_group.iam_groups.1.name
  ]
}

# IAM policy for Guest group

resource "aws_iam_group_policy" "guest_group_policy" {
  name  = "guest_group_policy"
  group = aws_iam_group.iam_groups.0.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "s3:ListAllMyBuckets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# IAM policy for Admin group

resource "aws_iam_group_policy" "admin_group_policy" {
  name  = "admin_group_policy"
  group = aws_iam_group.iam_groups.1.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


