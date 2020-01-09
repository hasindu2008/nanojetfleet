ssh rock13 "cd ~/minimap2 && make arm_neon=1 aarch64=1 -j4" && scp rock13:~/minimap2/minimap2 ./minimap2 && ansible all -m copy -a "src=./minimap2 dest=/nanopore/bin/minimap2 mode=0755"

