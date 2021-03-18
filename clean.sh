#!/bin/bash

dicom_num=`ls m* | wc -l`

counter=1

while [ "$counter" -lt "$dicom_num" ]; do
	for i in m000*; do
		mv ${i} 00${counter}.dcm
		((counter=counter+1))
	done
done
