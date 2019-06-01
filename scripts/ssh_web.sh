#eval `ssh-agent -s`
#ssh-add -k ~/.ssh/terraform_ec2_key

if [ "$1" = "1" ] | [ "$1" = "2" ]
then
	index=$1
else
	index=1
fi


ssh  -i ~/.ssh/terraform_ec2_key ubuntu@$(terraform output web_server_${index}_ip)
eval `ssh-agent -s`
ssh-add -k ~/.ssh/terraform_ec2_key

echo "connecting thru bastion (public) $(terraform output nat_ip) to db server (private) $(terraform output web_server_${index}_private_ip)"

ssh  -t -A -i ~/.ssh/terraform_ec2_key ec2-user@$(terraform output nat_ip) "ssh ubuntu@$(terraform output web_server_${index}_private_ip)"
