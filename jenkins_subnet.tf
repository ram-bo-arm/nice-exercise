/*
  Private Jenkins Subnet
*/
resource "aws_subnet" "eu-west-1a-private-jenkins" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_jenkins_subnet_cidr}"
    availability_zone = "${var.aws_availability_zone}"
    count = "${var.jenkins_instance_count > 0 ? 1 : 0}"

    tags = {
        Name = "dani-test-private-jenkins-subnet"
    }
}

resource "aws_route_table" "eu-west-1a-private-jenkins" {
    vpc_id = "${aws_vpc.default.id}"
    count = "${var.jenkins_instance_count > 0 ? 1 : 0}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags = {
        Name = "dani-test-private-jenkins-route"
    }
}


resource "aws_route_table_association" "eu-west-1a-private-jenkins" {
    subnet_id = "${aws_subnet.eu-west-1a-private-jenkins[0].id}"
    route_table_id = "${aws_route_table.eu-west-1a-private-jenkins[0].id}"
    count = "${var.jenkins_instance_count > 0 ? 1 : 0}"
}



