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


# Generate a Summary for each dataset
echo "Writing summary file"
summaryfile="$SUM"/"$experiment"_summary
# Retreive alignment stats using samtools flagstat
echo "Alignment statistics:" > "$summaryfile"
samtools flagstat "$SAM"/"$experiment".sam >> "$summaryfile"
echo "" >> "$summaryfile"
# Retreive alignment statistics from BAM after filtering
echo "Alignment statistics after filtering:" >> "$summaryfile"
samtools flagstat "$BAM"/"$experiment".q30.srt.bam >> "$summaryfile"
echo "" >> "$summaryfile"
# Count total number of breaks
echo "Number of tagged break-ends:" >> "$summaryfile"
wc -l "$BED"/"$experiment".breakends.bed | cut -d' ' -f1 >> "$summaryfile"
echo "" >> "$summaryfile"
# Count total number of breaks per strand
echo "Number of tagged break-ends on the forward strand:" >> "$summaryfile"
awk '{ if ($6 == "+") print}' "$BED"/"$experiment".breakends.bed | wc -l >> "$summaryfile"
echo "" >> "$summaryfile"

echo "Number of tagged break-ends on the reverse strand:" >> "$summaryfile"
awk '{ if ($6 == "-") print}' "$BED"/"$experiment".breakends.bed | wc -l >> "$summaryfile"
echo "" >> "$summaryfile"
# Count total number of unique DSB locations
echo "Number of DSB locations:" >> "$summaryfile"
wc -l "$BED"/"$experiment".breakcount.bed | cut -d' ' -f1 >> "$summaryfile"
echo "" >> "$summaryfile"
# Calculate average break frequency
echo "Average break frequency at unique locations:" >> "$summaryfile"
awk '{x+=$5} END{print x/NR}' "$BED"/"$experiment".breakcount.bed >> "$summaryfile"
echo "" >> "$summaryfile"
# Generate a break frequency histogram to summarize break data
echo "Histogram breaks/location and number of locations:" >> "$summaryfile"
awk '{printf "%0.0f\n", $5 }' "$BED"/"$experiment".breakcount.bed | sort -k1,1n | uniq -c | awk '{print $2,$1}' >> "$summaryfile"
# Move summary file to top-level summary folder for easy access
cp "$summaryfile" summary/"$experiment".summary.txt
