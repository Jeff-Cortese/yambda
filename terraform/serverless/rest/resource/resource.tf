
variable "rest_api_id" {}
variable "parent_resource_id" {}
variable "rest_resource_path" {}

resource "aws_api_gateway_resource" "my_restful_resource" {
  rest_api_id = "${var.rest_api_id}"
  parent_id = "${var.parent_resource_id}"
  path_part = "${var.rest_resource_path}"
}


output "id" {
  value = "${aws_api_gateway_resource.my_restful_resource.id}"
}

output "rest_api_id" {
  value = "${aws_api_gateway_resource.my_restful_resource.rest_api_id}"
}

output "parent_id" {
  value = "${aws_api_gateway_resource.my_restful_resource.parent_id}"
}