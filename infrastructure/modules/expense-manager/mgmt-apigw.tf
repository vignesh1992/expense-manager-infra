data "aws_caller_identity" "current" {}

# API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "${var.app_name}-apis"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_rest_api_policy" "api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "execute-api:Invoke",
        "Resource" : "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*/*"
      }
    ]
  })
}

resource "aws_api_gateway_resource" "expense_categories" {
  path_part   = "expense-categories"
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_method" "expense_categories_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.expense_categories.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "expense_categories_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.expense_categories.id
  http_method             = aws_api_gateway_method.expense_categories_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_expense_categories.invoke_arn
}

resource "aws_lambda_permission" "get_expense_categories_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_expense_categories.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:eu-west-1:077622725059:${aws_api_gateway_rest_api.api_gateway.id}/*/${aws_api_gateway_method.expense_categories_get_method.http_method}${aws_api_gateway_resource.expense_categories.path}"
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [aws_api_gateway_integration.expense_categories_get_integration]

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  stage_name        = "default"
  stage_description = md5(file("mgmt-apigw.tf"))
}