# Make sure these functions are installed
packages <- c("tidyverse", "methods", "RCurl", "psych")
to_install <- packages[!packages %in% installed.packages()]
if (length(to_install)) install.packages(to_install)
lapply(packages, library, character.only = TRUE)

# Import libraries
library(tidyverse)
library(methods)
library(RCurl)
library(psych)

Evaluator <- setRefClass("Evaluator",
                         fields = list(
                           input_real = "data.frame",
                           training_input = "data.frame",
                           training_target = "data.frame",
                           counter_real = 'numeric',
                           penalty_real = 'numeric'
                         ))

Evaluator$methods(
  initialize = function() {
    
    print("HRFH: Evaluator started.")
    
    # Set the field values
    .self$input_real <- read.csv(text = getURL('https://gist.githubusercontent.com/jaurioles/3aca8862c0cc9e56994f32c040d4580f/raw/ae1b0d29850557ac2b40f1a7a737c5e331bdbe21/evaluation_input.csv'))
    .self$counter_real <- 0
    .self$penalty_real <- 0
    
    # Perform validation checks
    if (!is.data.frame(input_real)) {
      stop("Error: Incorrect input, check that you have internet connection.")
    }
    
    # Get training data
    .self$training_input <- read.csv(text = getURL('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/training_input.csv'))
    .self$training_target <- read.csv(text = getURL('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/training_target.csv'))
    
    # Call the parent method
    callSuper()
  }
)

# Training Methods --------------------------------------------------------

# Retrieve training data (first 30 days)
Evaluator$methods(retrieve_training_free = function() {
  
  to_retrieve <- .self$training_input[.self$training_input['day']<=30,]
  
  return(to_retrieve)
  
})

# Retrieve training data (days 30 to 150)
Evaluator$methods(retrieve_training_extra = function(to_sample) {
  
  # Check days are between 30 and 150
  if ((min(to_sample$day)<=30)|(max(to_sample$day)>=151)) {
    stop("Days are out of the 31 to 150 range!")
  }
  
  # What do we retrieve?
  to_retrieve <- merge(to_sample,.self$training_input, by=c('patid','day'), sort = FALSE,
                       all.x = TRUE)
  
  return(to_retrieve)
  
})

# Retrieve training target (last 30 days)
Evaluator$methods(retrieve_training_target = function() {
  
  to_retrieve <- .self$training_target
  
  return(to_retrieve)
  
})

# Evaluation methods ------------------------------------------------------

# Retrieve evaluation data (first 30 days)
Evaluator$methods(retrieve_evaluation_free = function() {
  
  print("HRFH: Free data retrieved.")
  
  to_retrieve <- .self$input_real[.self$input_real['day']<=30,]
  
  return(to_retrieve)
  
})

# Retrieve evaluation data (30 to 150 days)
Evaluator$methods(retrieve_evaluation_extra = function(to_sample) {
  
  print("HRFH: Extra samples.")
  
  # Check days are between 30 and 150
  if ((min(to_sample$day)<=30)|(max(to_sample$day)>=151)) {
    stop("Days are out of the 31 to 150 range!")
  }
  
  # What do we retrieve?
  to_retrieve <- merge(to_sample,.self$input_real, by=c('patid','day'), sort = FALSE,
                       all.x = TRUE)
  
  # Add rows to counter_real
  .self$counter_real <- .self$counter_real + nrow(to_retrieve)
  
  # Use the days of these rows to add to the penalty_real
  .self$penalty_real <- .self$penalty_real + sum(1/(151-to_retrieve$day))
  
  return(to_retrieve)
  
})

# Final evaluation
Evaluator$methods(final_evaluation = function(pred_df) {
  
  print("HRFH: Final evaluation.")
  
  # Make sure pred_df has the three columns, and pred is rounded
  p_df <- pred_df %>%
    select(patid,day,measurement) %>%
    mutate(measurement = round(measurement)) %>%
    mutate(measurement = pmin(pmax(measurement, 0), 10))
  
  # Open test target
  target_df <- read.csv(text = getURL('https://gist.githubusercontent.com/jaurioles/3aca8862c0cc9e56994f32c040d4580f/raw/ae1b0d29850557ac2b40f1a7a737c5e331bdbe21/evaluation_target.csv'))
  # Rename measurement to target_measurement
  target_df <- target_df %>%
    rename(target_measurement = measurement)
  
  # Merge predictions
  target_df <- merge(target_df,p_df, by=c('patid','day'), sort = FALSE,
                     all.x = TRUE)
  
  # Calculate Kappa
  kws <- cohen.kappa(cbind(target_df['target_measurement'],target_df['measurement']))$weighted.kappa
  
  # Final score
  final_score <- kws - 0.0005*.self$penalty_real
  
  print(paste("HRFH: THE SCORE IS:",kws))
  print(paste("HRFH: WITH ROWS SAMPLED:",.self$counter_real))
  print(paste("HRFH: AND PENALTY:",.self$penalty_real))
  print(paste("HRFH: GIVING A FINAL SCORE OF:",final_score))
  
})
