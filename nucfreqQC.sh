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
coordinates=''
genomeName=''
lagDistance=''
variantsPerCluster=''

while getopts 'b:c:g:d:n:' flag; do
  case "${flag}" in
    b) bamPath="${OPTARG}" ;;
    c) coordinates="${OPTARG}" ;; 
    g) genomeName="${OPTARG}" ;;
    d) lagDistance="${OPTARG}" ;; 
    n) variantsPerCluster="${OPTARG}" ;;
  esac
done

if [ -z ${lagDistance} ]; then
  lagDistance=500
fi
if [ -z ${variantsPerCluster} ]; then
  variantsPerCluster=5
fi

# Outputs:
mkdir ${genomeName}-nucfreqResults
outPlotPath=${genomeName}-nucfreqResults/${genomeName}.NucPlot.png  # path to Plot output
outBedPath=${genomeName}-nucfreqResults/${genomeName}.variants.bed  # path to BED file output of variants and respective positions
outTblPath=${genomeName}-nucfreqResults/${genomeName}.variantClusters.tbl  # path of tabular output
chrQC=${genomeName}-nucfreqResults/${genomeName}.summary.bed

source /opt/miniconda/etc/profile.d/conda.sh
conda activate /private/home/mcechova/.conda/envs/methylation
chrNames=${genomeName}-nucfreqResults/${genomeName}.coordinates.txt
if [ -z ${coordinates} ]; then
  samtools idxstats ${bamPath} | cut -f 1 > ${chrNames}
else
  awk '{print $1}' ${coordinates} > ${chrNames}
fi
conda deactivate

# Running NucPlot
source /opt/miniconda/etc/profile.d/conda.sh
conda activate /private/home/emxu/.conda/envs/nucfreq
echo ${coordinates}
if [ -z ${coordinates} ]; then
    python /private/groups/migalab/emxu/tools/NucFreq-master/NucPlot.py --obed ${outBedPath} ${bamPath} ${outPlotPath}
else
    python /private/groups/migalab/emxu/tools/NucFreq-master/NucPlot.py --obed ${outBedPath} --bed ${coordinates} ${bamPath} ${outPlotPath}

fi
conda deactivate

# Running HetDetection
conda activate /private/home/emxu/.conda/envs/hetdetect
Rscript /private/groups/migalab/emxu/NucFreq/nucfreq_filtering_migalab.R ${outBedPath} ${outTblPath} ${lagDistance} ${variantsPerCluster}
conda deactivate

# Running checkChrs.py
conda activate /private/home/emxu/.conda/envs/nucfreq
python3 /private/groups/migalab/emxu/NucFreq/checkChrs.py -r ${outTblPath} -b ${chrNames} -o ${chrQC}
conda deactivate

echo "Done"
