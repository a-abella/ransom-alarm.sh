#!/bin/bash

# Antonio Abella - 2/24/17
#
# Reset Ransomware alarm directory

resetRansomDefense() {
    systemctl stop ransom-alarm
    rm -rf $1/_Locker_Defense
    rsync -aAX /root/scripts/resources/_Locker_Defense $1/
    systemctl start ransom-alarm
    datestamp=$(date +%F)
    hostname=$(hostname)
    echo -e "====== Ransom Alarm reset on $1 ======" | logger
}

sharedirs=(/share/*/)

for folders in "${sharedirs[@]}"; do
    if [ ! -d "$folders/_Locker_Defense" ]; then
	resetRansomDefense $folders	
    fi
    if [ ! -e "$folders/_Locker_Defense/__What is this folder.txt" ] || [ ! -e "$folders/_Locker_Defense/_DO_NOT_EDIT_OR_MAKE_NEW_FILES.txt" ]; then
	cp -p /root/scripts/resources/__What\ is\ this\ folder.txt $folders/_Locker_Defense/
        cp -p /root/scripts/resources/_DO_NOT_EDIT_OR_MAKE_NEW_FILES.txt $folders/_Locker_Defense/
    fi
    currentHour=$(date +%k)
    currentMinute=$(date +%M)
    if [ "$currentHour" -eq "2" ] && [ "$currentMinute" -lt "15" ]; then
	resetRansomDefense $folders
    fi
done

