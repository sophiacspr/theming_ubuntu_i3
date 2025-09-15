#!/bin/bash


# weather display in bar with open-meteo 
# weather browser display with bluemeteo
########## QUERY LOCATION ##########

# get the location, city, country, coordinates from ip
geo=$(curl -s https://ipapi.co/json/)
lat=$(jq -r .latitude <<<"$geo")
lon=$(jq -r .longitude <<<"$geo")
city=$(jq -r .city <<<"$geo")
country=$(jq -r .country_name <<<"$geo")

########## DISPLAY WHEATHER ##########

# query the weather from open-meteo
wx=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,apparent_temperature,weather_code&timezone=auto")

# read temperature
t=$(jq -r '.current.temperature_2m' <<<"$wx")
# read feels like temperatuer
t_feels=$(jq -r '.current.apparent_temperature' <<<"$wx")
# read weather code (type of wheather, like cloudy, sunny,..)
code=$(jq -r '.current.weather_code' <<<"$wx")

# function to convert wheather codes into readible weather strings ("states")
state_from_code() {
  case "$1" in
    0) echo "Sunny" ;;
    1|2) echo "PartlyCloudy" ;;
    3) echo "Cloudy" ;;
    45|48) echo "Fog" ;;
    51|53|55) echo "LightRain" ;;
    61|63|65|80|81|82) echo "HeavyRain" ;;
    71|73|75|77|85|86) echo "HeavySnow" ;;
    95|96|99) echo "ThunderyShowers" ;;
    *) echo "Unknown" ;;
  esac
}

# function to convert states into emojis
emoji_from_state() {
  case "$1" in
    Unknown) echo "✨" ;;
    Cloudy|VeryCloudy) echo "☁️" ;;
    Fog) echo "🌫" ;;
    HeavyRain|HeavyShowers) echo "🌧" ;;
    HeavySnow|HeavySnowShowers) echo "❄️" ;;
    LightRain|LightShowers) echo "🌦" ;;
    LightSleet|LightSleetShowers) echo "🌧" ;;
    LightSnow) echo "🌨" ;;
    LightSnowShowers) echo "🌨" ;;
    PartlyCloudy) echo "⛅️" ;;
    Sunny) echo "☀️" ;;
    ThunderyHeavyRain) echo "🌩" ;;
    ThunderyShowers|ThunderySnowShowers) echo "⛈" ;;
  esac
}

# get current wheather state and emoji
state=$(state_from_code "$code")
icon=$(emoji_from_state "$state")

# output the city, country, weather emoji, temperature (feels: feels_temperature)
printf "%s, %s: %s %+.0f°C (feels %+.0f°C)\n" "$city" "$country" "$icon" "$t" "$t_feels"

########## BUTTON CLICK: OPEN WHEATHER SITE  ##########

SINK=$(pactl get-default-sink)

# get the first entry of the geonames database for the given country and city to identify the geo names id which is needed for the city,country based search in meteoblue
geo_names_id = curl -s "http://api.geonames.org/searchJSON?q=${city}&country=${country}&maxRows=1&username=demo" \
      | jq -r '.geonames[0].geonameId'

# default: use the city_country based version of the page
url="https://www.meteoblue.com/en/weather/week/${city}_${country}_${geo_names_id}"

# check if the webpage works displaying the city and country at the top, not the coordinates
if ! curl -fs --head "$url" >/dev/null; then
	# if not working, then use the coordinates based page
	
	# convert coordinates to needed format
	latdir="N"; (( $(echo "$lat < 0" | bc -l) )) && latdir="S"
	londir="E"; (( $(echo "$lon < 0" | bc -l) )) && londir="W"
	latabs=$(echo $lat | sed 's/-//')
	lonabs=$(echo $lon | sed 's/-//')

	# updated url
	url="https://www.meteoblue.com/en/weather/week/${latabs}${latdir}${lonabs}${londir}"
fi

# open browser
case "$BLOCK_BUTTON" in
    1) xdg-open "$url" >/dev/null 2>&1 & ;;
esac



#### wttr.in alternative for the bar display: seemed too inaccurate 

# weather=$(curl -s "https://wttr.in/?format=%l:+%c+%t+(feels+%f)" | tr -d '\n')
# 
# if [ -z "$weather" ]; then
#     echo "N/A"
# else
#     # sanitize percent signs and quotes for i3bar
#     safe_weather=$(echo "$weather" | sed 's/%/%%/g; s/"/\\"/g')
#     echo "$safe_weather"
# fi
