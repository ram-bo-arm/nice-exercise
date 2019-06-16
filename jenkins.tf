data "aws_ami" "jenkins-ubuntu" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Name"
    values = ["dani-test-jenkins-ami"]
  }
  most_recent = true
   owners = ["self"]
}

data "aws_ami" "jenkins-slave-ubuntu" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Name"
    values = ["dani-test-jenkins-slave-ami"]
  }
  most_recent = true
   owners = ["self"]
}


data "template_file" "jenkins_yaml" {
  template = "${file("jenkins/ami/master/config/jenkins.yaml.tpl")}"
  vars = {
    jenkins_subnet_id = "${aws_subnet.eu-west-1a-private-jenkins[0].id}"
    jenkins_slave_ami = "${data.aws_ami.jenkins-slave-ubuntu.id}"
  }
}


data "template_file" "jenkins_user_data" {
  template = "${file("jenkins/ami/master/user-data/user_data.tpl")}"
  vars = {
    jenkins_yaml = "${base64encode(data.template_file.jenkins_yaml.rendered)}"
  }
}

resource "aws_instance" "jenkins" {
    ami = "${data.aws_ami.jenkins-ubuntu.id}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "m1.small"
    key_name = "${aws_key_pair.generated_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.jenkins[0].id}"]
    subnet_id = "${aws_subnet.eu-west-1a-private-jenkins[0].id}"
    //associate_public_ip_address = true
    source_dest_check = false
    private_ip = "10.0.2.10"
    iam_instance_profile   = "${aws_iam_instance_profile.jenkins_master_iam_instance_profile.name}"
    count = "${var.jenkins_instance_count}"
    user_data = "${data.template_file.jenkins_user_data.rendered}"

    tags = {
        Name = "dani-test-jenkins"
    }
}


//resource "aws_eip" "web" {
//    instance = "${aws_instance.web.id}"
//    vpc = true
//}

output "jenkins_ip" {
  value = "${aws_instance.jenkins[0].public_ip}"
}

output "jenkins_server_private_ip" {
  value = "${aws_instance.jenkins[0].private_ip}"
}

