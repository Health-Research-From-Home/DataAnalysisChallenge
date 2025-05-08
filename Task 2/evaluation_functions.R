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
                           input = "data.frame",
                           training_input = "data.frame",
                           training_target = "data.frame",
                           counter = 'numeric',
                           penalty = 'numeric'
                         ))

Evaluator$methods(
  initialize = function() {
    
    # Set the field values
    .self$input <- read.csv(text = getURL('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/template_input.csv'))
    .self$counter <- 0
    .self$penalty <- 0
    
    # Perform validation checks
    if (!is.data.frame(input)) {
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
  
  to_retrieve <- .self$input[.self$input['day']<=30,]
  
  return(to_retrieve)
  
})

# Retrieve evaluation data (30 to 150 days)
Evaluator$methods(retrieve_evaluation_extra = function(to_sample) {
  
  # Check days are between 30 and 150
  if ((min(to_sample$day)<=30)|(max(to_sample$day)>=151)) {
    stop("Days are out of the 31 to 150 range!")
  }
  
  # What do we retrieve?
  to_retrieve <- merge(to_sample,.self$input, by=c('patid','day'), sort = FALSE,
                       all.x = TRUE)
  
  # Add rows to counter
  .self$counter <- .self$counter + nrow(to_retrieve)
  
  # Use the days of these rows to add to the penalty
  .self$penalty <- .self$penalty + sum(1/(151-to_retrieve$day))
  
  return(to_retrieve)
  
})

# Final evaluation
Evaluator$methods(final_evaluation = function(pred_df) {
  
  # Make sure pred_df has the three columns, and pred is rounded
  p_df <- pred_df %>%
    select(patid,day,measurement) %>%
    mutate(measurement = round(measurement)) %>%
    mutate(measurement = pmin(pmax(measurement, 0), 10))
  
  # Open test target
  target_df <- read.csv(text = getURL('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/template_target.csv'))
  # Rename measurement to target_measurement
  target_df <- target_df %>%
    rename(target_measurement = measurement)
  
  # Merge predictions
  target_df <- merge(target_df,p_df, by=c('patid','day'), sort = FALSE,
                       all.x = TRUE)
  
  # Calculate Kappa
  kws <- cohen.kappa(cbind(target_df['target_measurement'],target_df['measurement']))$weighted.kappa
  
  # Final score
  final_score <- kws - 0.0005*.self$penalty
  
  print(paste("THE SCORE IS:",kws))
  print(paste("WITH ROWS SAMPLED:",.self$counter))
  print(paste("AND PENALTY:",.self$penalty))
  print(paste("GIVING A FINAL SCORE OF:",final_score))
  
})
