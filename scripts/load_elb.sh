#!/bin/bash
for i in {1..10}
do
	echo $1
   ./scripts/find_origin.sh &
done
