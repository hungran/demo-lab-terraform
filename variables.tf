variable "default_tags" {
  default = {
    Owner       = "hungran"
    Environment = "doa202311"
  }
  type = map(string)
}
variable "project_name" {
  default     = "codestar-lab4"
  type        = string
  description = "project name injected into task"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "instance type for all EC2 instances"
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for VPC"
}

variable "public_cidr_block" {
  default     = "10.0.1.0/24"
  type        = string
  description = "CIDR block for public subnet"
}

variable "private_cidr_block" {
  default     = "10.0.2.0/24"
  type        = string
  description = "CIDR block for private subnet"
}

variable "route_public_rtb" {
  type = map(object({
    cidr_block = string
    public_rtb = optional(bool)
    nat_gw_id  = optional(string)
  }))
  default = {
    default_route = {
      public_rtb = true
      cidr_block = "0.0.0.0/0"
    }
    sample_route = {
      public_rtb = true
      cidr_block = "1.1.1.1/32"
    }
  }
}

variable "natgw_enabled" {
  type    = bool
  default = false
}

variable "user_data_public_instance" {
  type = string
}
