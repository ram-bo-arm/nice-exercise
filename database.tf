/*
  Database Servers
*/
resource "aws_security_group" "db" {
    name = "vpc_db"
    description = "Allow incoming database connections."

    ingress { # SQL Server
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }
    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.vpc_cidr}"]
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
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags = {
        Name = "dani-test-sg-private"
    }
}

resource "aws_network_interface" "db" {
  subnet_id = "${aws_subnet.eu-west-1a-private.id}"
  private_ips = ["10.0.1.244"]
  tags = {
    Name = "dani-test-db-network-interface"
  }
}

resource "aws_instance" "db-1" {
    //ami = "${lookup(var.amis, var.aws_region)}"
    ami = "${data.aws_ami.ubuntu.id}"
    availability_zone = "eu-west-1a"
    instance_type = "m1.small"
    key_name = "${aws_key_pair.generated_key.key_name}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-private.id}"
    source_dest_check = false 
    private_ip = "10.0.1.10"

    //network_interface {
    //   network_interface_id = "${aws_network_interface.db.id}"
    //   device_index = 0
    //}

    user_data = <<-EOF
		#!/bin/bash
		sudo apt-get update
		sudo apt-get install -y traceroute
		# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
		echo "mysql-server-5.7 mysql-server/root_password password root" | sudo debconf-set-selections
		echo "mysql-server-5.7 mysql-server/root_password_again password root" | sudo debconf-set-selections
		sudo apt-get -y install mysql-server-5.7
		sudo systemctl enable mysql

		echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf
		echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/my.cnf
		echo "skip-grant-tables" | sudo tee -a /etc/mysql/my.cnf

		sudo systemctl restart mysql

		#export DEBIAN_FRONTEND=noninteractive    
		#sudo -E apt-get -q -y install mysql-server-5.7
                EOF

    tags = {
        Name = "dani-test-db"
    }
}

output "db_private_ip" {
  value = "${aws_instance.db-1.private_ip}"
}

