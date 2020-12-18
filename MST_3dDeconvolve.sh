#!/bin/bash

work_dir=~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/func
stim_dir=~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stimuli

cd $work_dir

#3dDeconvolve script to create GLM for MST data

3dDeconvolve -input MST_r*_scale.nii                            \
    -mask MST_full_intersect_mask.nii						     \
    -polort A                                                              \
    -CENSORTR *:0-4                                                        \
    -num_stimts 15                                                         \
    -stim_times 1 ${stim_dir}/MST/MST_novel.1D 'TENT(0,14,12)'              \
    -stim_label 1 MST_novel                                                 \
    -stim_times 2 ${stim_dir}/MST/MST_rep.1D 'TENT(0,14,12)'                \
    -stim_label 2 MST_rep                                                  \
    -stim_times 3 ${stim_dir}/MST/MST_lure.1D 'TENT(0,14,12)'                \
    -stim_label 3 MST_lure                                                  \
    -stim_file 4 MST_trans_x_run1.txt'[0]' -stim_base 4 -stim_label 4 MST_trans_x_01   \
    -stim_file 5 MST_trans_y_run1.txt'[0]' -stim_base 5 -stim_label 5 MST_trans_y_01   \
    -stim_file 6 MST_trans_z_run1.txt'[0]' -stim_base 6 -stim_label 6 MST_trans_z_01   \
    -stim_file 7 MST_rot_x_run1.txt'[0]' -stim_base 7 -stim_label 7 MST_rot_x_01     \
    -stim_file 8 MST_rot_y_run1.txt'[0]' -stim_base 8 -stim_label 8 MST_rot_y_01     \
    -stim_file 9 MST_rot_z_run1.txt'[0]' -stim_base 9 -stim_label 9 MST_rot_z_01     \
    -stim_file 10 MST_trans_x_run2.txt'[0]' -stim_base 10 -stim_label 10 MST_trans_x_02   \
    -stim_file 11 MST_trans_y_run2.txt'[0]' -stim_base 11 -stim_label 11 MST_trans_y_02    \
    -stim_file 12 MST_trans_z_run2.txt'[0]' -stim_base 12 -stim_label 12 MST_trans_z_02 \
    -stim_file 13 MST_rot_x_run2.txt'[0]' -stim_base 13 -stim_label 13 MST_rot_x_02  \
    -stim_file 14 MST_rot_y_run2.txt'[0]' -stim_base 14 -stim_label 14 MST_rot_y_02  \
    -stim_file 15 MST_rot_z_run2.txt'[0]' -stim_base 15 -stim_label 15 MST_rot_z_02  \
    -jobs 3                                      \
    -num_glt 10                                  \
    -gltsym 'SYM: +1*MST_novel[3..8]'          \
    -glt_label 1 'MST_novel'                  \
    -gltsym 'SYM: +1*MST_rep[3..8]'                    \
    -glt_label 2 'MST_rep'                    \
    -gltsym 'SYM: +1*MST_lure'                   \
    -glt_label 3 'MST_lure'                     \
    -gltsym 'SYM: +1*MST_rep -1*MST_novel'      \
    -glt_label 4 'repeated_minus_novel_contrast'    \
    -gltsym 'SYM: +1*MST_novel -1*MST_lure'         \
    -glt_label 5 'novel_minus_lure_contrast'        \
    -gltsym 'SYM: +1*MST_lure -1*MST_rep'           \
    -glt_label 6 'lure_minus_rep_contrast'          \
    -gltsym 'SYM: +1*MST_lure -1*MST_novel'         \
    -glt_label 7 'lure_minus_novel_contrast'        \
    -gltsym 'SYM: +2*MST_rep -1*MST_novel'          \
    -glt_label 8 'double_rep_minus_novel_contrast'  \
    -gltsym 'SYM: +1*MST_novel -2*MST_rep'          \
    -glt_label 9 'novel_minus_double_rep_contrast'  \
    -gltsym 'SYM: 2*MST_rep'                        \
    -glt_label 10 'double_rep'                       \
    -fout -tout -x1D X.MST.xmat.1D -xjpeg X.MST.sub-alena.jpg     \
    -x1D_uncensored X.nocensor.xmat.sub-alena.1D                 \
    -fitts fitts.MST.sub-alena                                    \
    -errts errts.MST.sub-alena                                     \
    -bucket stats.MST.sub-alena_contrasts                                    \
    -iresp 1 MST_novel.resp                                     \
    -iresp 2 MST_rep.resp                                       \
    -iresp 3 MST_lure.resp                                        \
    -sresp 1 MST_novel.sresp                                    \
    -sresp 2 MST_rep.sresp                                     \
    -sresp 3 MST_lure.sresp                                      \
    #-sresp 4 rep_larger.sresp                                       \
    #-sresp 5 lure_smaller.sresp                                     \
    #-sresp 6 lure_larger.sresp                                      \


cp *.MST.* ../afni_out

cp *.BRIK ../afni_out
cp *.HEAD ../afni_out
cp *.1D ../afni_out

rm *.MST.*
rm *.BRIK
rm *.HEAD
rm *.1D

# TENT function calculation rationale; see https://afni.nimh.nih.gov/pub/dist/doc/misc/Decon/2007_0504_basis_funcs.html for parameters
# base function: TENT(b,c,n)
# b = 0  This is the start time of the scan after the stimulus, 0 in most cases.
# c = 14  This is the general expectation for how long the HRF will last for each trial 14 seconds is generally the norm. 
# n = 12    This is calculated based on the TR. Our TR here is 1.3. To solve, the TR should be equal to c/n-1. In this case, 1.3 = 14/n-1  
# solve the equation for n, and you get your answer. In this case, 11.77. Round up to the nearest TR. 


    #-gltsym 'SYM: novel_smaller[5..6]'          \
    #-glt_label 1 novel_smaller                  \
    #-gltsym 'SYM: novel_larger[5..6]'                 \
    #-glt_label 2 novel_larger                   \
    #-gltsym 'SYM: rep_smaller[5..6]'                    \
    #-glt_label 3 rep_smaller                    \
    #-gltsym 'SYM: rep_larger[5..6]'                   \
    #-glt_label 4 rep_larger                      \
    #-gltsym 'SYM: lure_smaller[5..6]'                   \
    #-glt_label 5 lure_smaller                     \
    #-gltsym 'SYM: lure_larger[5..6]'                    \
    #-glt_label 6 lure_larger                       \


 #-gltsym 'SYM: +1*novel_smaller[5..6] +1*novel_larger[5..6]' \
 #   -glt_label 1 'both_novel'                                 \
 #   -gltsym 'SYM: +2*rep_smaller[5..6] +2*rep_larger[5..6]'       \
 #   -glt_label 2 'both_repeat'                                \
 #   -gltsym 'SYM: +3*novel_smaller[5..6] +3*novel_larger[5..6] -3*rep_smaller[5..6] -3*rep_larger[5..6]' \
 #   -glt_label 3 'all_novel-all_repeat'                               \
 #   -gltsym 'SYM: +4*novel_smaller[5..6] +4*novel_larger[5..6] -4*lure_smaller[5..6] -4*lure_larger[5..6]' \
 #   -glt_label 4 'all_novel-all_lure'                                \

#-stim_times 1 ${stim_dir}/MST/novel_smaller.1D 'TENT(0,14,12)'              \
#    -stim_label 1 novel_smaller                                                 \
#    -stim_times 2 ${stim_dir}/MST/novel_larger.1D 'TENT(0,14,12)'                \
#    -stim_label 2 novel_larger                                                 \
#    -stim_times 3 ${stim_dir}/MST/rep_smaller.1D 'TENT(0,14,12)'                \
#    -stim_label 3 rep_smaller                                                  \
#    -stim_times 4 ${stim_dir}/MST/rep_larger.1D 'TENT(0,14,12)'                 \
#    -stim_label 4 rep_larger                                                   \
#    -stim_times 5 ${stim_dir}/MST/lure_smaller.1D 'TENT(0,14,12)'                \
#    -stim_label 5 lure_smaller                                                  \
#    -stim_times 6 ${stim_dir}/MST/lure_larger.1D 'TENT(0,14,12)'                 \
#    -stim_label 6 lure_larger                                                   \

 #-stim_file 7 MST_trans_x_run1.txt'[0]' -stim_base 7 -stim_label 7 MST_trans_x_01   \
 #   -stim_file 8 MST_trans_y_run1.txt'[0]' -stim_base 8 -stim_label 8 MST_trans_y_01   \
 #   -stim_file 9 MST_trans_z_run1.txt'[0]' -stim_base 9 -stim_label 9 MST_trans_z_01   \
 #   -stim_file 10 MST_rot_x_run1.txt'[0]' -stim_base 10 -stim_label 10 MST_rot_x_01     \
 #   -stim_file 11 MST_rot_y_run1.txt'[0]' -stim_base 11 -stim_label 11 MST_rot_y_01     \
 #   -stim_file 12 MST_rot_z_run1.txt'[0]' -stim_base 12 -stim_label 12 MST_rot_z_01     \
 #   -stim_file 13 MST_trans_x_run2.txt'[0]' -stim_base 13 -stim_label 13 MST_trans_x_02   \
 #   -stim_file 14 MST_trans_y_run2.txt'[0]' -stim_base 14 -stim_label 14 MST_trans_y_02    \
 #   -stim_file 15 MST_trans_z_run2.txt'[0]' -stim_base 15 -stim_label 15 MST_trans_z_02 \
 #   -stim_file 16 MST_rot_x_run2.txt'[0]' -stim_base 16 -stim_label 16 MST_rot_x_02  \
 #   -stim_file 17 MST_rot_y_run2.txt'[0]' -stim_base 17 -stim_label 17 MST_rot_y_02  \
 #   -stim_file 18 MST_rot_z_run2.txt'[0]' -stim_base 18 -stim_label 18 MST_rot_z_02  \

# -gltsym 'SYM: +1*MST_novel[6..10]'          \
#    -glt_label 1 'MST_novel'                  \
#    -gltsym 'SYM: +1*MST_rep[6..10]'                    \
#    -glt_label 2 'MST_rep'                    \
#    -gltsym 'SYM: +1*MST_lure[6..10]'                   \
#    -glt_label 3 'MST_lure'                     \
#    -gltsym 'SYM MST_novel[6..10] -MST_rep[6..10]'          \
#    -glt_label 4 'novel_minus_repeated_contrast'            \


    #-gltsym 'SYM MST_novel -MST_rep'          \
    #-glt_label 4 'novel_minus_repeated_contrast'            \
