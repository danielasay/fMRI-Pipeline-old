#!/bin/bash

cd ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/func


#Smooth the fmriprep output with a 4mm kernel

#First FN func

for run in 1 2; do
  3dBlurToFWHM -FWHM 4.0 -prefix FN_r${run}_blur.nii -mask sub-alena_task-FN_run-${run}_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz \
          sub-alena_task-FN_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
done

#Second MST func

for run in 1 2; do
  3dBlurToFWHM -FWHM 4.0 -prefix MST_r${run}_blur.nii -mask sub-alena_task-MST_run-${run}_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz \
          sub-alena_task-MST_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
done

#Scale the data to 100

#First FN func

for run in 1 2; do
  	3dTstat -prefix rm._FN_mean_r${run}.nii FN_r${run}_blur.nii
  	3dcalc -a FN_r${run}_blur.nii -b rm._FN_mean_r${run}.nii \
         -c sub-alena_task-FN_run-${run}_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz                            \
         -expr 'c * min(200, a/b*100)*step(a)*step(b)'       \
         -prefix FN_r${run}_scale.nii
done
rm rm*

#Second MST func

for run in 1 2; do
  	3dTstat -prefix rm._MST_mean_r${run}.nii MST_r${run}_blur.nii
  	3dcalc -a MST_r${run}_blur.nii -b rm._MST_mean_r${run}.nii \
         -c sub-alena_task-MST_run-${run}_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz                            \
         -expr 'c * min(200, a/b*100)*step(a)*step(b)'       \
         -prefix MST_r${run}_scale.nii
done
rm rm*

# Take a Union of both created masks for each task

3dmask_tool -inputs *FN*mask.nii.gz -union -prefix FN_full_mask.nii
3dmask_tool -inputs *MST*mask.nii.gz -union -prefix MST_full_mask.nii


