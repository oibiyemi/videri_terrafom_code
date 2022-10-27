# Note: the typical resource block looks like this;
#resource = "<Provider>_<resource_type>" "name"{
#    argument 
#    key  = "value"
#    key2 = "another value"
#   }

# if we already have the s3 bucket and DynamoDb table provisioned,
# we can use the below configuration;
# terraform {
#  backend "s3" {
#    bucket         = "angelo-terraform-state-backend"
#    key            = "terraform.tfstate"
#    region         = "ca-central-1"
#    dynamodb_table = "terraform_state"
#  }
#}
# However, if we will be provioning s3 and DynamoDb by ourselves, we will use 
# the configuration in this file; s3andDynamoBackend.tpl
#  First,  we initiate our configuration with a local backend (terraform init) and then 
# we define the resources using the configuration in "s3andDynamoBackend.tpl" and then run terraform init again

/// VPC RESOURCE ///

resource "aws_vpc" "videri_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns

  tags = {
    Name = "videri_vpc"
  }
}

/// PUBLIC SUBNET

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.videri_vpc.id
  cidr_block              = var.public_cidr_block
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = var.map_public_ip

  tags = {
    Name = "public_subnet"
  }
}





/// PRIVATE SUBNET

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.videri_vpc.id
  cidr_block              = var.private_cidr_block
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = var.map_private_ip

  tags = {
    Name = "private_subnet"
  }
}


resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.videri_vpc.id
  cidr_block              = var.private_cidr_block_b
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = var.map_private_ip

  tags = {
    Name = "private_subnet2"
  }
}


/// INTERNET GATEWAY ///

resource "aws_internet_gateway" "videri_gw" {
  vpc_id = aws_vpc.videri_vpc.id

  tags = {
    Name = "videri_gw"
  }
}

/// ELASTIC IP ALLOCATION for the NAT gateway
resource "aws_eip" "nat_eip1" {
  vpc = true
}


/// NAT GATEWAY ///
# NAT gateway allows instances in a private subnet access to the internet
# Note the NAT gateway has to have an eip. If you have 2 public subnets and 2 private subnets


resource "aws_nat_gateway" "nat_subnet" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip1.id


  tags = {
    Name = "videri_nat1"
  }

}



///  ROUTE TABLE PUBLIC AND PRIVATE ///          
# Each subnet in the VPC must be associated with a route table
# a protocol that determines where network traffic is directed from your subnet or gateway 


///Public

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.videri_vpc.id


  tags = {
    Name = "public_rt"
  }
}
resource "aws_route" "public_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.destination_cidr
  gateway_id             = aws_internet_gateway.videri_gw.id
}




///Private

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.videri_vpc.id


  tags = {
    Name = "private_rt"
  }
}

resource "aws_route" "private_r1" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.destination_cidr
  nat_gateway_id         = aws_nat_gateway.nat_subnet.id
}


resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.videri_vpc.id


  tags = {
    Name = "private_rt2"
  }
}

resource "aws_route" "private_r2" {
  route_table_id         = aws_route_table.private_rt2.id
  destination_cidr_block = var.destination_cidr
  nat_gateway_id         = aws_nat_gateway.nat_subnet.id
}


///ROUTE TABLE ASSOCIATION PUBLIC AND PRIVATE ///
# Creates an association between a route table and a subnet, internet gateway, or virtual private gateway


///Public
/// The gateway ID Conflicts with subnet_id. Better to use subnet ID when defining RTA
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}



///Private

resource "aws_route_table_association" "private_rta1" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rta2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt2.id
}





/// SECURITY GROUPS ///
# In the cloud, Egress means traffic that’s leaving the private network out to the internet
# Ingress refers to traffic sent from an address in public internet to the private network


resource "aws_security_group" "videri_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.videri_vpc.id

  # Ingress is traffic that enters the boundary of a network.
  ingress {
    description = "TLS from VPC"
    from_port   = var.port
    to_port     = var.port
    protocol    = var.protocol
    cidr_blocks = [aws_vpc.videri_vpc.cidr_block] ///Add your own IP here///
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    description = "Telnet"
    cidr_blocks = [var.destination_cidr]
  }

  # Egress is network traffic that exits an entity
  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = "-1"
    cidr_blocks = [var.destination_cidr]
  }

  tags = {
    Name = "videri_sg"
  }
}








