ansible all -m copy -a "src=1-ignore.conf dest=/etc/rsyslog.d/1-ignore.conf mode=0744" -K -b
ansible all -m shell -a "sudo service rsyslog restart" -K -b


