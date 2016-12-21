/*variable "aws_access_key" {}
variable "aws_secret_key" {}*/
variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region = "${var.region}"
}

module "messages-service" {
  source = "./services/message-service"

  region = "${var.region}"
}

