provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "proj3vpc"
  }
}

resource "aws_subnet" "public-us-east-1a" {
  # count                   = length(var.public_subnet_cidrs)
  # vpc_id                  = aws_vpc.main.id
  # cidr_block              = element(var.public_subnet_cidrs, count.index)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    #Name                         = "pub_subnet_${count.index + 1}"
    Name                         = "pub_subnet_-us-east-1a"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  # count                   = length(var.public_subnet_cidrs)
  # vpc_id                  = aws_vpc.main.id
  # cidr_block              = element(var.public_subnet_cidrs, count.index)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    #Name                         = "pub_subnet_${count.index + 1}"
    Name                         = "pub_subnet_-us-east-1b"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "proj3-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "proj3-Second_RT"
  }

}

# resource "aws_route_table_association" "associate_rt" {
#   count          = length(var.public_subnet_cidrs)
#   subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
#   route_table_id = aws_route_table.rt.id
# }

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.rt.id
}


