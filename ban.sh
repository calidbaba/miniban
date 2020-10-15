#!/bin/bash

if [[ $USER != "root" ]]; then 
    echo "you must be root"
    exit
fi

IPADDR="$1"
#checking if user has sublied an argument
if [[ -z "$IPADDR" ]]; then
    echo "usage: $0 <ip address>" 1>&2
    exit
fi

CHECK=$(grep $IPADDR whitelist.db)
if [[ -z $CHECK ]];then
    #banning ip adress using iptables
    $(iptables -A INPUT -s $IPADDR -p tcp --dport ssh -j DROP)


    #update database
    echo "$IPADDR,$(date +%s)" >> miniban.db 
else
    echo "$IPADDR is whitelisted"
fi

