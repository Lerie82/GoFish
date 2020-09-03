RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
BLU='\033[0;34m'
WHT='\033[0;37m'
NC='\033[0m'

truncate -s0 tmp/proxyslist
countries=(`cat tmp/countries`)

for i in "${countries[@]}"
do
	echo -e "${YLW}[${BLU}=${YLW}]${NC} fetching: ${GRN}$i${NC}"
	curl -s "http://proxyslist.com/country/$i" >>tmp/proxyslist
done

echo -e "${YLW}[${RED}-${YLW}]${NC} removing spaces"
sed -i 's/ //g' tmp/proxyslist

echo -e "${YLW}[${RED}-${YLW}]${NC} removing newlines"
sed -i 's/^$//g' tmp/proxyslist

echo -e "${YLW}[${WHT}=${YLW}]${NC} searching"
cat tmp/proxyslist |grep -Eo "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}:[[:digit:]]{1,5}" >>tmp/proxylist

echo -e "${YLW}[${RED}-${YLW}]${NC} sorting, removing dupes"
sort -u tmp/proxylist >tmp/proxylist0

mv tmp/proxylist0 tmp/proxylist
echo -e "${YLW}[${WHT}=${YLW}]${NC} cleaning up"
