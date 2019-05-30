#eval `ssh-agent -s`
#ssh-add -k ~/.ssh/terraform_ec2_key
ssh  -i ~/.ssh/terraform_ec2_key ubuntu@$(terraform output web_server_ip)
