import pandas as pd
import numpy as np
# For calculating the KWS
from sklearn.metrics import cohen_kappa_score

class Evaluator():
    
    def __init__(self):
        
        # Open the input data
        self.input = pd.read_csv('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/template_input.csv')
        
        # Get training data
        self.training_input = pd.read_csv('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/training_input.csv')
        self.training_target = pd.read_csv('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/training_target.csv')
    
        # Now we count over how many samples we take
        self.counter = 0
        
        # We also take into account the sampling penalty
        self.penalty = 0
    
    # Retrieve training data (first 30 days)
    def retrieve_training_free(self):
        
        # Only retrieves first 30 days
        input_free = (self.training_input[self.training_input.day<=30])
        
        return input_free
    
    # Retrieve training data (additional days between 30 and 150)
    def retrieve_training_extra(self,to_sample):
        
        # What do we retrieve?
        to_retrieve = to_sample.merge(self.training_input, on=['patid', 'day'], how='left')
        
        return to_retrieve
    
    # Retrieve training data (last 30 days)
    def retrieve_training_target(self):
    
        # Only retrieves last 30 days
        to_retrieve = self.training_target
        
        return to_retrieve
     
    # Retrieve evaluation data (first 30 days)
    def retrieve_evaluation_free(self):
        
        # Only retrieves first 30 days
        input_free = (self.input[self.input.day<=30])
        
        return input_free
    
    # Retrieve evaluation data (30 to 150 days)
    def retrieve_evaluation_extra(self,to_sample):
        
        # What do we retrieve?
        to_retrieve = to_sample.merge(self.input, on=['patid', 'day'], how='left')
        
        # Add rows to counter
        self.counter = self.counter + len(to_retrieve)
        
        # Use the days of these rows to add to the penalty
        self.penalty = self.penalty + np.sum(1/(151-to_retrieve['day']))
        
        return to_retrieve
    
    # Final evaluation
    def final_evaluation(self,pred_df):
        
        # Make sure pred_df only has the three columns, and pred is rounded
        pred_df = pred_df[['patid', 'day', 'measurement']]
        pred_df['measurement'] = pred_df['measurement'].round().clip(0, 10).astype(int)
        
        # Open test target
        target_df = pd.read_csv('https://gist.githubusercontent.com/jaurioles/0ada0f9ad7fe586e86c9f31c2f0ad75d/raw/99826d34f7543d576e9144d45954efc98ed65022/template_target.csv')
        # Rename column measurement to target_measurement
        target_df = target_df.rename(columns = {"measurement":"target_measurement"})
        
        
        # Merge predictions in
        target_df = target_df.merge(pred_df, on=['patid', 'day'], how='left')
        
        # Calculate Kappa
        kws = cohen_kappa_score(target_df['target_measurement'],target_df['measurement'], weights = 'quadratic')
        
        # final score
        final_score = kws - 0.0005*self.penalty
        
        print("THE SCORE IS:",kws)
        print("WITH ROWS SAMPLED:",self.counter)
        print("AND PENALTY:",self.penalty)
        print("GIVING A FINAL SCORE OF:",final_score)