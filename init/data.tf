data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
data "aws_caller_identity" "current" {}
# data "aws_ami" "lab" {
#   depends_on = [ aws_ami_from_instance.ami ]
#   executable_users = ["self",data.aws_caller_identity.current.account_id]
#   most_recent      = true
#   # name_regex       = "^doing-stack-\\d{3}"
#   owners           = ["self"]

#   filter {
#     name   = "name"
#     values = ["doing-stack-*"]
#   }

#   # filter {
#   #   name   = "root-device-type"
#   #   values = ["ebs"]
#   # }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
  
