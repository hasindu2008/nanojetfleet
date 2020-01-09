#!/bin/bash

cleanscratch.sh
rm logs/*

ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==1 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.2:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==2 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.3:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==3 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.4:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==4 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.5:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==5 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.6:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==6 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.7:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==7 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.8:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==8 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.9:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==9 ) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.10:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==10) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.11:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==11) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.12:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==12) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.13:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==13) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.14:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==14) print $9 > "dev.cfg"}'; scp dev.cfg 10.40.18.15:/nanopore/scratch/dev.cfg
ls /mnt/778/778-5000ng/778-5000ng_albacore-2.1.3/fast5/* -lhS | awk '{if(NR%15==0) print $9 > "dev.cfg"}';  scp dev.cfg 10.40.18.16:/nanopore/scratch/dev.cfg


ansible all -m copy -a "src=fast5_pipeline_parallela.sh dest=/nanopore/bin/fast5_pipeline_parallela.sh mode=0755"
/usr/bin/time -v ansible all -m shell -a "/nanopore/bin/fast5_pipeline_parallela.sh > /nanopore/scratch/parallella.log 2>&1" > log.txt 2> time.txt
ansible all -m shell -a "cd /nanopore/scratch && tar zcvf logs.tgz *.log"
gather.sh /nanopore/scratch/logs.tgz logs/log tgz
gather.sh /nanopore/scratch/dev.cfg logs/dev cfg
mv log.txt logs/
mv time.txt logs/
