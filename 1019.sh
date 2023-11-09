#! /bin/bash
clear

# Setting variables
method=INDUCE_SEQ
platform=NEXTSEQ550
BAM=BAM
SAM=SAM
BED=BED
FASTQ=/cluster/home/luzhenzhen/batch/download/FASTQ
SUM=summary
tmpdir=tmpdir
blacklist=/cluster/home/luzhenzhen/batch/accessory_files/hg19-blacklist.v2.bed
chromsizes=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.sizes.bed
chromends=/cluster/home/luzhenzhen/batch/accessory_files/hg19.chrom.ends.bed
refseq=/cluster/home/luzhenzhen/batch/download/index/Homo_sapiens_assembly38.fasta
quality=30
threads=16

#Detect FASTQ files
for file in "$FASTQ"/*_trimmed.fq.gz; do (
filename=$(echo "$file" | awk -F'[/]' '{print $8}')
echo "$filename" >> filelist.txt
experiment=$(echo "$filename" | awk -F'[_]' '{print $1}')
echo "Found" "$filename" "from experiment:" "$experiment"
# rm filelist_"$experiment" #comment this line if you want to test whether the above functions actually finds your files

# Generate folders
mkdir -p /cluster/groups/Jan-Lab/luzhenzhen/"$experiment"
mkdir -p /cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$BAM"
BAM=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$BAM"
mkdir -p /cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$SAM"
SAM=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$SAM"
mkdir -p /cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$BED"
BED=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$BED"
mkdir -p /cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$SUM"
SUM=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$SUM"
mkdir -p /cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$tmpdir"
tmpdir=/cluster/groups/Jan-Lab/luzhenzhen/"$experiment"/preprocessing/"$tmpdir"
mkdir -p /cluster/home/luzhenzhen/batch/download/summary

echo "$SAM" "$experiment" "$threads" "$method" "$tmpdir" "$platform" "$refseq"  "$filename"

# ALIGNMENT
if [[ ! -e "$SAM"/"$experiment".sam && ! -e "$tmpdir"/"$experiment".sam ]]; then
  bwa mem -M -p -R '@RG\tID:"$method"\tPL:"$platform"\tPU:0\tLB:"$method"\tSM:"$experiment"' "$refseq" "$FASTQ"/"$filename" > "$tmpdir"/"$experiment".sam

else
  echo "SAM file found in:" "$tmpdir"/"$experiment".sam "Alignment in progress, skipping."
fi
)
done


















