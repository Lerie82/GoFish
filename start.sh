RED='\033[0;31m'
YLW='\033[0;33m'
NC='\033[0m'

#start fetching proxies
if [ $# -lt 1 ];
then
	echo -e "${YLW}Example${NC}: $0 [ all|nova|rand ]"
	echo -e "\t${YLW}-${NC} all: will execute all the proxy fetching scripts"
	echo -e "\t${YLW}-${NC} nova: fetch proxies from proxynova.com"
	echo -e "\t${YLW}-${NC} rand [${RED}n${NC}]: scan ${RED}n${NC} random IPs"
fi

case $1 in
	all)
		./proxynova.sh &
		./fetchprox.sh &
	;;
	nova)
		./proxynova.sh
	;;
	rand)
		if [ $# -lt 2 ];
		then
			echo -e "[${RED}MISSING ARG${NC}] You need to supply an integer with the ${GRN}rand${NC} argument"
			exit
		fi

		./rand.sh $2
	;;
	randir)
		./prox.sh
	;;
esac
