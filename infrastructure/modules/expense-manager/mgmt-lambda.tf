resource "aws_lambda_layer_version" "dependencies_layer" {
  s3_bucket  = aws_s3_bucket.mgmt_app_bucket.bucket
  s3_key     = "dependency_layer.zip"
  layer_name = "expense-manager-dependencies-layer"

  compatible_runtimes = ["nodejs14.x"]

  depends_on = [aws_s3_bucket_public_access_block.management_s3bucket_access_block]
}

resource "aws_lambda_function" "get_expense_categories" {
  function_name = var.app_name

  s3_bucket         = aws_s3_bucket.mgmt_app_bucket.bucket
  s3_key            = var.mgmt_lambda_zip
  handler   = "get-expense-categories.handler"
  runtime   = "nodejs14.x"
  role      = aws_iam_role.lambda_role.arn

  layers = [aws_lambda_layer_version.dependencies_layer.arn]
  vpc_config {
    subnet_ids         = data.aws_subnet_ids.private_subnets.ids
    security_group_ids = [aws_security_group.expense_manager_mgmt_sg.id]
  }
}

# IAM
resource "aws_iam_role" "lambda_role" {
  name = "${var.mgmt_lambda_bucket_name}-lambda-role"

  assume_role_policy = <<POLICY
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
POLICY
}

resource "aws_iam_role_policy_attachment" "iam_policy_for_event_validator_role_attachement" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_db.arn
}

resource "aws_iam_policy" "iam_policy_for_db" {
  name = "iam-role-policy-for-expense-manager"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ],
        "Resource" : "*"
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      }
    ]
  })
}