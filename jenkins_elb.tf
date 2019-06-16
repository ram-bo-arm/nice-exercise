resource "aws_elb" "jenkins" {
  name = "example-jenkins-elb"

  # The same availability zone as our instance
  subnets = ["${aws_subnet.eu-west-1a-public.id}"]

  security_groups = ["${aws_security_group.jenkins_elb[0].id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # https://stackoverflow.com/questions/23689333/how-to-instruct-an-aws-elb-to-consider-a-health-check-that-returns-a-403-code-as
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/login"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.jenkins[0].id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  count = "${var.jenkins_instance_count > 0 ? 1 : 0}"

  tags = {
      Name = "dani-jenkins-elb"
  }

}

output "jenkins_elb_dns_name" {
  value = "${aws_elb.jenkins[0].dns_name}"
}


