# Provider Block
provider "aws" {
  region  = "us-east-1"
  profile = "bharath"
}

variable "requester_vpc" {
  default = "vpc-095e2532dec8f2eb2"
}

variable "accepter_vpcs" {
  default = ["vpc-0e5b14f70041ad695", "vpc-02c789e9d4827c24c"]
}

module "vpc-peering" {
  source = "./vpc-module"

  requester_vpc = var.requester_vpc

  for_each      = toset(var.accepter_vpcs)
  accepter_vpcs = each.value
}