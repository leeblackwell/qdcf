#!/bin/bash

logger()
{
	TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
	echo "$0 $TIMESTAMP $@" >> $0.log
	echo "$0 $TIMESTAMP $@" 
}

#Place a marker down showing when this image was built
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo "$TIMESTAMP" > /image_build_timestamp.txt

#Enable globbing because it's disabled by default for non-interactive shells.
shopt -s extglob

#Where are we looking for files?
if [ -z $1 ]; then
	BASE="/root"
else
	BASE=$1
fi

#Go get a list and execute 'em
for S in $( ls -1 $BASE/cf-configure*+([0-9]) | sort -t\. -k2 )
do
	logger "********************************************************************************"
	logger "Enter: $S"
	logger "********************************************************************************"
	eval $S 2>&1 #| tee -a $0.log
	RES=$?
	logger "********************************************************************************"
	logger "Exit : $S with result $RES"
	logger "********************************************************************************"
	if [ $RES -ne 0 ]; then
		exit 1
	fi
done
