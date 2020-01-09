#!/bin/bash

#the script should be run on the head node
#takes the IP address of the worker node as the argument

if [ "$#" -ne 1 ]; then
    echo "usage : $0 <woerker_nodeip_address>"
        exit
fi
device=$1

SCRIPT="$0"
BASENAME="$(dirname $script)"

#copy host's ssh key
ssh-copy-id nanojet@$device

cd $BASENAME/../ganglia
ansible $device -m copy -a "src=ganglia-metrics.sh dest=/nanopore/bin/ganglia-metrics.sh mode=0777"
ansible $device -m copy -a "src=gmond.conf dest=/etc/ganglia/gmond.conf owner=root mode=0644" -K -b
ansible $device -m cron -a "name=ganglia job=/nanopore/bin/ganglia-metrics.sh"

cd $BASENAME/../rsyslog
ansible $device -m copy -a "src=1-ignore.conf dest=/etc/rsyslog.d/1-ignore.conf mode=0744" -K -b
ansible $device -m copy -a "src=10-rsyslog.conf dest=/etc/rsyslog.d/10-rsyslog.conf mode=0744" -K -b
ansible $device -m copy -a "src=50-default.conf dest=/etc/rsyslog.d/50-default.conf mode=0744" -K -b
ansible $device -m copy -a "src=rsyslog.conf dest=/etc/rsyslog.conf mode=0744" -K -b
ansible $device -m shell -a "sudo service rsyslog restart" -K -b
