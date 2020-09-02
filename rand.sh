#!/bin/bash

#check if we have an argument
if [ "$#" -ne 1 ]; then
	echo "Please specfiy a number of random target (ex; 10)"
	exit
fi

if [[ ^[0-9]+$ ]]; then
	ports=`cat tmp/ports`
	nmap --open -p${ports} -oG - -vv -iR $1
fi
