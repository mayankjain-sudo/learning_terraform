provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "adminUser" {
    name = "admin"
    tags = {
        Description = "Server Admin"
    }
}

resource "aws_iam_policy" "adminPolicy" {
    name = "AdminUsersPolicy"
    policy = <<EOF
    {
        "Verison": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "*",
                "Resource": "*"
            }
        ]
    }
    EOF
}

// Or we can read the json policy from same directory

resource "aws_iam_policy" "adminPolicyread" {
    name = "AdminUsersPolicy"
    policy = file(admin-policy.json)
}

resource "aws_iam_policy_attachment" "adminAccess" {
    user = aws_iam_user.adminUser.name
    policy_arn = aws_iam_policy.adminPolicy.arn
  
}