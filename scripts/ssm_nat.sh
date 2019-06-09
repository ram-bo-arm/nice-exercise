#!/bin/bash


filter_1="Name=tag:Name,Values=dani-test-nat"
filter_2="Name=instance-state-name,Values=running"

instance_id=$(aws ec2 describe-instances --filters "$filter_1" "$filter_2" --output text --query 'Reservations[*].Instances[*].InstanceId')

aws ssm start-session --target $instance_id

