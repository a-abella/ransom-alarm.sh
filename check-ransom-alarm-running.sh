#!/bin/bash

isrunning=$(ps -e | grep "ransom-alarm")

if [ "$isrunning" = "" ]; then
    statusout=$(systemctl status ransom-alarm)
    echo "From: root@"$HOSTNAME".inktel.com" >> /root/temp2message.txt
    echo "To: antonio.abella@inktel.com" >> /root/temp2message.txt
    echo "Subject: Service 'ransom-alarm' not running on $HOSTNAME" >> /root/temp2message.txt
    echo -e "Service \"ransom-alarm\" not running on host "$HOSTNAME". Host is not being monitored for suspicous activity.\n\nService status output: \n\n $statusout" >> /root/temp2message.txt
    echo "$smbaccess" >> /root/temp2message.txt
    sendmail antonio.abella@inktel.com < /root/temp2message.txt
    rm -f /root/temp2message.txt
fi
