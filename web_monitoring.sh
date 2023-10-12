#!/bin/bash

check_url_reachability() {
    url="$1"
    timestamp=$(date "+%a %d %b %Y %r %Z")
 
    if wget -q --spider "$url"; then
        echo "$timestamp, $url, REACHABLE"
    else
        echo "$timestamp, $url, UNREACHABLE (wget: $?)"
    fi
}


CONFIG_FILE="config.yaml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi


monitorInterval=$(yq eval '.TimeInterval' "$CONFIG_FILE")
urls=$(yq eval '.urls[]' "$CONFIG_FILE")


while true; do
    for url in $urls; do
        check_url_reachability "$url"
    done
    if [ -n "$monitorInterval" ]; then
        sleep "$monitorInterval"
    else
        echo "Invalid TimeInterval in the configuration file."
        exit 1
    fi
done