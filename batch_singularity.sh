#!/bin/bash



time=`date +"%m%d%Y-%H%M%S"`

mkdir -p /oasis/scratch/comet/dasay/temp_project/SLURM_OUT/fmriprep/OUT/${time}

mkdir -p /oasis/scratch/comet/dasay/temp_project/SLURM_OUT/fmriprep/ERROR/${time}

cd /oasis/scratch/comet/dasay/temp_project/data


for i in sub-1435; do


  sbatch \
  -o /oasis/scratch/comet/dasay/temp_project/SLURM_OUT/fmriprep/OUT/${time}/out.txt \
  -e /oasis/scratch/comet/dasay/temp_project/SLURM_OUT/fmriprep/ERROR/${time}/error.txt \
  /oasis/scratch/comet/dasay/temp_project/data/code/singularity.sh \


done













#cd ~/compute/single_subject_data/


#for i in sub*; do




#done





