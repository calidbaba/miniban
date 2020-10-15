#!/bin/bash

declare -A IPADDR

if [[ "$USER" != "root" ]]; then
    echo "You must be root to run this program" 1>&2
    exit
fi

trap 'kill $(jobs -p)' EXIT 

update(){
    while IFS="," read IP TIMESTAMP; do
        if [ -z $IP ]; then
            break
        fi

        TIME=$(date +%s)
        SEC=$((TIME - TIMESTAMP))
        MIN=$((SEC/60))
        if [ $MIN -ge 10 ]; then 
            ./unban.sh $IP
            echo "feck ye"
        fi
        sleep 10
    done < miniban.db
    #sleep 30

}
#(while true; do update; sleep 30; done;) &
(while true; do update; done) &

#ban greiene 
journalctl -f -u ssh -n 0 | grep Failed --line-buffered | grep --line-buffered -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | while read IP; do 
    
    IPADDR["$IP"]=$(( IPADDR["$IP"] += 1 ))
    
    echo "i have seen $IP ${IPADDR["$IP"]} times" 
    
    if [[ ${IPADDR["$IP"]} > 2 ]];then 
        echo "$IP er skrt" 
        IPADDR["$IP"]=0
        #her legger man inn ban
        ./ban.sh $IP
    fi
done

