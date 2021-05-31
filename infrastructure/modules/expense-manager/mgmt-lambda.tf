resource "aws_lambda_permission" "get_expense_categories_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_expense_categories.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:eu-west-1:077622725059:${aws_api_gateway_rest_api.api_gateway.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.api_gateway_resource.path}"
}

resource "aws_lambda_function" "get_expense_categories" {
  function_name = var.app_name
  s3_bucket = var.mgmt_lambda_bucket_name
  s3_key    = var.mgmt_lambda_zip

  handler   = "get-expense-categories.handler"
  runtime   = "nodejs14.x"
    
  role      = aws_iam_role.role.arn
}

# IAM
resource "aws_iam_role" "role" {
  name = "${var.mgmt_lambda_bucket_name}-role"

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