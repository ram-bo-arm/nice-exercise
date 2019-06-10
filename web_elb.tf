resource "aws_elb" "web" {
  name = "example-web-elb"

  # The same availability zone as our instance
  subnets = ["${aws_subnet.eu-west-1a-public.id}"]

  security_groups = ["${aws_security_group.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.web[0].id}","${aws_instance.web[1].id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  count = "${var.web_instance_count > 0 ? 1 : 0}"

    tags = {
        Name = "dani-web-elb"
    }

}

output "web_elb_dns_name" {
  value = "${aws_elb.web[0].dns_name}"
}


