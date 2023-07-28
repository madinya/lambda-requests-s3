resource "aws_lambda_function" "my_lambda" {
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = "${var.function_name}"
  role          = aws_iam_role.my_role.arn
  timeout       = var.timeout
  memory_size   = var.memory_size
  handler       = var.handler
  runtime       = var.runtime
  dynamic "environment" {
    for_each = var.env_variables
    content {
      variables = environment.value
    }
  }
}

resource "aws_iam_policy" "my_policy" {
  name        = "${var.policy_name}"
  description = "IAM Policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": 
  [
    {
        "Effect": "Allow",
        "Action": [
            "s3:ListAllMyBuckets",
            "s3:GetBucketLocation"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::${var.s3_bucket}",
            "arn:aws:s3:::${var.s3_bucket}/*"
        ]
    },
    {
        "Action": [
            "autoscaling:Describe*",
            "cloudwatch:*",
            "logs:*",
            "sns:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_role" "my_role" {
  name               = "${var.role_name}"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  inline_policy {
    name = "perms"
    policy = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : concat(
          [
            {
              "Effect" : "Allow",
              "Action" : [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
              ],
              "Resource" : "*"
            }
          ],
          var.permissions
        )
      }
    )
  }
}

resource "aws_iam_role_policy_attachment" "iam-policy-attach" {
  role       = aws_iam_role.my_role.name
  policy_arn = aws_iam_policy.my_policy.arn
}


