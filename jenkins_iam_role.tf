resource "aws_iam_role" "jenkins_master_role" {
  name = "jenkins_master_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
     {
        "Action": "sts:AssumeRole",
         "Principal": {
         "Service": "ec2.amazonaws.com"
         },
         "Effect": "Allow",
         "Sid": ""
     }
    ]
}
EOF
}

resource "aws_iam_policy" "jenkins_master_policy" {
  name        = "jenkins-master-policy"
  description = "jenkins master policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "jenkins_master_policy_attach" {
  role       = "${aws_iam_role.jenkins_master_role.name}"
  policy_arn = "${aws_iam_policy.jenkins_master_policy.arn}"
}

resource "aws_iam_instance_profile" "jenkins_master_iam_instance_profile" {
  name = "jenkins_master_iam_instance_profile"
  role = "${aws_iam_role.jenkins_master_role.name}"
}

