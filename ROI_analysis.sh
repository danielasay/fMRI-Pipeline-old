s#!/bin/bash

afni_dir=~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/afni_out
ROI_dir=~/research_bin/r01/BIDS/derivatives/fmriprep/ROI_masks
BIDS_dir=~/research_bin/r01/BIDS
beta_dir=~/research_bin/r01/BIDS/beta_weights
code_dir=~/research_bin/r01/code

#Check that ROI list csv file exists

cd ${BIDS_dir}

if [ ! -f ROIlist.txt ]; then
	echo "Create and populate ROIlist.txt with desired ROIs before continuing."
	echo "Each ROI should have its own row, insert the word placeholder in row after last ROI."
	exit
else 
	wc -l ROIlist.txt | awk '{print $1}'
	echo "ROIs"
fi

#Resample the data so that it's dimensions and reolution matches
## Must go into AFNI GUI and generate ROI tlrc files. See https://andysbrainbook.readthedocs.io/en/latest/AFNI/AFNI_Short_Course/AFNI_08_ROIAnalysis.html for instructions on how to do so.

for ROI in `cat ROIlist.txt`; do

3dresample -master ${afni_dir}/stats.MST.sub-alena+tlrc -input ${ROI_dir}/${ROI}+tlrc -prefix ${ROI_dir}/${ROI}_rs+tlrc

done

######## NOTE, you will get error messages if the -prefix data already exists. Don't worry if this happens. #####################

#Extract Beta-weights from from bucket file

for subj in `cat subjList.txt`; do

3dinfo -verb ${afni_dir}/stats.MST.${subj}+tlrc. > ${afni_dir}/${subj}_3dinfo.txt
cat ${afni_dir}/${subj}_3dinfo.txt | grep "GLT#0_Coef"

done

cd ${afni_dir}

if [ ! -d ${BIDS_dir}/beta_weights/sub-alena ]; then
	mkdir ${BIDS_dir}/beta_weights/sub-alena
	echo "Making beta_weights directory"
fi

# For the next command, you must have to insert the sub-brick numbers associated with the 'Coef' that the last command spat out.
# In our case, we are interested in the difference between the novel and repetition trials. These are sub-bricks 76 and 79.
# Uncomment the commands when you have entered the correct numbers in brackets.

for ROI in `cat ${BIDS_dir}/ROIlist.txt`; do

3dmaskdump -o ${BIDS_dir}/beta_weights/sub-alena/${ROI}.novel.MST.txt -nozero -noijk -xyz -mask ${ROI_dir}/${ROI}_rs+tlrc ${afni_dir}/stats.MST.sub-alena+tlrc'[76]'

3dmaskdump -o ${BIDS_dir}/beta_weights/sub-alena/${ROI}.repeated.MST.txt -nozero -noijk -xyz -mask ${ROI_dir}/${ROI}_rs+tlrc ${afni_dir}/stats.MST.sub-alena+tlrc'[79]'

cd ${BIDS_dir}/beta_weights/sub-alena

awk '{ print $4 }' ${ROI}.novel.MST.txt > ${ROI}_novel.MST.csv

awk '{ print $4 }' ${ROI}.repeated.MST.txt > ${ROI}_repeated.MST.csv

rm *.txt

done


# Create ROIlist.csv file for ease of statistical analysis in R. Should look exact same as ROIlist.txt file. 

cd ${BIDS_dir}

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





























































#for subj in `cat subjList.txt`; do
	#for cond in `cat condlist.txt`; do
		#for ROI in `cat ROIlist.txt`; do
			#Rscript ${code_dir}/beta_script.R ${subj} ${beta_dir}/${subj}/${ROI}_${cond}.MST.csv
