resource "aws_vpc" "web-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env-prefix}-VPC"
  }
}

resource "aws_subnet" "vpc-subnet" {
  count                   = length(var.subnet_cidr_blocks)
  vpc_id                  = aws_vpc.web-vpc.id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = var.avail_zones[count.index]
  map_public_ip_on_launch = var.map_pub_ip[count.index]
  tags = {
    Name = var.subnet_names[count.index]
  }
}
resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.web-vpc.id
  tags = {
    Name = "${var.env-prefix}-IGW"
  }
}
resource "aws_eip" "eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "web-ngw" {
  allocation_id = aws_eip.eip.allocation_id
  subnet_id     = aws_subnet.vpc-subnet[0].id
  tags = {
    Name = "${var.env-prefix}-ngw"
  }
}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.web-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-igw.id
  }
  tags = {
    Name = "Public-RT-${var.env-prefix}"
  }
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.web-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web-ngw.id
  }
  tags = {
    Name = "Private-RT-${var.env-prefix}"
  }
}

