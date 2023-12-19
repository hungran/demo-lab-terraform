output "public_subnets" {
  description = "ID of public subnets"
  value = { for k,v in aws_subnet.public_net : k => v.id }
}

output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.vpc.id
}