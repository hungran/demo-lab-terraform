module "init" {
  source = "../"
  subnets = var.subnets
}
resource "aws_instance" "public_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance.type
  subnet_id                   = module.init.public_subnets[var.instance.subnet]
  
  user_data = templatefile("${path.module}/resources/userData.tftpl", {})
  associate_public_ip_address = true
  tags = {
    Name = "public-instance"
  }
}
