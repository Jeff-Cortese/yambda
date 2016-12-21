variable "name" {}
variable "description" {
  default = ""
}

resource "aws_api_gateway_rest_api" "my_rest_api" {
  name = "${var.name}"
  description = "${var.description}"
}

output "id" {
  value = "${aws_api_gateway_rest_api.my_rest_api.id}"
}

output "root_resource_id" {
  value = "${aws_api_gateway_rest_api.my_rest_api.root_resource_id}"
}
