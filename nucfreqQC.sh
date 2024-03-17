#!/bin/bash
#SBATCH --job-name=nucfreq
#SBATCH --partition=medium
#SBATCH --mail-user=emxu@ucsc.edu
#SBATCH --mail-type=FAIL,END
#SBATCH --nodes=1
#SBATCH --mem=150gb
#SBATCH --cpus-per-task=10
#SBATCH --output=nucfreq.%j.log
#SBATCH --time=12:00:00

# Inputs:
# path to BAM file
bamPath=''
# (optional) BED file of region coordinates
coordinates='None'
genomeName=''

while getopts 'b:cg:' flag; do
  case "${flag}" in
    b) bamPath="${OPTARG}" ;;
    c) coordinates="${OPTARG:-None}" ;; # if -c argument is not given, set coordinates=None. if it is given, set it to the given argument
    g) genomeName="${OPTARG}" ;;
  esac
done

# Outputs:
mkdir ${genomeName}-nucfreqResults
outPlotPath=${genomeName}-nucfreqResults/${genomeName}.NucPlot.png  # path to Plot output
outBedPath=${genomeName}-nucfreqResults/${genomeName}.variants.bed  # path to BED file output of variants and respective positions
outTblPath=${genomeName}-nucfreqResults/${genomeName}.tbl  # path of tabular output
chrQC=${genomeName}-nucfreqResults/${genomeName}.summary.bed

source /opt/miniconda/etc/profile.d/conda.sh
conda activate /private/home/mcechova/.conda/envs/methylation
chrNames=${genomeName}-nucfreqResults/${genomeName}.coordinates.txt
samtools idxstats ${bamPath} | cut -f 1 > ${chrNames}
conda deactivate

# Running NucPlot
source /opt/miniconda/etc/profile.d/conda.sh
conda activate /private/home/emxu/.conda/envs/nucfreq
if [ ${coordinates} == 'None' ]; then
    python /private/groups/migalab/emxu/tools/NucFreq-master/NucPlot.py --obed ${outBedPath} ${bamPath} ${outPlotPath}
else
    python /private/groups/migalab/emxu/tools/NucFreq-master/NucPlot.py --obed ${outBedPath} --bed ${coordinates} ${bamPath} ${outPlotPath}

fi
conda deactivate

# Running HetDetection
conda activate /private/home/emxu/.conda/envs/hetdetect
Rscript /private/groups/migalab/emxu/tools/HetDetection2.R ${outBedPath} ${outTblPath}
conda deactivate

# Running checkChrs.py
conda activate /private/home/emxu/.conda/envs/nucfreq
if [ ${coordinates} == 'None ]; then
	python3 /private/groups/migalab/emxu/tools/checkChrs.py -r ${outTblPath} -b ${coordinates} -o ${chrQC}
else
	python3 /private/groups/migalab/emxu/tools/checkChrs.py -r ${outTblPath} -b ${chrNames} -o ${chrQC}
fi
conda deactivate

echo "Done"

