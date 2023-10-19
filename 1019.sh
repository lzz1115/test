#! /bin/bash
clear

# Setting variables
method=INDUCE_SEQ
platform=#NEXTSEQ550
BAM=BAM
SAM=SAM
BED=BED
FASTQ=FASTQ
SUM=summary
tmpdir=tmpdir
blacklist=/cluster/home/luzhenzhen/batch/accessory_files/hg19-blacklist.v2.bed
chromsizes=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.sizes.bed
chromends=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.ends.bed
refseq=
quality=30
threads=16

#Detect FASTQ files
for file in "$FASTQ"/*_trimmed.fq.gz; do (
filename=$(echo "$file" | awk -F'[/]' '{print $8}')
echo "$filename" >> filelist.txt
experiment=$(echo "$filename" | awk -F'[.]' '{print $1}')
echo "Found" "$filename" "from experiment:" "$experiment"
# rm filelist_"$experiment" #comment this line if you want to test whether the above functions actually finds your files

# Generate folders
mkdir -p /cluster/home/luzhenzhen/batch/download/"$experiment"
mkdir -p /cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$BAM"
BAM=/cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$BAM"
mkdir -p /cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$SAM"
SAM=/cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$SAM"
mkdir -p /cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$BED"
BED=/cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$BED"
mkdir -p /cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$SUM"
SUM=/cluster/home/luzhenzhen/batch/download/"$experiment"/preprocessing/"$SUM"
mkdir -p /cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$tmpdir"
tmpdir=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$tmpdir"
mkdir -p /cluster/home/luzhenzhen/batch/download/summary

# ALIGNMENT
if [[ ! -e "$SAM"/"$experiment".sam && ! -e "$tmpdir"/"$experiment".sam ]]; then 
  bwa mem -M -p -R '@RG\tID:"$method"\tPL:"$platform"\tPU:0\tLB:"$method"\tSM:"$experiment"' "$refseq" "$filename" > "$tmpdir"/"$experiment".sam

#########################################################################################
else
  echo "SAM file found in:" "$tmpdir"/"$experiment".sam "Alignment in progress, skipping."
fi
)
done

















