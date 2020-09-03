#!/bin/bash
#Lerie Taylor / 09-02-20

#count=`wc -l tmp/proxylist |cut -d' ' -f1`
#r=$((RANDOM%${count}));
#host=`cat tmp/proxylist|head -n$r|tail -n1`
#info=( $(echo $host|tr ":" " ") )
#export http_proxy=http://${info[0]}:${info[1]}
#export https_proxy=$http_proxy
#echo "proxy: ${info[0]}:${info[1]}"

cat tmp/proxylist|sort -u >tmp/plist
mv tmp/plist tmp/proxylist

plist=`cat tmp/proxylist`

for proxy in ${plist}
do
	info=( $(echo $proxy|tr ":" " ") )

	echo "setting HTTP proxy"
	export http_proxy=http://${info[0]}:${info[1]}
	export https_proxy=$http_proxy

	echo "digging up bones"
	dig -x ${info[0]} ANY +short >>tmp/digger

	echo "digging up mail recs"
	dig -x ${info[0]} MX +short >>tmp/mail

	echo "Testing: $info"
	result=$(curl -sb -m10 https://api.ipify.org/)

	if [ "$result" = "${info[0]}" ];
	then
		echo "${info[0]}:${info[1]}" >>tmp/saved
	fi
done

echo "removing dupes"
#remove duplicates
cat tmp/saved|sort -u >tmp/saved0
mv tmp/saved0 tmp/saved

echo "uploading proxy file"
#upload proxies to server
curl -X POST -F "proxyfile=@/home/lerie/Downloads/gofish/tmp/proxylist" https://www.lerietaylor.com/proxy.php
