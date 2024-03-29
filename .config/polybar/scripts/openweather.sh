#!/usr/bin/env bash

# Based on: https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/openweathermap-simple

get_icon () {
	case $1 in
		# weather-icons in Nerd fonts
		01d) icon=" ";; # clear sky (day)
		01n) icon=" ";; # clear sky (night)
		02d) icon=" ";; # few clouds (day)
		02n) icon=" ";; # few clouds (night)
		03d) icon=" ";; # scattered clouds (day)
		03n) icon=" ";; # scattered clouds (night)
		04d) icon=" ";; # broken clouds (day)
		04n) icon=" ";; # broken clouds (night)
		09d) icon=" ";; # shower rain (day)
		09n) icon=" ";; # shower rain (night)
		10d) icon=" ";; # rain (day)
		10n) icon=" ";; # rain (night)
		11d) icon=" ";; # thunderstorm (day)
		11n) icon=" ";; # thunderstorm (night)
		13d) icon=" ";; # snow (day)
		13n) icon=" ";; # snow (night)
		50d) icon=" ";; # mist (day)
		50n) icon=" ";; # mist (night)
		*) icon="";
	esac

	echo $icon
}

## '.fqs-secrets' file contains the following variables:
# KEY="openweathermap_api_key_goes_here"
# CITY="where you live"
source "/home/firmanqs/.fqs-secrets.sh"

UNITS="metric"
SYMBOL="°C"

API="https://api.openweathermap.org/data/2.5"

if [ -n "$CITY" ]; then
	if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
		CITY_PARAM="id=$CITY"
	else
		CITY_PARAM="q=$CITY"
	fi

	weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
else
	location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

	if [ -n "$location" ]; then
		location_lat="$(echo "$location" | jq '.location.lat')"
		location_lon="$(echo "$location" | jq '.location.lng')"

		weather=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
	fi
fi

if [ -n "$weather" ]; then
	weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
	weather_icon=$(echo "$weather" | jq -r ".weather[0].icon")

	echo "$(get_icon "$weather_icon")  $weather_temp$SYMBOL"
fi
