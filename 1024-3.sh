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

# Split by strand & remove optical duplicates
echo "Defining break ends and counting break events and locations"
awk '{ if ($6 == "+")
print $1,$2,$3=$2+1,$4,$5,$6;
else
print $1,$2=$3-1,$3,$4,$5,$6 }' OFS="\t" "$BED"/"$experiment".q30.srt.bed |
LC_ALL=C sort --parallel="$threads" -k1,1 -k2,2n | #refer to above note on sorting large bed files on smaller instances
sed 's/:/ /g' | awk '{print $1"_"$2"_"$3"_"$4":"$5":"$6":"$7":"$8":"$9":"$10"_"$11"_"$12, $8, $10 }' | #substitute everything that matches the regular expression ~ with a space, globally
awk 'NR==1{p=$2;q=$3;next}    #p=tile and q=y coordinate
{print $1, $2-p, $3-q; p=$2 ; q=$3}' |
sed 's/_/ /g' |
awk -v BED="$BED" '{ if (($7 == 0 || $7 == 1) && $8 <= 40 && $8 >= -40)
{print $1, $2, $3, $4, $5, $6 > BED"/optical_duplicates.txt"}
else {print $1, $2, $3, $4, $5, $6}}' OFS="\t" > "$BED"/"$experiment".breakends.bed




done
