echo
echo "web_server_1_ip = $(terraform output web_server_1_ip)"
echo "web_server_1_private_ip = $(terraform output web_server_1_private_ip)"
echo
echo "web_server_2_ip = $(terraform output web_server_2_ip)"
echo "web_server_2_private_ip = $(terraform output web_server_2_private_ip)"
echo
echo "db_private_ip = $(terraform output db_private_ip)"
echo
echo "nat_ip = $(terraform output nat_ip)"
echo "nat_private_ip = $(terraform output nat_private_ip)"
echo
echo "elb_dns = $(terraform output elb_dns_name)"
echo
