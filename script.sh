#!/bin/bash
while true; do
       docker ps | awk '{print $NF}' | grep -v NAMES | grep -v 'shuffle-orborus\|fluent' | while read name; do
           filename=$(docker inspect --format '{{json .LogPath}}' $name | sed 's/"//g');
	   directory=$(echo $filename | awk -F '/' '{print $6}')
	   if [ ! -d /opt/logs/$directory ] && [ -f $filename ]; then
	   	mkdir -p /opt/logs/$directory
	   fi
	   if [ -f $filename ] && [ "$directory" != "" ]; then
		   cp $filename /opt/logs/$directory/
	   fi
         done
	 sleep 0.1;
	 for i in $(find /opt/logs/ -type f -mmin +15); do 
	 	 cat $i;
		 rm $i
	 done
	 find /opt/logs/ -type d -mmin +15 -exec rm -r {} +
done
