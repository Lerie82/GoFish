#!/bin/bash
# Lerie Taylor
sites=`cat tmp/wp|tr ":" "-"`
iplist=`echo $sites|grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}'`

for ip in $iplist
do
	#dig it up
	#dig -x $ip ANY +short

	#check for wp
	curl -v "https://$ip/wp-json/"
done
