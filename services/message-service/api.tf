variable "region" {}

module "messages-api" {
  source = "../../terraform/serverless/rest"

  name = "message-api"
  description = "API for all things messages"
}


module "messages-endpoint" {
  source = "./endpoints/messages"

  api_id = "${module.messages-api.id}"
  parent_id = "${module.messages-api.root_resource_id}"
  region = "${var.region}"
}

resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = "${module.messages-api.id}"
  stage_name = "dev"
  depends_on = ["module.messages-endpoint"]
}
