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
  nucfreqResults
  |__ PAN010.hap2.activehor.NucPlot.png
  |__ PAN010.hap2.activehor.variants.bed
  |__ PAN010.hap2.activehor.tbl
  |__ PAN010.hap2.activehor.summary.bed
```

