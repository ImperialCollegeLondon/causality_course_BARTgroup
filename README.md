# Causality Module StatML 2024
This repository contains the code for the causality module of the StatML 2024 course. 
The aim is to estimate the ATE (Average Treatment Effect) using three different methods:
- Propensity Score Matching
- Double Machine Learning
- Bayesian Additive Regression Trees (BART)

## Python requirements
conda create -n causl python=3.10  
conda activate causl 
pip install -r requirements.txt

## Data
The data used in this project is generate using the 'causl' package in R. The data is stored in the data folder.

## Results 
To obtain the results for each method run the corresponding file in the results project_code folder.
