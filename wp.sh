#!/bin/bash
# Lerie Taylor

#find some web servers. maybe.
#nmap -vv --open -p80 -iR 100 -oG - >>tmp/wp

sites=`cat tmp/wp|tr ":" "-"`
iplist=`echo $sites|grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}'`

for ip in $iplist
do
	echo $ip
	#dig it up
	#dig -x $ip ANY +short

	#check for wp
	#curl -o "wp/$ip" -v "https://$ip/wp-json/"
done
