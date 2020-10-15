#!/bin/bash

if [[ $USER != "root" ]]; then
    echo "you must be root" 1>&2
    exit
fi

IPADDR="$1"
#checking if user has sublied an argument
if [[ -z "$IPADDR" ]]; then
    echo "usage: $0 <ip address>" 1>&2
    exit
fi

#banning unbanning ip address
$(iptables -D INPUT -s $IPADDR -p tcp --dport ssh -j DROP)

#oppdaterer databasen
grep -v $IPADDR miniban.db > "temp" 
mv "temp" "miniban.db" 

echo $IPADDR




