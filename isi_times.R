#Function that sums to "M" using "N" integers. Integers only.

rand_vect <- function(N, M, sd = 1, pos.only = TRUE) {
  vec <- rnorm(N, M/N, sd)
  if (abs(sum(vec)) < 0.01) vec <- vec + 1
  vec <- round(vec / sum(vec) * M)
  deviation <- M - sum(vec)
  for (. in seq_len(abs(deviation))) {
    vec[i] <- vec[i <- sample(N, 1)] + sign(deviation)
  }
  if (pos.only) while (any(vec < 0)) {
    negs <- vec < 0
    pos  <- vec > 0
    vec[negs][i] <- vec[negs][i <- sample(sum(negs), 1)] + 1
    vec[pos][i]  <- vec[pos ][i <- sample(sum(pos ), 1)] - 1
  }
  vec
}


#Function that sums to "M" using "N" numbers. Spits out decimals. 
library(spatstat.utils)


isi_generator <- function(N, M, sd =1, pos.only = TRUE) {
  vec <- rnorm(N, M/N, sd)
  vec / sum(vec) * M
  if (pos.only) while (any(vec < 0)) {
    negs <- vec < 0
    pos  <- vec > 0
    vec[negs][i] <- vec[negs][i <- sample(sum(negs), 1)] + 1
    vec[pos][i]  <- vec[pos ][i <- sample(sum(pos ), 1)] - 1
  }
  vec
}

#While loop to generate vector of needed ISI (or stimulus) lengths. All Durations in milliseconds
library(spatstat.utils)
max_stim_dur <- 1.5;min_stim_dur <- .5
stim_range <- min_stim_dur:max_stim_dur
N <- 9  ; M <- 7.375

list_function <- function(N,M){
max_iter <- 1000000; count <- 1
  while (count <= max_iter) {
    random_duration <- isi_generator(N,M)
      tf_range <- inside.range(random_duration, min_stim_dur:max_stim_dur)
      tf_status <- all(TRUE==tf_range)
        if(tf_status==FALSE) {
        count <- count+1
        }
  }
return(random_duration)
}
list_output <- list_function(N,M)
print(list_output)
check <- inside.range(list_output, min_stim_dur:max_stim_dur)

list_function_v2 <- function(N,M){
  
}

tf_status <- FALSE
  while(!tf_status){
    random_duration <- isi_generator(N,M)
    tf_range <- inside.range(random_duration, min_stim_dur:max_stim_dur)
    tf_status <- all(TRUE==tf_range)
  }






