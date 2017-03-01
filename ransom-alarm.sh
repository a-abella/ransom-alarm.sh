#!/bin/bash
count=0

declare -A shares
shares=( ["smb-dfs00"]="IT" ["smb-dfs01"]="ClientServices" ["smb-dfs02"]="Operations" ["smb-dfs03"]="QualityAssurance" ["smb-dfs04"]="Training" )
thisShare="${shares[$HOSTNAME]}"

while :
do
	{ inotifywait -e modify,delete,move,delete_self,move_self /share/*/_Locker_Defense/* && let count="$count + 1"; } || exit 1
	if [ "$count" -gt "15" ]; then
		smbaccess=$(smbstatus)
		echo "From: "$thisShare"Share@"$HOSTNAME".inktel.com" >> /root/tempmessage.txt
		echo "To: itsupport@inktel.com" >> /root/tempmessage.txt
		echo "Subject: Suspicious activity on $thisShare share: $count inodes modified" >> /root/tempmessage.txt
		echo -e "Suspicious activity on $thisShare share: $count inodes modified.\n" >> /root/tempmessage.txt
		echo "$smbaccess" >> /root/tempmessage.txt
		sendmail itsupport@inktel.com < /root/tempmessage.txt
		rm -f /root/tempmessage.txt
		count=-250
	fi
done
