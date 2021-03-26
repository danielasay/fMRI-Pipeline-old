#Script to generate isi/stimulus durations based on desired parameters. Run this script from terminal via
# "Rscript <scriptName>.R "s1234" where s1234 is the intended subject number


### Set working directory where file should be sent
workDir <- "/Users/dasay/aging/BIDS/"


### Import terminal argument, make subjDir
args <- commandArgs(TRUE)
subj <- as.character(args[1])
subjDir <- paste0(workDir, subj)
dir.create(file.path(subjDir))

#Function that generates stimulus durations based on specifications
# num_stim is the number of stimuli you have, stim_dur is how many miliseconds they must fit into
# min_dur and max_dur define the range that durations must fall within (in miliseconds)

num_stim <- 126
stim_dur <- 126000
min_dur <- 500
max_dur <- 1500

stim_list_function <- function(num_stim, stim_dur){
max_iter <- 100000; count <- 1
while (count <= max_iter) {
  unif_samp <- round(runif(num_stim,min = min_dur,max = max_dur))
  sum_samp <- sum(unif_samp)
  if(sum_samp != stim_dur) {
    count <- count+1
  }
  else{break}
}
if(sum_samp==stim_dur){
  stimulus_list <- as.data.frame(unif_samp)
}
return(stimulus_list)
}

#Call function

stimulus_list <- stim_list_function(num_stim, stim_dur)
print(stimulus_list)
sum(stimulus_list$unif_samp)

fileName <- paste0(subj,"_isi_list.csv")
colnames(stimulus_list) <- c("ISI Duration")
write.table(stimulus_list,paste0(subjDir,"/",fileName), quote = F, row.names = F, sep = '\t', eol = "\r\n")
