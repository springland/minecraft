variable region {
    default = "us-west-2"
    type = string
    description = " AWS Region"
    sensitive = false
}

variable profile {
    default = "ecs"
    type = string
    description = "AWS CLI connection profile"
    sensitive = false
}

variable  vpc_cidr_block {
    type = string
    default = "20.0.0.0/16"

}

variable vpc_enable_dns_hostnames {
    type = bool
    default = true
}

variable subnet_cidr_block {
    type = string
    default = "20.0.0.0/24"
}

variable "rtb_route_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "appserver_instance_type" {
  type    = string
  default = "t3.medium"
}

