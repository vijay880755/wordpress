resource "aws_vpc" "clevertap-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" 
    enable_dns_hostnames = "true" 
    tags = {
        Name = "clevertap-vpc"
    }
}

resource "aws_subnet" "clevertap-subnet-1" {
    vpc_id = "${aws_vpc.clevertap-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" 
    availability_zone = "ap-south-1a"
    tags = {
        Name = "clevertap-subnet-mumbai-1"
    }
}
