#!/bin/bash

free_account=
free_pass=
time_sleep=5
time_sleep_after=300
log=/tmp/kmtesteur.log

echo "Log enregistré dans $log"

while true
do
  date
  date >> $log
  wget -O - "https://ws.ovh.com/dedicated/r2/ws.dispatcher/getAvailability2" 2>> $log | tr "{" "\n" | sed -n '/142sk1/{n;p;n;p;n;p;n;p}' | grep -v unavailable > /dev/null
  if [ $? -eq 0 ]
  then
    echo "Quelque chose !"
    echo "Quelque chose !" >> $log
    
    notify-send "Alerte !" "Il y a un KimSufi !!!"
    
    if [ ! -z "$free_account" ] && [ ! -z "$free_pass" ]; then
      echo "envoi d'un sms"
      echo "envoi d'un sms" >> $log
      wget -O /dev/null --no-check-certificate "https://smsapi.free-mobile.fr/sendmsg?user=$free_account&pass=$free_pass&msg=Alerte%20KimSufi%20!" 2>> $log
      sleep $time_sleep_after
    fi
  else
    echo "rien :("
    echo "rien :(" >> $log
  fi
  sleep $time_sleep
done

