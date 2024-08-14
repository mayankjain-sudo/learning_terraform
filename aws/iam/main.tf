resource "aws_iam_user" "create_user" {
    name = var.users_name[count.index.id]
}