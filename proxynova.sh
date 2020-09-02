RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
BLU='\033[0;34m'
WHT='\033[0;37m'
NC='\033[0m'

echo -e "${YLW}[${WHT}=${YLW}]${NC} truncating"
truncate -s0 tmp/ports0 tmp/proxylist

echo -e "${YLW}[${BLU}=${YLW}]${NC} fetching"
curl -s -o tmp/proxynova "https://www.proxynova.com/proxy-server-list/country-us/"; cat tmp/proxynova |grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' >tmp/proxies0

echo -e "${YLW}[${RED}-${YLW}]${NC} removing dupes"
cat tmp/proxies0 |uniq -u >tmp/proxies

echo -e "${YLW}[${RED}-${YLW}]${NC} removing empty lines"
sed -i '/^$/d' tmp/proxynova

echo -e "${YLW}[${RED}-${YLW}]${NC} removing spaces"
sed -i 's/ //g' tmp/proxynova

echo -e "${YLW}[${WHT}=${YLW}]${NC} stuffing ports"
ports=`cat tmp/proxynova|grep -Eo '^[[:digit:]]{1,5}'`

echo -e "${YLW}[${WHT}=${YLW}]${NC} merging ports and ip addresses"
c=1;for i in ${ports};do echo -e "${YLW}[${RED}=${YLW}]${NC} parsing ${GRN}${proxy}${NC}"; proxy=`head -n$c tmp/proxies|tail -n1`;echo "$proxy:$i" >>tmp/proxylist; echo $i>>tmp/ports0; c=$((c+1));done

echo -e "${YLW}[${RED}-${YLW}]${NC} removing dupes"
sort -u tmp/ports0 >tmp/ports1

echo -e "${YLW}[${WHT}=${YLW}]${NC} formatting ports"
sed -z 's/\n/,/g' tmp/ports1|sed '$ s/.$//'>tmp/ports

echo -e "${YLW}[${WHT}=${YLW}]${NC} cleaning up"
rm tmp/ports0 tmp/proxynova tmp/proxies0 tmp/ports1

echo -e "${YLW}[${BLU}=${YLW}]${NC} scanning"
for i in `cat tmp/proxies`
do
	echo -e "${YLW}[${BLU}-${YLW}]${NC} scanning: ${GRN}${i}${NC}"
	nmap -oG "scans/${i}.xml" -p`cat tmp/ports` --open ${i} >/dev/null 2>&1
done
