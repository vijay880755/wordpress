resource "aws_internet_gateway" "clevertap-igateway" {
    vpc_id = "${aws_vpc.clevertap-vpc.id}"
    tags {
        Name = "clevertap-igw"
    }
}

resource "aws_route_table" "clevertap-routetable" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.clevertap-igateway.id}" 
    }
    
    tags {
        Name = "clevertap-routetable"
    }
}

resource "aws_route_table_association" "clevertap-rta-1"{
    subnet_id = "${aws_subnet.clevertap-subnet-1.id}"
    route_table_id = "${aws_route_table.clevertap-routetable.id}"
}


resource "aws_route_table_association" "clevertap-rta-2"{
    subnet_id = "${aws_subnet.clevertap-subnet-2.id}"
    route_table_id = "${aws_route_table.clevertap-routetable.id}"
}
