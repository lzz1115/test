#! /bin/bash
clear

# Setting variables
method=INDUCE_SEQ
platform=NEXTSEQ550
FASTQ=/cluster/home/luzhenzhen/batch/download/FASTQ
SUM=/cluster/home/luzhenzhen/batch/download/summary
blacklist=/cluster/home/luzhenzhen/batch/accessory_files/hg19-blacklist.v2.bed
chromsizes=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.sizes.bed
chromends=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.ends.bed
refseq=/cluster/home/luzhenzhen/batch/download/index/Homo_sapiens_assembly38.fasta
quality=30
threads=16

for file in "$FASTQ"/*_trimmed.fq.gz; do
filename=$(echo "$file" | awk -F'[/]' '{print $8}')
experiment=$(echo "$filename" | awk -F'[_]' '{print $1}')

tmpdir=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/tmpdir
BAM=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/BAM
SAM=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/SAM
BED=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/BEM

awk '$6 !~ /[0-9]S/{print}' "$tmpdir"/"$experiment".sam | samtools view -Shu -q "$quality" -F 256 - |
  samtools sort -m 4G - -o "$BAM"/"$experiment".q30.srt.bam
  samtools index "$BAM"/"$experiment".q30.srt.bam

done
