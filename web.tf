/*
  Web Servers
*/
resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # SQL Server
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    egress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }


    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags = {
        Name = "dani-test-sg-public"
    }
}

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


resource "aws_instance" "web-1" {
    //ami = "${lookup(var.amis, var.aws_region)}"
    ami = "${data.aws_ami.ubuntu.id}"
    availability_zone = "eu-west-1a"
    instance_type = "m1.small"
    //key_name = "${var.aws_key_name}"
    key_name = "${aws_key_pair.generated_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    connection {
	host = self.public_ip
       type = "ssh"
       user = "ubuntu"
       private_key = "${file("~/.ssh/terraform_ec2_key")}"
    }

    user_data = <<-EOF
		#!/bin/bash
		sudo apt-get update
		sudo apt-get install -y traceroute
		sudo apt-get install -y apache2
		sudo apt-get install -y php libapache2-mod-php php-mysql
		sudo apt-get install -y libssh2-1 php-ssh2
		sudo systemctl enable apache2
		sudo systemctl restart apache2
		sudo cp /tmp/index.html /var/www/html/index.html
		sudo cp /tmp/info.php /var/www/html/info.php
		#sudo chmod 777 /var/www/html/index.html
		#sudo touch /var/www/html/logo.png
		#sudo chmod 777 /var/www/html/logo.png
		sudo cp /tmp/logo.png /var/www/html/logo.png
                EOF

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

     provisioner "file" {
        source = "index.html"
        destination = "/tmp/index.html"
     }

     provisioner "file" {
        source = "logo.png"
        destination = "/tmp/logo.png"
     }

     provisioner "file" {
        source = "info.php"
        destination = "/tmp/info.php"
     }


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
        Name = "dani-test-ws"
    }
}


//resource "aws_eip" "web-1" {
//    instance = "${aws_instance.web-1.id}"
//    vpc = true
//}

output "web_server_ip" {
  value = "${aws_instance.web-1.public_ip}"
}

output "web_server_private_ip" {
  value = "${aws_instance.web-1.private_ip}"
}
