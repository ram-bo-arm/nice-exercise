resource "aws_instance" "db-1" {
    //ami = "${lookup(var.amis, var.aws_region)}"
    ami = "${data.aws_ami.ubuntu.id}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "m1.small"
    key_name = "${aws_key_pair.generated_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-private-web.id}"
    source_dest_check = false 
    private_ip = "10.0.1.10"
    iam_instance_profile   = "${aws_iam_instance_profile.ssm_instance_profile.name}"

    user_data = "${file("database/user_data.sh")}"

    tags = {
        Name = "dani-test-db"
    }
}

output "db_private_ip" {
  value = "${aws_instance.db-1.private_ip}"
}

