#!/bin/bash

# $home_directory  - will be supplied by install.sh

# Directory to search in
search_directory="$home_directory/.config/discord"

# Regular expression for version number (e.g., 1.2.3)
version_regex='[0-9]+\.[0-9]+\.[0-9]+'

# Find the newest version directory
newest_version=$(basename $(find "$search_directory" -type d -regextype posix-extended -regex ".*/$version_regex" | sort -Vr | head -n 1))
# URL for the GET request
url="https://discord.com/api/download?platform=linux&format=deb"
# Perform the GET request and capture headers without following redirect
headers=$(curl -s -D - -o /dev/null "$url")
# Extract the Location header
location=$(echo "$headers" | grep -i "Location:" | cut -d " " -f 2)
# Trim any newlines or whitespace
location=$(echo $location | tr -d '\r\n')
new_version=$(echo "$location" | xargs basename)
new_version=${new_version%.deb}
new_version=${new_version//discord-}
if [[ "$new_version" == "$newest_version" ]]; then
    echo "Discord already latest version."
else
    echo "New version of discord available: $new_version, downloading..."
    echo "$location"
        download_path="/tmp/$(basename $location)"
    curl -o "$download_path" "$location"
    sudo dpkg -i $download_path
    rm $download_path
fi	    

