##############################################################
# DATA
###############################################################


data "aws_availability_zones" "available" {
  state = "available"
}

################################################################
# Resources
#################################################################

# Networking
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = var.vpc_enable_dns_hostnames
       tags = merge(local.common_tags, {
        Name = "minecraft-vpc"
      })

}

resource aws_internet_gateway "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "minecraft-igw"
    }
}

resource "aws_subnet"  "subnet" {
    cidr_block = var.subnet_cidr_block
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]
    tags =  merge( local.common_tags , {
               Name = "minecraft-subnet"
        })
}

#Routing
resource "aws_route_table"  "rtb_app_server" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = var.rtb_route_cidr_block
        gateway_id = aws_internet_gateway.igw.id

    }
    tags = local.common_tags
}


resource "aws_route_table_association" "rta_subnet" {
    subnet_id =  aws_subnet.subnet.id
    route_table_id = aws_route_table.rtb_app_server.id
}

#Security Group

resource "aws_security_group" "minecraft-sg" {
    name = "mincraft-sg"
    vpc_id =  aws_vpc.vpc.id

   ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 25575
    to_port = 25575
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        #security_groups = [aws_security_group.app_lb_sg]
    }

    tags = local.common_tags
}





