#!/bin/bash
#SBATCH --job-name=pan010hap1
#SBATCH --partition=medium
#SBATCH --mail-user=emxu@ucsc.edu
#SBATCH --mail-type=FAIL,END
#SBATCH --nodes=1
#SBATCH --mem=150gb
#SBATCH --cpus-per-task=10
#SBATCH --output=010hap1filtered.%j.log
#SBATCH --time=12:00:00

# Inputs:
# genomeName=PAN010
# dir=/private/groups/migalab/emxu/pedigrees/${genomeName}  # Working directory
# bamPath=${dir}/${genomeName}.filtered.hifi.bam # path to BAM file
bamPath=$1
# coordinates=${dir}/${genomeName}.hap1.25.coordinates.bed  # (optional) BED file of region coordinates
coordinates=$2
genomeName=$3

# Outputs:
mkdir nucfreqResults
outPlotPath=nucfreqResults/${genomeName}.NucPlot.png  # path to Plot output
outBedPath=nucfreqResults/${genomeName}.variants.bed  # path to BED file output of variants and respective positions
outTblPath=nucfreqResults/${genomeName}.tbl  # path of tabular output
chrQC=nucfreqResults/${genomeName}.summary.bed

# Running NucPlot
source /opt/miniconda/etc/profile.d/conda.sh
conda activate /private/home/emxu/.conda/envs/nucfreq
python /private/groups/migalab/emxu/scripts/NucFreq-master/NucPlot.py -t 64 --obed ${outBedPath} --bed ${coordinates} ${bamPath} ${outPlotPath}
conda deactivate

# Running HetDetection
conda activate /private/home/emxu/.conda/envs/hetdetect
Rscript /private/groups/migalab/emxu/scripts/HetDetection2.R ${outBedPath} ${outTblPath}
conda deactivate

# Running checkChrs.py
conda activate /private/home/emxu/.conda/envs/nucfreq
python3 /private/groups/migalab/emxu/scripts/checkChrs.py -r ${outTblPath} -b ${coordinates} -o ${chrQC}
conda deactivate

echo "Done"

