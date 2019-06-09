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


//data "template_file" "web_user_data" {
//  template = "${file("web/user-data/user_data.tpl")}"
//  vars = {
//    index_html = "${filebase64("web/www/index.html")}"
//    info_php = "${filebase64("web/www/info.php")}"
//  }
//}


resource "aws_instance" "jenkins" {
    ami = "${data.aws_ami.jenkins-ubuntu.id}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "m1.small"
    key_name = "${aws_key_pair.generated_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-private-jenkins.id}"
    //associate_public_ip_address = true
    source_dest_check = false
    private_ip = "10.0.2.10"
    iam_instance_profile   = "${aws_iam_instance_profile.ssm_instance_profile.name}"

    //user_data = "${file("web/user-data/user_data.sh")}"
    //user_data = "${data.template_file.web_user_data.rendered}"

    //connection {
    //    host = self.public_ip
    //    type = "ssh"
    //    user = "ubuntu"
    //    private_key = "${file("~/.ssh/terraform_ec2_key")}"
    //}


    //provisioner "remote-exec" {
    //   inline = [
    //     "sudo apt-get update",
    //     "sudo apt-get install apache2 -y",
    //     "sudo systemctl enable apache2",
    //     "sudo systemctl start apache2",
    //     "sudo chmod 777 /var/www/html/index.html",
    //     "sudo touch /var/www/html/logo.png",
    //     "sudo chmod 777 /var/www/html/logo.png"
    //    ]
    // }

     //provisioner "file" {
     //   source = "www/index.html"
     //   destination = "/tmp/index.html"
     //}

     //provisioner "file" {
     //   source = "www/logo.png"
     //   destination = "/tmp/logo.png"
     //}

     //provisioner "file" {
     //   source = "www/info.php"
     //   destination = "/tmp/info.php"
     //}


     //provisioner "remote-exec" {
     //   inline = [
     //   "sudo chmod 644 /var/www/html/index.html"
     //   ]
     //}

     //provisioner "remote-exec" {
     //   inline = [
     //   "sudo chmod 644 /var/www/html/logo.png"
     //   ]
     //}

    tags = {
        Name = "dani-test-jenkins"
    }
}


//resource "aws_eip" "web" {
//    instance = "${aws_instance.web.id}"
//    vpc = true
//}

output "jenkins_ip" {
  value = "${aws_instance.jenkins.public_ip}"
}

output "jenkins_server_private_ip" {
  value = "${aws_instance.jenkins.private_ip}"
}

