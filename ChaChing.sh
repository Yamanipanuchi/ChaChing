#!/bin/bash

source /home/user/ChaChing.cfg

NEWLINE=$'\n'

echo    $(date)

function push {
                curl -s -F "token=$token" \
                -F "user=$user" \
                -F "title=$title" \
                -F "message=$1" https://api.pushover.net/1/messages.json
                }

#Check Chia wallet

bal=`docker exec machinaris chia wallet show | grep '   .Total Balance:' | cut --fields 6 --delimiter=\ | head -n 1`

        echo "Chia - $bal"
        lastbal=`cat /home/user/ChaChing/walletbalance.chia`

#if [ "$bal" != "$lastbal" ]; then

        echo $bal >/home/user/ChaChing/walletbalance.chia
        echo $bal
        echo $lastbal
        change="$bal - $lastbal" | bc -l
        echo $change
        title="Chia balance change!"
        alert="Balance changed by ${change} ${NEWLINE}Balance = ${bal}"
                push "$alert" >> /dev/null

#fi
