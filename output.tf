output "iam_usernames" {
  value = aws_iam_user.iam_users.*.name
}

output "iam_group_names" {
  value = aws_iam_group.iam_groups.*.name
}