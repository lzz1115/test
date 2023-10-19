
#! /bin/bash

###list all sra files
for i in *sra  
do
echo fastq-dump --gzip --split-3 $i -O /cluster/home/luzhenzhen/batch/download/sra/fastq ## -O output files address
done >sra_fastq.sh

