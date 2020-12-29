#!/bin/bash

work_dir=~/Desktop/fmri


#Check that ROI list csv file exists

cd ${work_dir}

if [ ! -f ROIlist.txt ]; then
	echo "***************"
	echo "Create and populate ROIlist.txt with desired ROIs before continuing."
	echo "Each ROI should have its own row, insert the word 'placeholder' in row after last ROI."
	echo "Exiting...."
	echo "***************"
	exit 1
else 
	wc -l ROIlist.txt | awk '{print $1}'
	echo "ROIs"
fi



#Resample the data so that it's dimensions and reolution matches
## Must go into AFNI GUI and generate ROI tlrc files. See https://andysbrainbook.readthedocs.io/en/latest/AFNI/AFNI_Short_Course/AFNI_08_ROIAnalysis.html for instructions on how to do so.

#for ROI in `cat ROIlist.txt`; do

#3dresample -master ${work_dir}/stats.12.18.20.BLOCKpilot_201006_FNAME+tlrc -input ${work_dir}/${ROI}+tlrc -prefix ${work_dir}/${ROI}_rs+tlrc

#done

######## NOTE, you will get error messages if the -prefix data already exists. Don't worry if this happens. #####################

#Extract Beta-weights from from bucket file

for subj in `cat subjList.txt`; do

3dinfo -verb ${work_dir}/stats.12.18.20.${subj}+tlrc. > ${work_dir}/${subj}_3dinfo.txt
cat ${work_dir}/${subj}_3dinfo.txt | grep "GLT#0_Coef"

done

cd ${work_dir}

if [ ! -d ${work_dir}/beta_weights ]; then
	mkdir ${work_dir}/beta_weights
	echo "Making beta_weights directory"
fi

# For the next command, you must have to insert the sub-brick numbers associated with the 'Coef' that the last command spat out.
# In our case, we are interested in the difference between the novel and repetition trials. These are sub-bricks 41, 44 and 47.
# Uncomment the commands when you have entered the correct numbers in brackets.

: <<'END'

for ROI in `cat ${work_dir}/ROIlist.txt`; do

3dmaskdump -o ${work_dir}/beta_weights/${ROI}.novel.FNAME.txt -nozero -noijk -xyz -mask ${work_dir}/${ROI}_rs+tlrc ${work_dir}/stats.12.18.20.BLOCKpilot_201006_FNAME+tlrc'[44]'

3dmaskdump -o ${work_dir}/beta_weights/${ROI}.repeated.FNAME.txt -nozero -noijk -xyz -mask ${work_dir}/${ROI}_rs+tlrc ${work_dir}/stats.12.18.20.BLOCKpilot_201006_FNAME+tlrc'[47]'

cd ${work_dir}/beta_weights


awk '{ print $4 }' ${ROI}.novel.FNAME.txt > ${ROI}_novel.FNAME.csv

awk '{ print $4 }' ${ROI}.repeated.FNAME.txt > ${ROI}_repeated.FNAME.csv


done

rm *.txt

# Create ROIlist.csv file for ease of statistical analysis in R. Should look exact same as ROIlist.txt file. 

cd ${work_dir}

if [ ! -f ROIlist.csv ]; then
	sed 's/ \+/,/g' ROIlist.txt > ROIlist.csv
fi


###### MANUAL ACTION REQUIRED####### Go into the beta_script.R and change the subject name to the current subject
#### Call R script to run paired sample t-tests on each of the ROIs comparing novel vs repeated and novel vs lure

for subj in `cat subjList.txt`; do
	code
	echo "Running T tests..."
	Rscript beta_script.R ${subj}
	echo "Done!"
done

cd ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stat_results;ls 

echo "Open these files to see t test results."


