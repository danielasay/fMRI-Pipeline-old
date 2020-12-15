#!/bin/bash

3dttest++ -paired -prefix all_novel_vs_all_repeated -mask ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/func/MST_full_mask.nii \
-setA ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/afni_out/stats.MST.sub-alena+tlrc.BRIK[169] \
-setB ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/afni_out/stats.MST.sub-alena+tlrc.BRIK[172]

cp all_novel_vs_all_repeated ~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/afni_out

rm all_novel_vs_all_repeated