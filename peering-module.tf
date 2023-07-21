# Provider Block
provider "aws" {
  region  = "us-east-1"
}

variable "requester_vpc" {
  default = "vpc-XXXXXXXXXXXXXXXXXXX"
}

variable "accepter_vpcs" {
  default = ["vpc-XXXXXXXXXXXXXXXXXXX", "vpc-XXXXXXXXXXXXXXXXXXX"]
}

module "vpc-peering" {
  source = "./vpc-module"

  requester_vpc = var.requester_vpc

  for_each      = toset(var.accepter_vpcs)
  accepter_vpcs = each.value
}