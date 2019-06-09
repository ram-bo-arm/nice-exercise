/*
  Private Web Subnet
*/
resource "aws_subnet" "eu-west-1a-private-web" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_web_subnet_cidr}"
    availability_zone = "${var.aws_availability_zone}"

    tags = {
        Name = "dani-test-private-web-subnet"
    }
}

resource "aws_route_table" "eu-west-1a-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags = {
        Name = "dani-test-private-web-route"
    }
}

resource "aws_route_table_association" "eu-west-1a-private-web" {
    subnet_id = "${aws_subnet.eu-west-1a-private-web.id}"
    route_table_id = "${aws_route_table.eu-west-1a-private.id}"
}



