#! /bin/bash
clear

# Setting variables
method=INDUCE_SEQ
platform=NEXTSEQ550
FASTQ=/cluster/home/luzhenzhen/rowdata/1208result/FASTQ/af_trimmed/FASTQ #修改地址
SUM=/cluster/home/luzhenzhen/batch/download/summary
blacklist=/cluster/home/luzhenzhen/batch/accessory_files/hg19-blacklist.v2.bed
chromsizes=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.sizes.bed
chromends=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.ends.bed
refseq=/cluster/home/luzhenzhen/batch/download/index/Homo_sapiens_assembly38.fasta
quality=1 #quality=30
threads=16

for file in "$FASTQ"/*_fq.fq.gz; do
filename=$(echo "$file" | awk -F'[/]' '{print $10}')
experiment=$(echo "$filename" | awk -F'[_]' '{print $1}')

tmpdir=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/tmpdir
BAM=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/BAM
SAM=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/SAM
BED=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/BED

# Convert BAM-to-BED
# Filter out blacklist regions, chromosome ends & non-canonical contigs
bedtools bamtobed -i "$BAM"/"$experiment".q1.srt.bam |
bedtools intersect -v -bed -a - -b "$blacklist" |
bedtools intersect -v -bed -a - -b "$chromends" |
bedtools intersect -wa -a - -b "$chromsizes" > "$BED"/"$experiment".q1.srt.bed


done
