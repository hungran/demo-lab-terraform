variable "subnets" {
  default = {
    public1 = {
        cidr_block = "10.0.0.0/24"
        az = "ap-southeast-1a"
        public = true
    }
    public2 = {
        cidr_block = "10.0.1.0/24"
        az = "ap-southeast-1b"
        public = true
    }
    public3 = {
        cidr_block = "10.0.2.0/24"
        az = "ap-southeast-1c"
        public = true
    }
  }
}

variable "instance" {
  default = {
    type = "t2.micro"
    subnet = "public1"
  }
}