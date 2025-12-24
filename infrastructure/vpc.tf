resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = { Name = "starman-vpc" }

}

#PUBLIC SUBNETS
resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.main.id 
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = { Name = "starman-public-1"}
}

resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = { Name = "starman-public-2"}
}

#PRIVATE SUBNET (Database)

resource "aws_subnet" "private_1" {
    vpc_id = aws_vpc.main.id 
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1a"
    tags = { Name = "starman-private-1"}
}

resource "aws_subnet" "private_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = { Name = "starman-private-2"}
}

#INTERNET GATEWAY - ALLOW INTERNET COMUNICATION BUT WE ALSO AVOID TO HIRE A NAT GATEWAY. SAVINGS
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    
}

resource "aws_route_table_association" "public_1" {
    subnet_id = aws_subnet.public_1.id 
    route_table_id = aws_route_table.public.id 
}

resource "aws_route_table_association" "public_2" {
    subnet_id = aws_subnet.public_2.id 
    route_table_id = aws_route_table.public.id 
}

