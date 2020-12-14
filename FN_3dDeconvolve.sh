#!/bin/bash


work_dir=~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/func
stim_dir=~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stimuli

cd $work_dir

#3dDeconvolve script to create GLM for FN data

3dDeconvolve -input FN_r*_scale.nii                            \
    -mask FN_full_mask.nii						     \
    -polort A                                                                \
    -num_stimts 15                                                           \
    -stim_times 1 ${stim_dir}/FN/novel.1D 'BLOCK(2.5,1)'              \
    -stim_label 1 novel                                                 \
    -stim_times 2 ${stim_dir}/FN/repeated.1D 'BLOCK(2.5,1)'                \
    -stim_label 2 repeated                                                 \
    -stim_times 3 ${stim_dir}/FN/arrow.1D 'BLOCK(2.5,1)'                \
    -stim_label 3 arrow                                                  \
    -stim_file 4 FN_trans_x_run1.txt'[0]' -stim_base 4 -stim_label 4 FN_trans_x_01   \
    -stim_file 5 FN_trans_y_run1.txt'[0]' -stim_base 5 -stim_label 5 FN_trans_y_01   \
    -stim_file 6 FN_trans_z_run1.txt'[0]' -stim_base 6 -stim_label 6 FN_trans_z_01   \
    -stim_file 7 FN_rot_x_run1.txt'[0]' -stim_base 7 -stim_label 7 FN_rot_x_01     \
    -stim_file 8 FN_rot_y_run1.txt'[0]' -stim_base 8 -stim_label 8 FN_rot_y_01     \
    -stim_file 9 FN_rot_z_run1.txt'[0]' -stim_base 9 -stim_label 9 FN_rot_z_01     \
    -stim_file 10 FN_trans_x_run2.txt'[0]' -stim_base 10 -stim_label 10 FN_trans_x_02   \
    -stim_file 11 FN_trans_y_run2.txt'[0]' -stim_base 11 -stim_label 11 FN_trans_y_02    \
    -stim_file 12 FN_trans_z_run2.txt'[0]' -stim_base 12 -stim_label 12 FN_trans_z_02 \
    -stim_file 13 FN_rot_x_run2.txt'[0]' -stim_base 13 -stim_label 13 FN_rot_x_02  \
    -stim_file 14 FN_rot_y_run2.txt'[0]' -stim_base 14 -stim_label 14 FN_rot_y_02  \
    -stim_file 15 FN_rot_z_run2.txt'[0]' -stim_base 15 -stim_label 15 FN_rot_z_02  \
    -jobs 3                                                      \
    -num_glt 16                                                  \
    -gltsym 'SYM: arrow -repeated'				     \
    -glt_label 1 arrow-repeated					     \
    -gltsym 'SYM: repeated -arrow'				     \
    -glt_label 2 repeated-arrow                       \




    -glt_label 2 rep_smaller-novel_smaller					     \
    -gltsym 'SYM: novel_smaller -rep_larger'                   \
    -glt_label 3 novel_smaller-rep_larger                      \
    -gltsym 'SYM: -rep_larger -novel_smaller'                    \
    -glt_label 4 rep_larger-novel_smaller                     \
    -gltsym 'SYM: novel_smaller -lure_smaller'                    \
    -glt_label 5 novel_smaller-lure_smaller                       \
    -gltsym 'SYM: lure_smaller -novel_smaller'                    \
    -glt_label 6 lure_smaller-novel_smaller                       \
    -gltsym 'SYM: novel_smaller -lure_larger'                    \
    -glt_label 7 novel_smaller-lure_larger                       \
    -gltsym 'SYM: lure_larger -novel_smaller'                    \
    -glt_label 8 lure_larger-novel_smaller                       \
    -gltsym 'SYM: novel_larger -rep_smaller'                   \
    -glt_label 9 novel_larger-rep_smaller                       \
    -gltsym 'SYM: rep_smaller -novel_larger'                    \
    -glt_label 10 rep_smaller-novel_larger                       \
    -gltsym 'SYM: novel_larger -rep_larger'                   \
    -glt_label 11 novel_larger-rep_larger                      \
    -gltsym 'SYM: -rep_larger -novel_larger'                    \
    -glt_label 12 rep_larger-novel_larger                     \
    -gltsym 'SYM: novel_larger -lure_smaller'                    \
    -glt_label 13 novel_larger-lure_smaller                       \
    -gltsym 'SYM: lure_smaller -novel_larger'                    \
    -glt_label 14 lure_smaller-novel_larger                       \
    -gltsym 'SYM: novel_larger -lure_larger'                    \
    -glt_label 15 novel_larger-lure_larger                       \
    -gltsym 'SYM: lure_larger -novel_larger'                    \
    -glt_label 16 lure_larger-novel_larger                       \
    -fout -tout -x1D X.FN.xmat.1D -xjpeg X.FN.sub-alena.jpg     \
    -x1D_uncensored X.nocensor.xmat.sub-alena.1D                 \
    -fitts fitts.FN.sub-alena                                    \
    -errts errts.FN.sub-alena                                     \
    -bucket stats.FN.sub-alena



cp *.FN.sub-alena* ../afni_out