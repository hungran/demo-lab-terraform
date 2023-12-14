locals {
  vpc_cidr_block     = var.vpc_cidr_block
  private_cidr_block = var.private_cidr_block
  public_cidr_block  = var.public_cidr_block
  instance_type      = var.instance_type
  project_name       = var.project_name

  sample_local_is_not_store_in_state_file = "This is a sample local variable"
  sample_local_02 = aws_instance.private_instance.private_ip
}

output "sample_output" {
  value = local.sample_local_is_not_store_in_state_file
}
output "sample_local_02" {
    value = local.sample_local_02
}