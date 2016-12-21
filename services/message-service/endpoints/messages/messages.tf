variable "api_id" {}
variable "parent_id" {}
variable "region" {}

module "messages" {
  source = "../../../../terraform/serverless/rest/resource"

  rest_api_id = "${var.api_id}"
  parent_resource_id = "${var.parent_id}"
  rest_resource_path = "messages"
}

module "get" {
  source = "../../../../terraform/serverless/rest/lambda-method"

  api_id = "${var.api_id}"
  resource_id = "${module.messages.id}"
  rest_method = "GET"
  rest_auth = "NONE"
  function_name = "get_messages"
  function_runtime = "nodejs4.3"
  source_code_path = "${path.module}/dist.zip"
  function_handler = "index.handler"
  region = "${var.region}"
}
