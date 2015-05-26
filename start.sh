#!/bin/sh

# ingress-ice start script by Nikitakun
# From version 2.2 you don't need to edit anything if you are using linux. Visit http://github.com/nibogd/ingress-ice for help or just launch this script
FILE="$HOME/.ingress_ice"

echo_will_help() {
	echo "Ingress ICE\n\nUsage:"
	echo "  ingress-ice -h | --help" 
	echo "  ingress-ice -c | --reconfigure"
	echo "  ingress-ice -a"
	echo "\nOptions:"
	echo "  -h --help            Show this help"
	echo "  -c --reconfigure     Rewrite existing config file with a new one"
	echo "  -a                   Show authors"
	echo "\nPlease visit http://ingress.divshot.io/ or http://github.com/nibgd/ingress-ice for additional help\n"
	exit;
}

user_input() {
	clear
	while true; do
		echo "To get your location link:"
		echo "  1) Go to http://ingress.com/intel"
		echo "  2) Scroll the map to your location and zoom"
		echo "  3) Click the [Link] button on the right top of the screen and copy that link\n"
		echo "Enter your location link: "
		read LINK
		if [ -z "$LINK" ]; then
			echo "Cannot be blank."
		else
			break;
		fi
	done
	while true; do
		echo "\nYour Google login: "
		read EMAIL
		[ -z "$EMAIL" ] && echo "Cannot be blank." || break;
	done
	while true; do
		echo "\nYour Google password: (not shown) "
		stty -echo
		read PASSWORD
		stty echo
		[ -z "$PASSWORD" ] && echo "\nCannot be blank." || break;
	done
	echo "\nDelay between screenshots in seconds: ([ENTER] for default (120)) "
	read DELAY
	echo "\nMinimal portal level: (1) "
	read MIN_LEVEL
	echo "\nMaximum portal level: (8) "
	read MAX_LEVEL
	echo "\nScreenshots' width in pixels: (900) "
	read WIDTH
	echo "\nScreenshots' height: (500) "
	read HEIGHT
	echo "\nNumber of screenshots to take, '0' for infinity: (0) "
	read NUMBER
	
	DELAY=${DELAY:-'120'}
	MIN_LEVEL=${MIN_LEVEL:-'1'}
	MAX_LEVEL=${MAX_LEVEL:-'8'}
	WIDTH=${WIDTH:-'900'}
	HEIGHT=${HEIGHT:-'500'}
	NUMBER=${NUMBER:-'0'}
	clear
	echo "Google login: $EMAIL"
	echo "Portals level from $MIN_LEVEL to $MAX_LEVEL"
	echo "Take $NUMBER (0 = infinity) screenshots $WIDTH x $HEIGHT every $DELAY seconds"
	echo "\nAre options entered correct? (Y/n)"
	while true; do
	    read yn
	    case $yn in
	        [Yy]* ) echo "Writing to file..."; echo "$EMAIL $PASSWORD $LINK $MIN_LEVEL $MAX_LEVEL $DELAY $WIDTH $HEIGHT ./ $NUMBER 3" > $FILE && echo "Config file created successfully. Start ICE again to begin screesnshooting.\nIf you need additional help, visit http://ingress.divshot.io/"; exit;;
	        [Nn]* ) user_input; break;;
	        * ) echo "Please answer y(es) or n(o).";;
	    esac
	done
}

for arg
do
    case "$arg" in
    	"--help" ) echo_will_help;;
    	"-h" ) echo_will_help;;
	"--reconfigure" ) user_input; break;;
	"-c" ) user_input; break;;
	"-a" ) echo "Ingress ICE (Distributed under the MIT License)\n\nAuthors:\n  Nikitakun (http://github.com/nibogd) @ni_bogd\n";exit;;
    esac
done

if [ -f "$FILE" ]
then
	clear
	echo "Existing config found found. Starting ice..."
	ARGS=`cat $FILE`
	./phantomjs ice.js $ARGS; exit;;
else
	while true; do
	    read -p "Ingress ICE, Automatic screenshooter for ingress intel map\nConfig file not found. Create one? (y/n) " yn
	    case $yn in
	        [Yy]* ) user_input; break;;
	        [Nn]* ) clear;echo "Config file is mandatory. Exiting…"; exit;;
	        * ) echo "Please answer y(es) or n(o).";;
	    esac
	done
fi
