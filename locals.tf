locals {
  vpc_cidr_block     = var.vpc_cidr_block
  instance_type      = var.instance_type
  project_name       = var.project_name

  sample_local_is_not_store_in_state_file = "This is a sample local variable"
  subnet_id_for_ec2 = { for k, v in var.subnets : k => aws_subnet.public_net[k].id if v.az == "ap-southeast-1a" }

}

output "sample_output" {
  value = local.sample_local_is_not_store_in_state_file
}
