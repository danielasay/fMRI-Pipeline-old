#!/bin/bash

# ====================== STEPS TO TAKE BEFORE RUNNING SCRIPT =====================
# type 'bash' in terminal. Hit enter.
# type 'source ~/.bash_profile' in terminal. Hit enter.
# execute command: source ANTs.sh > ANTS_output

for subj in BLOCKpilot_201006_FNAME; do


	datapath=~/data/MCD_BOLD/subjects 
	cd ${datapath}

	#create the diffeomorphic transformation in FLOAT32

	3dresample -dxyz 1 1 1 -prefix ~/data/atlases/${subj}_1x1x1_MNI.nii -input ~/data/atlases/MNI152_T1_3mm_brain.nii.gz

	antsRegistrationSyN.sh -d 3 -n 4 -f ~/data/atlases/${subj}_1x1x1_MNI.nii \
	 -m ${datapath}/${subj}/orig/anat_al.nii -o ${datapath}/${subj}/orig/MNI_reg_anat 


	 # -m needs to be a skullstripped brain


	for i in 1 2; do

	#3dAFNItoNIFTI ${datapath}/${subj}/orig/pb00.${subj}.r0${i}.tcat+orig.BRIK


	antsApplyTransforms -d 3 -e 3 -r ~/data/atlases/${subj}_2x2x2_MNI.nii \
	 -i ${datapath}/${subj}/orig/pb00.${subj}.r0${i}.tcat.nii \
	 -t ${datapath}/${subj}/orig/MNI_reg_anat1Warp.nii.gz \
	 -t ${datapath}/${subj}/orig/MNI_reg_anat0GenericAffine.mat -o ${datapath}/${subj}/orig/${subj}_MNI.r0${i}.nii.gz 

	 #Resample the data so that it's back in "AFNI form"

	 cd ${datapath}/${subj}/orig

	 3dresample -dxyz 2 2 2 -prefix MNI_2x2x2_${subj}.r0${i} -input ${datapath}/${subj}/orig/${subj}_MNI.r0${i}.nii.gz 

	 #delete this file as it is GB large
	 rm ${datapath}/${subj}/orig/${subj}_MNI.r0${i}.nii.gz 

	done 


done



