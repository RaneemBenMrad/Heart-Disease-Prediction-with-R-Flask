# Heart Disease Prediction using Logistic Regression (R + Flask)

This project aims to **predict the likelihood of heart disease** in a patient based on various clinical features. It combines **data analysis and modeling in R** with a **user-friendly web interface built using Flask**.

---

##  Part 1: Data Analysis & Modeling (R)

### Dataset

The dataset is based on the Cleveland heart disease dataset, originally sourced from the UCI Machine Learning Repository and prepared by [StatQuest](https://github.com/StatQuest/logistic_regression_demo).

### Key Steps Performed:

- **Data Preprocessing:**
  - Replaced missing values (`?`) using the `missForest` imputation method
  - Converted variables to appropriate types (factors, numeric)
  
- **Exploratory Data Analysis:**
  - Distribution of variables by heart disease status
  - Chi-square tests for categorical features
  - Wilcoxon and Kruskal-Wallis tests for continuous features

- **Visualization:**
  - Boxplots, density plots, correlation matrices
  - Principal Component Analysis (PCA)
  - Linear Discriminant Analysis (LDA)

- **Modeling:**
  - Logistic Regression
  - Stepwise feature selection using AIC
  - Evaluation of model performance using ROC and confusion matrix

### Output

A final PDF file shows the **probabilities of heart disease for each patient**, with visuals highlighting predicted vs actual status.

---

##  Part 2: Web Application (Flask)

The second part of the project is a **simple web application** that allows users to input their health information and get a **prediction of heart disease risk**.

### Features

- User-friendly form to enter values like age, sex, cholesterol, blood pressure, etc.
- On form submission:
  - Data is processed and passed to the trained R model (or its converted Python version)
  - A prediction is returned: `Healthy` or `Unhealthy`
  - Optionally displays probability scores or confidence

---


