eval `ssh-agent -s`
ssh-add -k ~/.ssh/terraform_ec2_key

echo "connecting thru bastion (public) $(terraform output nat_ip) to db server (private) $(terraform output db_private_ip)"

#ssh  -t -A -i ~/.ssh/terraform_ec2_key ubuntu@$(terraform output web_server_1_ip) "ssh ubuntu@$(terraform output db_private_ip)"
ssh  -t -A -i ~/.ssh/terraform_ec2_key ec2-user@$(terraform output nat_ip) "ssh ubuntu@$(terraform output db_private_ip)"
