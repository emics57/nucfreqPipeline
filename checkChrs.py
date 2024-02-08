import subprocess
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt 
import matplotlib.patches as mplpatches
from operator import itemgetter
import seaborn as sns
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--hetRegions','-r',type=str,action='store',help='path to tbl file of het/misassembly regions goes here')
parser.add_argument('--bedCoordinates','-b',type=str,action='store',help='path to BED file of region coordinates goes here')
parser.add_argument('--output','-o',type=str,action='store',help='path to output file goes here')

args = parser.parse_args()

hetregions=args.hetRegions
bedcoords=args.bedCoordinates
outFile=args.output

# hetregions = '/Users/emilyxu/Desktop/hg002/all.hets.control.greaterThan10.tbl'
# bedcoords = '/Users/emilyxu/Desktop/hg002/coordinatesBed/hg002-missassemblies.bed'
# output = '/Users/emilyxu/Desktop/hg002/chrQC.bed'
hetList = set()
with open(hetregions, "r") as f:
  next(f)
  for line in f:
    word = line.split('\t')
    hetList.add(word[0])

allRegionsList = set()
with open(bedcoords, "r") as f:
  next(f)
  for line in f:
    word = line.split('\t')
    allRegionsList.add(word[0])

finalFile = open(outFile, "w")
for i in allRegionsList:
  if i not in hetList:
    finalFile.write(f"{i}\tPASS\n")
  else:
    finalFile.write(f"{i}\tERRORS\n")

finalFile.close()
