resource "aws_key_pair" "generated_key" {
  key_name   = "dani-key-test-2"
  // #public_key = "${tls_private_key.dani_key_test.public_key_openssh}"
  public_key = "${file("~/.ssh/terraform_ec2_key.pub")}"
}
