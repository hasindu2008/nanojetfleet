#!/bin/bash

#to be run on worker nodes
#takes the new hostname of the worker node as the argument

if [ "$EUID" -ne 0 ]
  passwd 
  then echo "Please run as root for the rest"
  exit
fi

if [ "$#" -ne 1 ]; then
    echo "usage : $0 <device name>"
        exit
fi
device=$1

#set up the device hostname
echo $device > /etc/hostname
sed -i "s/nanojet/$device/" /etc/hosts

#configure timezones/ntp
#echo "Australia/Sydney" > /etc/timezone
#dpkg-reconfigure --frontend noninteractive tzdata
dpkg-reconfigure tzdata
echo "NTP=ntp1.unsw.edu.au" >> /etc/systemd/timesyncd.conf
echo "server ntp1.unsw.edu.au" >> /etc/ntp.conf

#install nfs and ganglia and python
apt-get update && sudo apt-get upgrade -y
apt-get install -y time nfs-common ganglia-monitor 

#network attached storage  mount 
echo "10.0.0.5:/volume1/homes/        /mnt    nfs     intr,nfsvers=3,rsize=8192,wsize=8192       0       0"  >>  /etc/fstab

#create and copy the folder structure
mkdir /nanopore
scp -r nanojet@10.40.18.2:/nanopore/* /nanopore/
chown nanojet /nanopore -R

