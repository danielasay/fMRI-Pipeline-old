#!/bin/bash



#time=`date +"%Y%m%d-%H%M%S"`

#mkdir -p ~/compute/single_subject_data/SLURM_OUT/fmriprep/OUT/${time}

#mkdir -p ~/compute/single_subject_data/SLURM_OUT/fmriprep/ERROR/${time}


#cd ~/compute/single_subject_data/


#for i in sub*; do


#  sbatch \
#  -o ~/compute/SLURM_OUT/fmriprep/OUT/${time}/o-${i}.txt \
#  -e ~/compute/SLURM_OUT/fmriprep/ERROR/${time}/e-${i}.txt \
#  ~/compute/single_subject_data/code/fmri_prep_job.sh \
#  ${i}
#  sleep 1

#done


export STUDY=/home/dasay/compute/

sbatch --array=1-$(( $( wc -l $STUDY/data/participants.tsv | cut -f1 -d' ' ) - 1 )) fmri_prep_job.sh














#tar -C /home/dasay/software -xzvf freesurfer-Linux-7-1.0-full.tar.gz


#curl -L https://surfer.nmr.mgh.harvard.edu/fswiki/rel7downloads/freesurfer-linux-centos6_x86_64-7.1.1.tar.gz






