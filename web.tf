# Get the AWS Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "template_file" "web_user_data" {
  template = "${file("www/user_data.tpl")}"
  vars = {
    index_html = "${filebase64("www/index.html")}"
    info_php = "${filebase64("www/info.php")}"
  }
}


resource "aws_instance" "web" {
    //ami = "${lookup(var.amis, var.aws_region)}"
    ami = "${data.aws_ami.ubuntu.id}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "m1.small"
    key_name = "${aws_key_pair.generated_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-private.id}"
    //associate_public_ip_address = true
    source_dest_check = false
    private_ip = "10.0.1.1${count.index + 2}"
    count = "${var.web_instance_count}"

    //user_data = "${file("www/user_data.sh")}"
    user_data = "${data.template_file.web_user_data.rendered}"

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
        Name = "dani-test-ws-${count.index + 1}"
    }
}


//resource "aws_eip" "web" {
//    instance = "${aws_instance.web.id}"
//    vpc = true
//}

output "web_server_1_ip" {
  value = "${aws_instance.web[0].public_ip}"
}

output "web_server_1_private_ip" {
  value = "${aws_instance.web[0].private_ip}"
}


output "web_server_2_ip" {
  value = "${aws_instance.web[1].public_ip}"
}

output "web_server_2_private_ip" {
  value = "${aws_instance.web[1].private_ip}"
}
