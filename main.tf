// VPC + 2 Subnet
resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr_block

  tags = {
    "Name"        = "${local.project_name}-vpc",
    "Description" = "VPC"
  }
}

resource "aws_subnet" "private_net" {
   for_each = {
    for k, v in var.subnets : k => v 
    if v.public == false
  }
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value.cidr_block

  tags = {
    Name        = "${local.project_name}-${each.key}",
    Description = "Private subnet for ${local.project_name}"
  }
}

resource "aws_subnet" "public_net" {
  for_each = {
    for k, v in var.subnets : k => v 
    if v.public == true
  }
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value.cidr_block
  
  map_public_ip_on_launch = true

  tags = {
    "Name"        = "${local.project_name}-${each.key}",
    "Description" = "Public subnet for ${local.project_name}"
  }
}

// IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "IGW"
  }
}

// NAT GW + Elastic IP for NAT GW
resource "aws_eip" "nat_ip" {
  count = var.natgw_enabled ? 1 : 0
  tags = {
    Name = "NAT-EIP"
  }
}

resource "aws_nat_gateway" "main-natgw" {
  count = var.natgw_enabled ? 1 : 0
  
  allocation_id = aws_eip.nat_ip[0].id
  subnet_id     = local.subnet_id_for_ec2
  
  tags = {
    "Name" = "NatGW",
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id
    
  dynamic route {
    for_each = var.route_public_rtb
    content {
       cidr_block     = route.value.cidr_block
       gateway_id     = route.value.public_rtb ? aws_internet_gateway.igw.id : null
       nat_gateway_id = try(route.value.nat_gateway_id, null)
       }
    }

  tags = {
    "Name" = "public-rtb",
  }

}

resource "aws_route_table" "private_rtb" {
  
  vpc_id = aws_vpc.vpc.id
  dynamic route {
    for_each = var.natgw_enabled ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main-natgw[0].id
    }
  }
  tags = {
    "Name" = "private-rtb",
  }
}

// Route Table association
resource "aws_route_table_association" "route_public_subnet" {
  for_each = {
    for k, v in var.subnets : k => v 
    if v.public == true
  }
  subnet_id      = aws_subnet.public_net[each.key].id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "route_private_subnet" {
  for_each = {
    for k, v in var.subnets : k => v 
    if v.public == false
  }
  subnet_id      = aws_subnet.private_net[each.key].id
  route_table_id = aws_route_table.private_rtb.id
}



