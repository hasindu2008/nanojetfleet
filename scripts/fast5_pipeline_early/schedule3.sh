ansible all -m copy -a "src=fast5_pipeline_parallela_indexearly.sh dest=/nanopore/bin/fast5_pipeline_parallela.sh mode=0755"
time ansible all -m shell -a "/nanopore/bin/fast5_pipeline_parallela.sh" > log.txt 2> log.err

