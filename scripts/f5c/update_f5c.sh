ssh rock13 'cd ~/f5c &&  make' && scp rock13:~/f5c/f5c ./f5c && ansible all -m copy -a "src=./f5c dest=/nanopore/bin/f5c mode=0755"

