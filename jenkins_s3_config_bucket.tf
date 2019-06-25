data "aws_s3_bucket" "jenkins_config" {
  bucket = "dani-test-jenkins"
}

resource "aws_s3_bucket_policy" "jenkins_config" {
  bucket = "${data.aws_s3_bucket.jenkins_config.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "jenkins_config_bucket_policy",
  "Statement": [
    {
       "Effect": "Allow",
       "Principal": { "AWS": "${aws_iam_role.jenkins_master_role.arn}" } ,
       "Action": "s3:GetObject",
       "Resource": "arn:aws:s3:::dani-test-jenkins/config/*"  
    },
    {
       "Effect": "Allow",
       "Principal": { "AWS": "${aws_iam_role.jenkins_master_role.arn}" } ,
       "Action": "s3:PutObject",
       "Resource": "arn:aws:s3:::dani-test-jenkins/config/jenkins_token"
    }
  ]
}
POLICY
}
