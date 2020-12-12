
beta_dir <- "~/research_bin/r01/BIDS/beta_weights"

#args <- commandArgs(TRUE)
#subj <- "sub-alena"
#subj <- as.character(args[1])
#subjDir <- paste0(beta_dir, subj)
#dir.create(file.path(subjDir))

#Right Dentate Gyrus Novel vs Repeated

r_dentate_novel <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_dentate_novel.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_dentate_repeated <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_dentate_repeated.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_dentate_ttest_results <- t.test(r_dentate_novel$V1, r_dentate_repeated$V1, paired = TRUE, alternative = "two.sided")

#Right CA3 Novel vs Repeated 

r_CA3_novel <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_CA3_novel.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_CA3_repeated <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_CA3_repeated.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_CA3_ttest_results <- t.test(r_CA3_novel$V1, r_CA3_repeated$V1, paired = TRUE, alternative = "two.sided")

#Right Hippocampus Novel vs Repeated

r_whole_hipp_novel <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/r_hipp_novel.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_whole_hipp_repeated <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/r_hipp_repeated.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_whole_hipp_ttest_results <- t.test(r_whole_hipp_novel$V1, r_whole_hipp_repeated$V1, paired = TRUE, alternative = "two.sided")

#Right Caudate Novel vs Repeated

r_caudate_novel <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_caudate_novel.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_caudate_repeated <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_caudate_repeated.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_caudate_ttest_results <- t.test(r_caudate_novel$V1, r_caudate_repeated$V1, paired = TRUE, alternative = "two.sided")

#Right precentral gyrus Novel vs Repeated

r_precentral_gyrus_novel <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_precentral_gyrus_novel.MST.csv", header = FALSE, stringsAsFactors = FALSE)

r_precentral_gyrus_repeated <- read.csv("~/research_bin/r01/BIDS/beta_weights/sub-alena/right_precentral_gyrus_repeated.MST.csv", header = FALSE, stringsAsFactors = FALSE)
  
r_precentral_gyrus_ttest_results <- t.test(r_precentral_gyrus_novel$V1, r_precentral_gyrus_repeated$V1, paired = TRUE, alternative = "two.sided") 
  

capture.output(r_caudate_ttest_results, file = "~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stat_results/sub-alena_r_caudate_results.txt", append = TRUE)
capture.output(r_dentate_ttest_results, file = "~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stat_results/sub-alena_r_dentate_results.txt", append = TRUE)
capture.output(r_whole_hipp_ttest_results, file = "~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stat_results/sub-alena_r_whole_hipp_results.txt", append = TRUE)
capture.output(r_precentral_gyrus_ttest_results, file = "~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stat_results/sub-alena_r_precentral_gyrus_results.txt", append = TRUE)
capture.output(r_CA3_ttest_results, file = "~/research_bin/r01/BIDS/derivatives/fmriprep/sub-alena/stat_results/sub-alena_r_CA3_results.txt", append = TRUE)


mean_r_dentate_novel <- mean(r_dentate_novel$V1)
mean_r_dentate_repeated <- mean(r_dentate_repeated$V1)
std_r_dentate_novel <- sd(r_dentate_novel$V1)
std_r_dentate_repeated <- sd(r_dentate_repeated$V1)
n_r_denate_novel <- 129 
n_r_dentate_repeated <- 129

novel_error <- qt(0.975, df = 128)*std_r_dentate_novel/sqrt(129)
lower_novel_CI <- mean_r_dentate_novel-novel_error
upper_novel_CI <- mean_r_dentate_novel+novel_error


repeated_error <- qt(0.975, df = 128)*std_r_dentate_repeated/sqrt(129)
lower_repeated_CI <- mean_r_dentate_repeated-repeated_error
upper_repeated_CI <- mean_r_dentate_repeated+repeated_error


