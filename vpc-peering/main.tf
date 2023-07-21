variable "requester_vpc" {}

variable "accepter_vpcs" {}

data "aws_vpc" "requester_vpc" {
  id = var.requester_vpc
}

data "aws_vpc" "accepter_vpcs" {
  id = var.accepter_vpcs
}

resource "aws_vpc_peering_connection" "MyAWSResource" {
  peer_vpc_id = data.aws_vpc.accepter_vpcs.id
  vpc_id      = data.aws_vpc.requester_vpc.id
}

resource "aws_vpc_peering_connection_accepter" "MyAWSResource" {
  vpc_peering_connection_id = aws_vpc_peering_connection.MyAWSResource.id
  auto_accept               = true
}

data "aws_route_tables" "rrts" {
  vpc_id = data.aws_vpc.requester_vpc.id
}

resource "aws_route" "r" {
  count                     = length(data.aws_route_tables.rrts.ids)
  route_table_id            = tolist(data.aws_route_tables.rrts.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.accepter_vpcs.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.MyAWSResource.id
}

data "aws_route_tables" "arts" {
  vpc_id = data.aws_vpc.accepter_vpcs.id
}

resource "aws_route" "a" {
  count                     = length(data.aws_route_tables.arts.ids)
  route_table_id            = tolist(data.aws_route_tables.arts.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.requester_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.MyAWSResource.id
}