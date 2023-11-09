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
BED=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/BED

# Flatten breakends files using bedtools merge and count breaks at each unique location
awk -v var="$experiment" '{print $1,$2,$3,var"_"(FNR FS),$5,$4}' OFS="\t" "$BED"/"$experiment".breakends.bed> "$BED"/"$experiment".breakcount.bed

done
