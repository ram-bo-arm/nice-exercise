#!/bin/bash


if [ "$1" = "1" ] | [ "$1" = "2" ]
then
        index=$1
else
        index=1
fi

filter_1="Name=tag:Name,Values=dani-test-ws-"$index
filter_2="Name=instance-state-name,Values=running"

instance_id=$(aws ec2 describe-instances --filters "$filter_1" "$filter_2" --output text --query 'Reservations[*].Instances[*].InstanceId')

aws ssm start-session --target $instance_id

