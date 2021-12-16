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

if [ "$bal" != "$lastbal" ]; then

        echo $bal >/home/user/ChaChing/walletbalance.chia

        change=$(echo "$bal - $lastbal" | bc)
        title="Chia balance change!"
        alert="Balance changed by $change ${NEWLINE}New balance = ${bal}"
                push "$alert" >> /dev/null

fi

#Check Silicoin Wallet
bal=`docker exec coctohug-silicoin sit wallet show | grep '   .Total Balance:' | cut --fields 6 --delimiter=\ | head -n 1`

        echo "Silicoin - $bal"
        lastbal=`cat /home/user/ChaChing/walletbalance.silicoin`

if [ "$bal" != "$lastbal" ]; then

        echo $bal >/home/user/ChaChing/walletbalance.silicoin

        change=$(echo "$bal - $lastbal" | bc)
        title="Silicoin balance change!"
        alert="Balance changed by $change ${NEWLINE}New balance = ${bal}"
                push "$alert" >> /dev/null
fi

forks="BTCGreen Cactus Chives CryptoDoge Flax Flora HDDCoin Maize NChain StaiCoin STOR"

for fork in ${forks[@]}

do

        lowerfork=`echo $fork | tr '[:upper:]' '[:lower:]'`

bal=`docker exec machinaris-${lowerfork[@]} ${lowerfork[@]} wallet show | grep '   .Total Balance:' | cut --fields 6 --delimiter=\ | head -n 1`

        echo "$fork - $bal"
        lastbal=`cat /home/user/ChaChing/walletbalance.${lowerfork[@]}`

if [ "$bal" != "$lastbal" ]; then

        echo $bal >/home/user/ChaChing/walletbalance.${lowerfork[@]}

        change=$(echo "$bal - $lastbal" | bc)
        title="${fork[@]} balance change!"
        alert="Balance changed by $change ${NEWLINE}New balance = ${bal}"        
                push "$alert" >> /dev/null
fi

done

forks="AEdge Apple Covid Lucky Mint Pipscoin SkyNet Socks Taco Tad Tranzact Venidium Wheat"

for fork in ${forks[@]}

do

        lowerfork=`echo $fork | tr '[:upper:]' '[:lower:]'`

bal=`docker exec coctohug-${lowerfork[@]} ${lowerfork[@]} wallet show | grep '   .Total Balance:' | cut --fields 6 --delimiter=\ | head -n 1`

        echo "$fork - $bal"
        lastbal=`cat /home/user/ChaChing/walletbalance.${lowerfork[@]}`

if [ "$bal" != "$lastbal" ]; then

        echo $bal >/home/user/ChaChing/walletbalance.${lowerfork[@]}

        change=$(echo "$bal - $lastbal" | bc)
        title="${fork[@]} balance change!"
        alert="Balance changed by $change ${NEWLINE}New balance = ${bal}"        
                push "$alert" >> /dev/null
fi

done
