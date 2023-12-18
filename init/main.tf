module "init" {
  source = "../"
  user_data_public_instance = templatefile("${path.module}/resources/userData.tftpl", {})
  subnets = var.subnets
}
resource "aws_instance" "public_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id_for_ec2
  
  user_data                   = try(var.user_data_public_instance, null)
  associate_public_ip_address = true
  tags = {
    Name = "public-instance"
  }
}
