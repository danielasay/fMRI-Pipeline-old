#!/bin/bash


# Script to generate nifty files for anatomical, functional and field maps

cd ~/research_bin/r01/BIDS/

#### Update for loops to have one specific patient ID#####

for i in sub*; do 

# T1 dicom to nifti

mkdir ${i}/anat

dcm2niix \
  -o ${i}/anat/ \
  -x n \
  -f ${i}_T1w \
  -z n \
  ~/research_bin/r01/DICOM/${i}/T1 # input DICOM directory

# T2 dicom to nifty

dcm2niix \
	-o ${i}/anat \
	-x n \
	-f ${i}_T2w \
	-z n \
	~/research_bin/r01/DICOM/${i}/T2 # input DICOM directory

# MST run 1 dicom to nifty

mkdir ${i}/func

dcm2niix \
	-o ${i}/func \
	-x n \
	-f ${i}_task-MST_run-1_bold \
	-z n \
	~/research_bin/r01/DICOM/${i}/mst_run_1

# MST run 2 dicom to nifty

dcm2niix \
	-o ${i}/func \
	-x n \
	-f ${i}_task-MST_run-2_bold \
	-z n \
	~/research_bin/r01/DICOM/${i}/mst_run_2

# FN run 1 dicom to nifty

dcm2niix \
	-o ${i}/func \
	-x n \
	-f ${i}_task-FN_run-1_bold \
	-z n \
	~/research_bin/r01/DICOM/${i}/fn_run_1


# FN run 2 dicom to nifty

dcm2niix \
	-o ${i}/func \
	-x n \
	-f ${i}_task-FN_run-2_bold \
	-z n \
	~/research_bin/r01/DICOM/${i}/fn_run_2

# MST Field map generation

dcm2niix \
	-o ${i}/func \
	-x n \
	-f ${i}_task-MST_field_maps \
	-z n \
	~/research_bin/r01/DICOM/${i}/mst_field_map

# FN field map generation

dcm2niix \
	-o ${i}/func \
	-x n \
	-f ${i}_task-FN_field_maps \
	-z n \
	~/research_bin/r01/DICOM/${i}/fn_field_map

done

# copy events tsv files from dropbox to func directory

mst_events="~/Dropbox/McDonald_Lab/Daniel/Tasks/MST/MST_log_files/${i}"

fn_events="~/Dropbox/McDonald_Lab/Daniel/Tasks/FNAME/FN_tsv_files/${i}"


##### Update for loop to have specific patient ID #######


for i in sub*; do

# copy tsv event files from dropbox for MST runs 1 and 2

cp ${mst_events}/${i}_task-MST_run-1_events.tsv ~/research_bin/r01/BIDS/${i}/func

cp ${mst_events}/${i}_task-MST_run-2_events.tsv ~/research_bin/r01/BIDS/${i}/func

# copy tsv event files from dropbox for FN runs 1 and 2

cp ${fn_events}/${i}_task-FN_run-1_events.tsv ~/research_bin/r01/BIDS/${i}/func

cp ${fn_events}/${i}_task-FN_run-2_events.tsv ~/research_bin/r01/BIDS/${i}/func

done

########## MANUAL ACTION REQUIRED ##########

# add patient to participants.tsv file

#echo "patient_ID" >> participants.tsv #quotation marks are necessary, just change portion that says patient_ID

# send updated participants.tsv file to .15 machine

scp participants.tsv dasay@137.110.172.15:~/r01_data/

######### MANUAL ACTION REQUIRED ############

# Send nifty files to .15 machine

scp -r sub-alena dasay@137.110.172.15:~/r01_data/