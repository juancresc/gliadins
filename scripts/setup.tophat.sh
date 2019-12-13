#!/bin/bash

home=/home/juan/Desktop/juan/bio/gliadinas
genome=/home/juan/Desktop/juan/bio/data/IWGSC/42/Triticum_aestivum.IWGSC.dna.toplevel.fa
adapters=/home/juan/Desktop/juan/bio/gliadinas/data/adapters_new_rc.fa
index=/home/juan/Desktop/juan/bio/data/IWGSC/42/index

bowtie2=/home/juan/Desktop/juan/bio/sw/bowtie2-2.3.5.1-linux-x86_64/bowtie2
bowtie2build=/home/juan/Desktop/juan/bio/sw/bowtie2-2.3.5.1-linux-x86_64/bowtie2-build

bowtie=/home/juan/Desktop/juan/bio/sw/bowtie-src-x86_64/bowtie-1.2.3/bowtie
bowtie_build=/home/juan/Desktop/juan/bio/sw/bowtie-src-x86_64/bowtie-1.2.3/bowtie-build

trimmomatic=/home/juan/Desktop/juan/bio/sw/Trimmomatic-0.38/trimmomatic-0.38.jar
samtools=/home/juan/Desktop/juan/bio/sw/samtools-1.9/samtools
sambamba=/home/juan/Desktop/juan/bio/sw/sambamba-0.7.1-linux-static

hisat2_build=/home/juan/Desktop/juan/bio/sw/hisat2-2.1.0/hisat2-build
hisat2=/home/juan/Desktop/juan/bio/sw/hisat2-2.1.0/hisat2

$hisat2_build $genome $index
s=86
for i in  {434..535};
do
    #file names
    metrics=data/logs/sar${i}-2019_S${s}.logs
    sample_1=data/reads/sar${i}-2019_S${s}_L001_R1_001.fastq.gz
    sample_2=data/reads/sar${i}-2019_S${s}_L001_R2_001.fastq.gz
    sample_filter_1=data/clean/sar${i}-2019_S${s}_L001_R1_001.paired.1.fastq
    sample_filter_2=data/clean/sar${i}-2019_S${s}_L001_R1_001.paired.2.fastq
    #sample_filter_1_u=data/clean/sar${i}-2019_S${s}_L001_R1_001.unpaired.1.fastq
    #sample_filter_2_u=data/clean/sar${i}-2019_S${s}_L001_R1_001.unpaired.2.fastq
    res=data/sam/sar${i}-2019_S${s}_L001.sam
    res_un=data/sam/sar${i}-2019_S${s}_L001.unaligned.sam
    res_filtered=data/sam/sar${i}-2019_S${s}_L001.filtered.sam
    res_soterted=data/sam/sar${i}-2019_S${s}_L001.sorted.bam
    #trim
    #java -jar $trimmomatic PE -phred33 $sample_1 $sample_2 $sample_filter_1 $sample_filter_1_u $sample_filter_2 $sample_filter_2_u ILLUMINACLIP:$adapters:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:20
    cutadapt -a GTGTAGATCTCGGTGGTCGCCGTATCATT -g ATCTCGTATGCCGTCTTCTGCTTG $sample_1 > $sample_filter_1
    cutadapt -g GTGTAGATCTCGGTGGTCGCCGTATCATT -a ATCTCGTATGCCGTCTTCTGCTTG $sample_2 > $sample_filter_2

    $hisat2 -q -p 20 -k 1 --no-spliced-alignment \
    --met-file $metrics  --met-stderr --met 5 --time -x $index \
    -1 $sample_filter_1 -2 $sample_filter_2 | samtools view -bS -  > $res

    samtools view -f 4 $res > $res_un   

    #align
    #$bowtie -v 4 -a --best $index -1 $sample_filter_1 -2 $sample_filter_2 -S --un $res_un > $res
    #sort
    #$sambamba view -h -t 2 -f bam -F "[XS] == null and not unmapped  and not duplicate" $ressoterted > $ressoterted_filtered
    #perl -ne "print if((/XM:i:[0-4][^0-9]/) || (/^@/));" $res > $res_filtered
    #TODO primary alignemnt samtools view -F 256 https://groups.google.com/forum/#!topic/rna-star/dUKvviBixTQ

    cat $res > $res_filtered
    $samtools sort $res_filtered > $res_soterted
    $samtools index -c $res_soterted
    s=$((s+1))
done
