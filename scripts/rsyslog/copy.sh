ansible all -m copy -a "src=10-rsyslog.conf dest=/etc/rsyslog.d/10-rsyslog.conf mode=0744" -K -b
ansible all -m copy -a "src=50-default.conf dest=/etc/rsyslog.d/50-default.conf mode=0744" -K -b
ansible all -m copy -a "src=rsyslog.conf dest=/etc/rsyslog.conf mode=0744" -K -b
ansible all -m shell -a "sudo service rsyslog restart" -K -b


