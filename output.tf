output "instance_manage_user_access_key" {
  value = "${aws_iam_access_key.GitHubUser.id}"
}
output "instance_manage_user_secret_key" {
  value = "${aws_iam_access_key.GitHubUser.secret}"
}
