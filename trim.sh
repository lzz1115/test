#! /bin/bash

for i in *fastq.gz
do
echo trim_galore --quality 20 --length 20 --gzip -o /cluster/home/luzhenzhen/batch/download/trimmed $i
done >trim.sh
