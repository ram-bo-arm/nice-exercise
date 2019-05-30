#/bin/bash


wget -q http://$(terraform output elb_dns_name)/info.php -O - | grep 10.0.0.[1-2] | awk -F ">" '{print $5}' | awk -F "<" '{print $1}'
