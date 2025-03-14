# Background

Smartphones and wearables provide many important opportunities to advance both clinical care and population health research. They allow the collection of new types of data including self-reported symptoms such as pain, or passively measured sensor data like physical activity. Quick surveys and passive data also allow us to measure the day-to -day changes in disease.

Chronic pain is one area of healthcare that can significantly benefit from these opportunities. Frequent data collection allows us to understand changing patterns of disease through time, identify (time-varying) factors that influence pain, measure and identify early signals of treatment response, or even predict flares and intervene in a timely way. However, collecting detailed, accurate data from patients is often time-intensive, costly, and challenging. Furthermore, developing and testing novel analysis methods to handle rich time-series data in order to achieve the above objectives can be hampered by the availability of large-scale datasets or incomplete data – either because of governance limitations or just because this is a relatively new field of research.

This hackathon focuses on designing and testing innovative approaches to simulate daily tracked symptom data and to predict pain dynamics, incorporating real-world challenges like optimising sampling frequency. 

Below are the two tasks for the hackathon:


## Task 1 Description: Simulation of tracked daily symptoms

### Task overview
In this challenge, you’ll build a simulation that generates daily pain measurements for a set of patients over a certain period. Unlike a standard static dataset, this simulation should capture underlying patterns of disease that will be explained during the hackathon by clinical and patient partners. The end goal is to produce a realistic synthetic dataset that can be used in subsequent modeling tasks.

More details will be provided during the hackathon.

[//]: # (### The Data)

[//]: # (Each simulated patient record should contain:)

[//]: # ()
[//]: # (1. Patient ID: A unique identifier for each patient &#40;e.g., 1 through 1,000&#41;.)

[//]: # (2. Days &#40;1 to 180&#41;: A 180-day timeline for each patient.)

[//]: # (3. Pain Measurements &#40;0–10 scale&#41;: Daily pain scores. You may incorporate:)

[//]: # (- Baseline pain levels,)

[//]: # (- Potential improvement or worsening over time,)

[//]: # (- Random noise or variability,)

[//]: # (- Simple or complex “treatment effect” curves &#40;e.g., medication starts, dosage changes, tapering, etc.&#41;.)

### The challenge


#### Design a simulation:

- Account for the natural history of disease over time, including phases of improving and worsening symptoms, as well as short-term effects that may change gradually or more rapidly. Superimpose treatments and their corresponding responses. 
- Include random fluctuations and ‘flares’ to represent day-to-day changes.
- Introduce treatment dynamics—for example, a medication might reduce pain after 2 weeks, then fade in effectiveness over the next month. 
- Ensure each patient’s trajectory looks diverse yet realistic (no single pattern for all).


### Evaluation
The result of your simulation will be evaluated by the domain experts. While there is no explicit “forecasting score,” the simulation should meet the following criteria:

1. Maintain Realism: Ensure pain levels remain logical patterns (e.g., steady improvement or clinically reasonable oscillations).
2. Facilitate Future Tasks: The resulting dataset should be suitable for subsequent analysis tasks.

You are encouraged to be creative in modeling elements with different parameters to enhance the simulator. The ultimate goal is to produce a coherent, flexible simulator that generates daily pain measurements influenced by mock treatments over a certain time period.

## Task 2 Description: Predicting pain measurements and optimizing sampling frequency

### Task overview
Imagine you have data on a number of patients, each with daily pain measurements recorded over a certain time period. However, in the real world, collecting patient-reported outcomes can be demanding and time-consuming. Your mission is to forecast patients’ pain measurement with high accuracy—while also minimizing the number of data points you request to retrieve.

More details will be provided during the hackathon.

[//]: # (### The Data)

[//]: # (1. Training Set: Full 180-day pain trajectories for 800 patients. Use these to build and fine-tune your models.)

[//]: # (2. Test Set &#40;For result evaluation&#41;: 200 patients, for which you’ll initially see only the first 30 days of data.)

[//]: # ()
[//]: # (### The Twist: Adaptive Data Retrieval)

[//]: # (Before generating your final predictions on days 151–180, you have the option to retrieve additional daily measurements from days 30–150 for each patient—but at a cost. Each requested data point adds to your overall penalty.)


### The challenge
- You will receive a training set consisting of fully observed patient records.
- For a separate test set of patients, you can strategically choose to request—or skip—daily measurements from the partially observed portion of their records.
- Finally, you must forecast pain levels for the remainder of the timeline, using the measurements you’ve gathered along with any initial data provided.

[//]: # (### Evaluation)

[//]: # (You will be scored on two factors:)

[//]: # ()
[//]: # (1. Predictive Accuracy: How close your forecasts are to the true pain values &#40;e.g., via Mean Absolute Error&#41;.)

[//]: # (2. Data Cost: The number of extra data points you requested.)

[//]: # (We’ll combine these into a single score, penalizing overuse of data queries. Low error with minimal requests = the best score!)
