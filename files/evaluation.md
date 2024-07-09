# Hackathon Evaluation

For the duration of the Hackathon, you have access to 19 separate protein experiment files which you can use for developing your model and training pipeline. Each experiment file contains the fitness measurements for many variants of the same protein. In most cases, each variant is created by mutating a single amino acid in the protein. 

Your goal is to train a model that can predict the fitness of a single mutation. We have provided a basic implementation that achieves this task: your goal is to try and improve it.

The setup is such that a single model is trained to predict the mutation effects for one protein (one experiment file). For each protein, a train/validation/test split is created by assigning each position in the protein sequence to a different split. 

For the final evaluation, your model will be evaluated on a different set of protein experiment files with the same format as your training data. This means your final submission will not be a trained model but rather a model and a training script that will be run on 10 unseen datasets.

Specifically, you are tasked with writing a function:
`train_model()`
and a class:
`ProteinModel()`

`train_model()` must take as input the following: 
- PyTorch model (created by you)
- train_loader 
- val_loader

Each position on the protein is given a value that is modulo 5 of its sequence position, 3 of the 5 modulo bins will be used for training, one for validation and one for testing.

For us to evaluate your model it has to work with the DataLoader that we have implemented so please do not change the source code for the dataloader. Additionally:

1. Your PyTorch `ProteinModel()` must have a method, called `forward()`, that takes as input a dictionary with the same structure that the DataLoader provides.
2. It must return a scalar value which is your prediction for the fitness.

Outside of that, you are welcome to change any other aspects of the model architecture or how the model is trained including the number of epochs, stopping criterion, loss function, optimizer, and learning rate schedule.

We do require that your model training and evaluation completes within 2 hours on all of our 10 test datasets. In order to test this, please make sure that you can run training and evaluation on the `HUMAN` experiment within 10 minutes.

## Evaluation protocol

The metric we will use for evaluation is the Spearman rank correlation the goal is to rank any mutation in any position on the same protein
The final metric is the mean Spearman score averaged across all 10 test proteins.

If your script does not execute in the time limits you score 0 on all datasets that failed to complete.

The source code for the project can be found here:
[https://github.com/judeWells/RocheHackathon2024]()

If you want to work outside of Saturn Cloud you can download the sample data here:
[https://drive.google.com/drive/folders/1QoT9-IfC4W5KzNpU-ONkLtyKxBDeNQnd?usp=sharing]()
