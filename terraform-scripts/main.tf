####main.tf####
#Fetch Availability AZs dynamically
data "aws_availability_zones" "available" {
}

### Vitual Private Cloud (VPC) ####
resource "aws_vpc" "main" {
  cidr_block           =  var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "8byte-vpc"
    }
}

### Public Subnet (for Application Load Balancer/ NAT Gateway)####
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "8byte-public-subnet"
  }
}

### Private Subnet (for EC2 Instances and RDS) ####
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "8byte-private-subnet"
  }
}

### Internet Gateway ######
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "8byte-igw"
  }
}

### Route Table for Public Subnet ####
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "8byte-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

#### NAT Gateway setup ####

## Elastic IP for NAT Gateway ##
resource "aws_eip" "nat_eip" {
  domain = "vpc" 

  tags = {
    Name = "nat-eip"
  }
}

## NAT Gateway in public subnet ##
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on = [ aws_internet_gateway.igw ]
  tags = {
    Name = "nat-gw"
  }
}

## Private Route Table ##
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "8byte-private-rt"
  }
}

resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}