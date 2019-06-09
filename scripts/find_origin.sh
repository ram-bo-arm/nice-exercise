#/bin/bash


wget -q http://$(terraform output web_elb_dns_name)/info.php -O - | grep 10.0.1.1[2-3] | awk -F ">" '{print $5}' | awk -F "<" '{print $1}'
