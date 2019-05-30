ssh  -i ~/.ssh/terraform_ec2_key ec2-user@$(terraform output nat_ip)
