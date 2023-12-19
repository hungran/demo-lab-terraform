resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.init.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "asg" {
  name        = "asg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.init.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_lb_target_group" "alb" {
  name        = "alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.init.vpc_id
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [ for value in module.init.public_subnets : value ]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}

resource "aws_ami_from_instance" "ami" {
  name               = "doing-stack-20231218-v1"
  source_instance_id = aws_instance.public_instance.id
}

resource "aws_launch_template" "doing_lab" {
  name = "doing_lab"
  user_data = filebase64("${path.module}/resources/userData.tftpl")
  image_id = aws_ami_from_instance.ami.id
  instance_type = var.instance.type
  vpc_security_group_ids = [aws_security_group.asg.id]
}

resource "aws_autoscaling_group" "bar" {
  vpc_zone_identifier = [for value in module.init.public_subnets : value]
  desired_capacity   = 3
  max_size           = 4
  min_size           = 2
  target_group_arns = [aws_lb_target_group.alb.arn]
  launch_template {
    id      = aws_launch_template.doing_lab.id
    version = "$Latest"
  }
}