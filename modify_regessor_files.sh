#!/bin/bash

cd ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/func

#For loop to extract translation and rotation parameters from confound regressor files. One w/ headers, one w/o

#FN

for reg in trans_x trans_y trans_z rot_x rot_y rot_z; do
  for run in 1 2; do
    awk -v col=$reg 'NR==1{for(i=1;i<=NF;i++){if($i==col){c=i;break}} print $c} NR>1{print $c}' sub-alena_task-FN_run-${run}_desc-confounds_regressors.tsv > FN_${reg}_run${run}_all_tmp.txt;
    sed '1d' FN_${reg}_run${run}_all_tmp.txt > FN_${reg}_run${run}_noHead_tmp.txt
    sed '1!d' FN_${reg}_run${run}_all_tmp.txt > FN_${reg}_run${run}_Head_tmp.txt
  done
done

#MST

for reg in trans_x trans_y trans_z rot_x rot_y rot_z; do
  for run in 1 2; do
    awk -v col=$reg 'NR==1{for(i=1;i<=NF;i++){if($i==col){c=i;break}} print $c} NR>1{print $c}' sub-alena_task-MST_run-${run}_desc-confounds_regressors.tsv > MST_${reg}_run${run}_all_tmp.txt;
    sed '1d' MST_${reg}_run${run}_all_tmp.txt > MST_${reg}_run${run}_noHead_tmp.txt
    sed '1!d' MST_${reg}_run${run}_all_tmp.txt > MST_${reg}_run${run}_Head_tmp.txt
  done
done

#Create string of zeroes equal to number of volumes in first run

#FN

NT=`3dinfo -nt FN_r1_scale.nii`
if [ -f FN_zeros_tmp.txt ]; then rm FN_zeros_tmp.txt; fi
for ((i=0; i<$NT; i++)); do echo 0 >> FN_zeros_tmp.txt; done

#MST

NT=`3dinfo -nt MST_r1_scale.nii`
if [ -f MST_zeros_tmp.txt ]; then rm MST_zeros_tmp.txt; fi
for ((i=0; i<$NT; i++)); do echo 0 >> MST_zeros_tmp.txt; done

#Concatenate the file of zeroes with the run files

#FN

for reg in trans_x trans_y trans_z rot_x rot_y rot_z; do
  for run in 1 2; do
    if [ $run -eq 1 ]; then
      cat FN_${reg}_run${run}_noHead_tmp.txt > FN_${reg}_run${run}.txt
    else
      cat FN_zeros_tmp.txt FN_${reg}_run${run}_noHead_tmp.txt > FN_${reg}_run${run}.txt
    fi
  done
done

#MST

for reg in trans_x trans_y trans_z rot_x rot_y rot_z; do
  for run in 1 2; do
    if [ $run -eq 1 ]; then
      cat MST_${reg}_run${run}_noHead_tmp.txt > MST_${reg}_run${run}.txt
    else
      cat MST_zeros_tmp.txt MST_${reg}_run${run}_noHead_tmp.txt > MST_${reg}_run${run}.txt
    fi
  done
done
rm *tmp*













