ssh -i ~/.ssh/terraform_ec2_key ubuntu@$(terraform output jenkins_server_ip)
