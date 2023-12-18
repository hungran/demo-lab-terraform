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

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for VPC"
}

# subnets = {
#   public1 = {
#     cidr_block = 10.0.0.0/24
#     az = ap-southeast-1a
#     public = true
#   },
#   public2 = {
#     cidr_block = 10.0.0.0/24
#     az = ap-southeast-1a
#     public = true
#   },
#  privite1 = {
# #     cidr_block = 10.0.0.0/24
# #     az = ap-southeast-1a
# #     public = f
# #   }
# # }
variable "subnets" {
  type = map(object({
    cidr_block = string
    az = string
    public = bool
  }))
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


