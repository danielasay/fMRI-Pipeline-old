#!/bin/bash


#SBATCH --job-name="fmriprep"
#SBATCH --output="fmriprep.%j.%N.out"
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --export=ALL
#SBATCH -t 1:00:00

#to run locally
#fmriprep-docker /Users/dasay/research_bin/single_subject_data /Users/dasay/research_bin/single_subject_data/derivatives participant --participant-label 1425 --fs-license-file /Users/dasay/license.txt

#to run on .15
# export the PATH
#export PATH="/home/dasay/.local/bin:$PATH"
#fmriprep-docker /home/dasay/data/ /home/dasay/data/derivatives participant --participant-label 1428 --fs-license-file /home/dasay/license/license.txt

#super computer run

#fmriprep-docker /home/dasay/research_bin/single_subject_data /home/dasay/compute/single_subject_data/derivatives participant --participant-label ${i} --fs-license-file /home/dasay/license.txt

#singularity run --cleanenv fmriprep.img \
#    /home/dasay/compute/single_subject_data /home/dasay/derivatives \
#    participant \
#    --participant-label sub-${i}

#




BIDS_DIR="$STUDY/data"
DERIVS_DIR="derivatives/fmriprep-20.1.1"
LOCAL_FREESURFER_DIR="$STUDY/data/derivatives/freesurfer-7.1.1"

# Prepare some writeable bind-mount points.
TEMPLATEFLOW_HOST_HOME=$HOME/.cache/templateflow
FMRIPREP_HOST_CACHE=$HOME/.cache/fmriprep
mkdir -p ${TEMPLATEFLOW_HOST_HOME}
mkdir -p ${FMRIPREP_HOST_CACHE}

# Prepare derivatives folder
mkdir -p ${BIDS_DIR}/${DERIVS_DIR}

# Make sure FS_LICENSE is defined in the container.
export SINGULARITYENV_FS_LICENSE=$HOME/license.txt

# Designate a templateflow bind-mount point
export SINGULARITYENV_TEMPLATEFLOW_HOME="/templateflow"
SINGULARITY_CMD="singularity run --cleanenv -B $BIDS_DIR:/data -B ${TEMPLATEFLOW_HOST_HOME}:${SINGULARITYENV_TEMPLATEFLOW_HOME} -B $L_SCRATCH:/work -B ${LOCAL_FREESURFER_DIR}:/fsdir $STUDY/images/poldracklab_fmriprep_1.5.0.simg"

# Parse the participants.tsv file and extract one subject ID from the line corresponding to this SLURM task.
subject=$( sed -n -E "$((${SLURM_ARRAY_TASK_ID} + 1))s/sub-(\S*)\>.*/\1/gp" ${BIDS_DIR}/participants.tsv )

# Remove IsRunning files from FreeSurfer
find ${LOCAL_FREESURFER_DIR}/sub-$subject/ -name "*IsRunning*" -type f -delete

# Compose the command line
cmd="${SINGULARITY_CMD} /data /data/${DERIVS_DIR} participant --participant-label $subject -w /work/ -vv --omp-nthreads 8 --nthreads 12 --mem_mb 30000 --output-spaces MNI152NLin2009cAsym:res-2 anat fsnative fsaverage5 --use-aroma --fs-subjects-dir /fsdir"

# Setup done, run the command
echo Running task ${SLURM_ARRAY_TASK_ID}
echo Commandline: $cmd
eval $cmd
exitcode=$?

# Output results to a table
echo "sub-$subject   ${SLURM_ARRAY_TASK_ID}    $exitcode" \
      >> ${SLURM_JOB_NAME}.${SLURM_ARRAY_JOB_ID}.tsv
echo Finished tasks ${SLURM_ARRAY_TASK_ID} with exit code $exitcode
exit $exitcode

