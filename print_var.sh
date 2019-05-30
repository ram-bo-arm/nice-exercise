echo
echo "web_server_ip = $(terraform output web_server_ip)"
echo "web_server_private_ip = $(terraform output web_server_private_ip)"
echo
echo "db_private_ip = $(terraform output db_private_ip)"
echo
echo "nat_ip = $(terraform output nat_ip)"
echo "nat_private_ip = $(terraform output nat_private_ip)"
echo
echo "jenkins_server_ip = $(terraform output jenkins_server_ip)"
echo "jenkins_server_private_ip = $(terraform output jenkins_server_private_ip)"
echo
echo "elb_ip = $(terraform output elb_ip)"
echo
#echo " = $(terraform output )"
