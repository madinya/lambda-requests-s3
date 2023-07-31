resource "aws_iam_role" "my_role" {
  name = var.role_name
  path = "/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
  description = "Role created by Terraform"
}

resource "aws_iam_policy" "my_policy" {
  name        = var.policy_name
  description = "IAM Policy"
  policy = jsonencode({
    "Version"   = "2012-10-17"
    "Statement" = var.statements
  })
}

resource "aws_iam_role_policy_attachment" "iam-policy-attach" {
  role       = aws_iam_role.my_role.name
  policy_arn = aws_iam_policy.my_policy.arn
}
