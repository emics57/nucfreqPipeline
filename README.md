# How to run nucfreqQC.sh on Phoenix:
``` 
sbatch nucfreqQC.sh <BAM file> <BED file> <genomeName>
```
## Inputs
```
BAM file: path to BAM file [required]

BED file: path to BED file with regions to plot [required]

genomeName: output file name (no file extension needed) [required]
```

## Example: 
```
sbatch nucfreqQC.sh PAN010.hifi.bam PAN010.hap2.activehor.coordinates.bed PAN010.hap2.activehor
```

## Outputs:
```
 |__ nucfreqResults
    |__ PAN010.hap2.activehor.NucPlot.png
    |__ PAN010.hap2.activehor.variants.bed
    |__ PAN010.hap2.activehor.tbl
    |__ PAN010.hap2.activehor.summary.bed
```

# Cite
```hetDetection2.R``` was written by G. Logsdon and identifies regions where the second most common base was present in at least 10% of reads in at least 5 positions within a 500 bp region. This file was slightly modified to take arguments from the command line.

How to cite ```hetDetection2.R```:
- Mc Cartney AM, Shafin K, Alonge M, Bzikadze AV, Formenti G, Fungtammasan A, et al. Chasing perfection: validation and polishing strategies for telomere-to-telomere genome assemblies. bioRxiv. 2021. p. 2021.07.02.450803. doi:10.1101/2021.07.02.450803

