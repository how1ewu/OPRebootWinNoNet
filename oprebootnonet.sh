#!/bin/bash

DATE=`date +%Y-%m-%d-%H:%M:%S`
ping_failure=0
ip_list="119.29.29.29,223.5.5.5"
ips=$(echo "$ip_list" | tr ',' ' ')
for ip in $ips
do
    if /bin/ping -c 1 "$ip" >/dev/null
    then
        echo "The network connection is normal, enjoy~"
        echo "---close script---"
        exit 0
    fi
done
ping_failure=$((ping_failure+1))
while [[ $ping_failure -le 15 ]]; do
    echo $DATE network offline, Ping count: $ping_failure >>ping_watchdog.log
    sleep 60
    for ip in $ips
    do
        if /bin/ping -c 1 "$ip" >/dev/null
        then
            echo "The network connection is normal, enjoy~"
            echo "---close script---"
            exit 0
        fi
    done
    ping_failure=$((ping_failure+1))
done
if [[ $ping_failure -ge 15 ]]; then
    echo "Restart count: $ping_failure"
    echo $DATE reboot >>ping_watchdog.log
    reboot
