variable "iam_users" {
  description = "IAM user names"
  type        = list(string)
  default     = ["linux_admin", "aws_admin", "guest_user"]
}

variable "iam_groups" {
  description = "IAM group names"
  type        = list(string)
  default     = ["guest_user_group", "admin_group"]
}

