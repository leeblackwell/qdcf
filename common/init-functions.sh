#!/bin/bash

THISME=$( basename $0 )

###############################################################
#
# Functions for use elsewhere
#
###############################################################

dircheckwarn() {
    if [ -n "$1" ]; then
        if [ -d $1 ]; then
            echo "${THISME} Directory ($1) appears OK"
        else
            echo "${THISME} Directory ($1) not present; WARNING"
        fi
	else
	    echo "${THISME} dircheckwarn() called without an argument.  This is bad."
	fi
}

bindmountcheck() {
    if [ -n "$1" ]; then
        if [ -d $1 ]; then
            echo "${THISME} Required bind mount ($1) appears OK"
        else
            echo "${THISME} Required bind mount ($1) not present; aborting"
            exit 1
        fi
    else
	    echo "${THISME} bindmountcheck() called without an argument.  This is bad."
	fi
}
bindmountcheckwarn() {
    if [ -n "$1" ]; then
        if [ -d $1 ]; then
                echo "${THISME} Required bind mount ($1) appears OK"
        else
                echo "${THISME} Required bind mount ($1) not present; WARNING"
        fi
    else
	    echo "${THISME} bindmountcheck() called without an argument.  This is bad."
	fi
}


sleepcycle()
{
	H=$( hostname )
	P=$0
	echo "$P on $H - sleeping $1"
	sleep $1
}

function container_uptime()
{
	#Not perfect, I know...
	echo $(($(date +%s) - $(date +%s -r /proc/1/stat)))
}

function getmyip() {
    MYIP=$(ip -o -4 a | grep eth0 | sed -r 's/.*inet ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\/[0-9]{1,2}.*/\1/g' | egrep -v "127.0.0.1")
}


###############################################################
#
# Init actions (applies to all containers ;)
#
###############################################################

MYIP=""
getmyip
export MYIP
echo "${THISME} Detected IP address as $MYIP"

if [ -f /image_build_timestamp.txt ]; then
    echo -n "This image built "
    cat /image_build_timestamp.txt
fi
