#!/bin/bash

speed_unit="mph"
temp_unit="fahrenheit"
precip_unit="inch"

# lat=$( curl -s https://ipapi.co/json | jq '.latitude' | sed 's/[^0-9.-]//g' )
# long=$( curl -s https://ipapi.co/json | jq '.longitude' | sed 's/[^0-9.-]//g' )
lat="35.3267"
long="-97.3534"

curlreq="https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current=temperature_2m,weather_code&wind_speed_unit=$speed_unit&temperature_unit=$temp_unit&precipitation_unit=$precip_unit"

if [ "$lat" != "" ]; then
	weatherres=$( curl -s $curlreq )

	code=$( echo $weatherres | jq '.current.weather_code' | sed 's/[^0-9.]//g' )
	temp=$( echo $weatherres | jq '.current.temperature_2m' | sed 's/[^0-9.]//g' )


	case "$code" in
		0) icon="clear" ;;  # Clear sky
		1|2|3) icon="partlycloudy" ;;  # Partly cloudy
		4) icon="overcast" ;;  # Overcast
		10|11|12|45|49) icon="fog" ;;  # Fog
		60|61|63|65|80|81|82) icon="rain" ;;  # Rain
		66|67) icon="freezingrain" ;;  # Freezing rain
		70|71|73|75|77|85|86) icon="snow" ;;  # Snow
		95|96|99) icon="thunderstorm" ;;  # Thunderstorm
		*) icon="unknown" ;;  # Unknown / N/A
	esac

	jq -nc \
		--arg text "$temp" \
		--arg icon "$icon" \
        '{text: $text, icon: $icon}'
else
	jq -nc \
		--arg text "?" \
		--arg icon "" \
        '{text: $text, icon: $icon}'
fi
