# -----------------------------------------------------
# 0. Preparation
# -----------------------------------------------------

# Load packages
pacman::p_load(here, rio, tidyverse, forecast, zoo)

# Anchor code
here::i_am("evaluation_template.R")

# -----------------------------------------------------
# 0.1 Preparing my model
# -----------------------------------------------------

source("model.R")

# -----------------------------------------------------
# 1. Importing evaluator and data
# -----------------------------------------------------

# Source evaluation functions
source("evaluation_functions.R")

# Import single instance of Evaluator
evaluator <- Evaluator()

# -----------------------------------------------------
# 1.1 Import free data
# -----------------------------------------------------

# Import free data
free_data <- evaluator$retrieve_evaluation_free()

# -----------------------------------------------------
# 1.2 Determining which extra rows you’d like to sample
# -----------------------------------------------------

# Create a new dataframe for requesting new samples
patids_unique <- data.frame(patid = unique(free_data['patid']))

# Sample additional days 60, 90, and 120 for each patient
patid_days <- list()
for(i in patids_unique$patid){
    patid_days[[i]] <- data.frame(patid = i, day = c(60, 90, 120))
}
to_sample <- bind_rows(patid_days, .id = "ID") %>% select(-ID)

# Retrieve additional columns
retrieved_sample <- evaluator$retrieve_evaluation_extra(to_sample)

# Append to our dataframe
evaluation_df <- rbind(free_data,retrieved_sample)  %>%
  arrange(patid,day)

# -----------------------------------------------------
# 2 CALCULATING YOUR SCORE
# -----------------------------------------------------

# -----------------------------------------------------
# 2.1 Generating your predictions
# -----------------------------------------------------

# Generate predictions
pred_df <- arima_model_function(evaluation_df)

# -----------------------------------------------------
# 2.2 Final Evaluation
# -----------------------------------------------------

evaluator$final_evaluation(pred_df)
