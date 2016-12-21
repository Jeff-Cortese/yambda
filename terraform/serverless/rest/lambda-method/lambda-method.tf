variable "source_code_path" {}
variable "function_name" {}
variable "function_handler" {}
variable "function_runtime" {
  default = "nodejs4.3"
}
variable "rest_method" {}
variable "rest_auth" {}
variable "api_id" {}
variable "resource_id" {}
variable "region" {}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = "${file("terraform/serverless/rest/lambda-method/lambda-role.json")}"
}

resource "aws_iam_policy_attachment" "AWSLambdaFullAccess" {
  name = "AWSLambdaFullAccess"
  roles = [ "${aws_iam_role.lambda_role.name}" ]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}

/*resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = "lambda_basic_execution"
  role = "${aws_iam_role.lambda_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.the_lambda.function_name}:*"
      ]
    }
  ]
}
EOF
}*/

resource "aws_lambda_function" "the_lambda" {
  filename = "${var.source_code_path}"
  function_name = "${var.function_name}"
  role = "${aws_iam_role.lambda_role.arn}"
  handler = "${var.function_handler}"
  runtime = "${var.function_runtime}"
  source_code_hash = "${base64sha256(file(var.source_code_path))}"
}

resource "aws_api_gateway_method" "my_resource_method" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.rest_method}"
  authorization = "${var.rest_auth}"

  request_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "my_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.rest_method}"
  credentials = "${aws_iam_role.lambda_role.arn}"
  type = "AWS"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.the_lambda.arn}/invocations"

}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "api_to_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.the_lambda.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${var.api_id}/*/${var.rest_method}/"
}

/*resource "aws_api_gateway_model" "thing_request_model" {
  rest_api_id = "${aws_api_gateway_rest_api.the_gateway.id}"
  name = "Configuration"
  description = "A configuration schema"
  content_type = "application/json"
  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "ThingConfiguration",
  "type": "array",
  "properties": {
    "mode": { "type": "string" },
    "name": { "type": "string" },
    "predicate": { "type": "string" },
    "cookie": { "type": "string" },
    "servers": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "ip": { "type": "string" }
        }
      }
    }
  }
}
EOF
}*/

/*resource "aws_api_gateway_model" "thing_response_model" {
  rest_api_id = "${aws_api_gateway_rest_api.the_gateway.id}"
  name = "ConfigurationFile"
  description = "A configuration file schema"
  content_type = "application/json"
  schema = <<EOF
{
  "type": "object"
}
EOF
}*/

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.rest_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"//"${aws_api_gateway_model.thing_response_model.name}"
  }

  depends_on = ["aws_api_gateway_method.my_resource_method"]
}

resource "aws_api_gateway_integration_response" "my_integration_response" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.rest_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
  depends_on = ["aws_api_gateway_integration.my_integration"]
}