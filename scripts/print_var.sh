echo
echo "web_server_1_ip = $(terraform output web_server_1_ip)"
echo "web_server_1_private_ip = $(terraform output web_server_1_private_ip)"
echo
echo "web_server_2_ip = $(terraform output web_server_2_ip)"
echo "web_server_2_private_ip = $(terraform output web_server_2_private_ip)"
echo
echo "db_private_ip = $(terraform output db_private_ip)"
echo
echo "jenkins_server_ip = $(terraform output jenkins_server_ip)"
echo "jenkins_server_private_ip = $(terraform output jenkins_server_private_ip)"
echo
echo "nat_ip = $(terraform output nat_ip)"
echo "nat_private_ip = $(terraform output nat_private_ip)"
echo
echo "web_elb_dns = $(terraform output web_elb_dns_name)"
echo
echo "jenkins_elb_dns = $(terraform output jenkins_elb_dns_name)"
echo
