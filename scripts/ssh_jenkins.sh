#eval `ssh-agent -s`
#ssh-add -k ~/.ssh/terraform_ec2_key

if [ "$1" = "1" ] | [ "$1" = "2" ]
then
	index=$1
else
	index=1
fi


ssh  -i ~/.ssh/terraform_ec2_key ubuntu@$(terraform output jenkins_server_ip)
eval `ssh-agent -s`
ssh-add -k ~/.ssh/terraform_ec2_key

echo "connecting thru bastion (public) $(terraform output nat_ip) to jenkins (private) $(terraform output jenkins_server_private_ip)"

ssh  -t -A -o StrictHostKeyChecking=no -i ~/.ssh/terraform_ec2_key ec2-user@$(terraform output nat_ip) "ssh ubuntu@$(terraform output jenkins_server_private_ip)"
