#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pandas as pd
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
import subprocess

def sys(command):
    """
    """
    print("-" * 10)
    print("Executing: %s" % command)
    process = subprocess.Popen(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    print("Result: stdout: %s - stderr: %s" % (stdout, stderr))
    print("-" * 10)
    return stdout, stderr

if __name__ == "__main__":
    #import argparse
    #parser = argparse.ArgumentParser()
    #parser.add_argument("-a", "--annotation", help="Annotation file (.gff3 format)", required=True)
    #args = parser.parse_args()
    functional_annotation = "data/genomes/iwgsc_refseqv1.0_FunctionalAnnotation_v1__HCgenes_v1.0.TAB"
    functional_annotation_filtered = "data/genomes/alpha_gliadins.functional.csv"
    annotation = "/home/juan/Desktop/juan/bio/data/IWGSC/42/Triticum_aestivum.IWGSC.42.clean.gff3"
    genome = "/home/juan/Desktop/juan/bio/data/IWGSC/42/Triticum_aestivum.IWGSC.dna.toplevel.fa"


    cmd = "{head -n 1 %(0)s & grep -i 'Alpha-gliadin' %(0)s > %(1)s}" % (functional_annotation, functional_annotation_filtered)
    sys(cmd)

    df = pd.read_csv(functional_annotation_filtered, sep="\t")
    print(df)