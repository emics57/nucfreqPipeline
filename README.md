## How to run nucfreqQC.sh on Phoenix:
First, set up your environments by downloading the .yaml files to your folder in the Phoenix cluster and then running:
```
conda env create -f hetdetectEnv.yaml
conda env create -f nucfreqEnv.yaml
```

Run the script nucfreqQC.sh:
``` 
sbatch nucfreqQC.sh -b <BAM file> -g <genomeName> -c <BED file>
```

### Inputs
```
BAM file: path to BAM file of PacBio primary alignments [required]
          Be sure to filter out non-primary alignments with SAMflag 2308 first.
          This script is not optimize for ONT reads yet.

genomeName: output file name (no file extension needed) [required]

BED file: path to BED file with regions to plot [optional]
```

## The simplest way to use nucfreqQC.sh: 
```
sbatch nucfreqQC.sh -b PAN010.hifi.bam -g PAN010.hifi
```

## If there are specific genomic regions you are interested in: 
```
sbatch nucfreqQC.sh -b PAN010.hifi.bam -g PAN010.hap2.activehor -c PAN010.hap2.activehor.coordinates.bed 
```

## Outputs:
```
 |__ PAN010.hap2.activehor-nucfreqResults
    |__ PAN010.hap2.activehor.NucPlot.png: plots showing locations of variants
    |__ PAN010.hap2.activehor.variants.bed: BED file of the locations of variants
    |__ PAN010.hap2.activehor.tbl: contains clusters of variants
    |__ PAN010.hap2.activehor.summary.bed: contains whether each contig has errors or not
```

# Cite
Citing ```NucFreq```:
- Vollger MR, Dishuck PC, Sorensen M, Welch AE, Dang V, Dougherty ML, et al. Long-read sequence and assembly of segmental duplications. Nat Methods. 2019;16: 88–94. doi:10.1038/s41592-018-0236-3

```nucfreq_filtering_migalab.R``` was initially written by G. Logsdon and refactored by Monika Cechova. It identifies regions where the second most common base was present in at least 10% of reads in at least 5 positions within a 500 bp region. This file was slightly modified by Emily Xu to take arguments from the command line.

Citing ```nucfreq_filtering_migalab.R```:
- Mc Cartney AM, Shafin K, Alonge M, Bzikadze AV, Formenti G, Fungtammasan A, et al. Chasing perfection: validation and polishing strategies for telomere-to-telomere genome assemblies. bioRxiv. 2021. p. 2021.07.02.450803. doi:10.1101/2021.07.02.450803

