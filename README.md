# Effect of Marijuana Legalization on Violent Crimes

## Overview

This project investigates the relationship between marijuana legalization and violent crime rates in the United States. By applying advanced econometric techniques and leveraging a diverse array of demographic, political, and religious variables, the study provides insights into how cannabis policy shifts may impact public safety.

The analysis centers on state-level data from 2014 and 2019 and uses statistical methods such as **Propensity Score Matching**, **Logistic Regression**, and **Inverse Probability Weighted Regression Adjustment (IPWRA)** to estimate treatment effects.

---

## Key Findings

* **States that adopted marijuana legalization policies showed a statistically significant reduction in violent crime rates** compared to non-legalizing states.
* Factors such as **political ideology**, **religious affiliation**, and **unemployment rate** were strong predictors of whether a state chose to legalize marijuana.
* Treatment effects estimated through multiple models (ATE, ATT, ATU) consistently support the conclusion that **marijuana law liberalization correlates with decreased violent crime**.

---

## Research Questions

1. How does marijuana law liberalization influence violent crime rates at the state level?
2. What demographic, political, and religious factors contribute to states adopting marijuana liberalization?
3. How do these variables interact and influence the overall relationship?

---

## Data Sources

- **Political Ideology & Religion**: Pew Research Center
- **Unemployment Rates**: Bureau of Labor Statistics
- **Demographic & Poverty Data**: U.S. Census Bureau
- **Education Data**: National Center for Education Statistics

---

## Methodology

### Tools & Software
* **Software Used**: [Stata](https://www.stata.com)
  
### 📌 **Treatment Model**

Built using **logistic regression**, estimating the probability of a state legalizing marijuana based on:

* Historical marijuana stance
* Political ideology
* Religious affiliation
* Unemployment rate
* Age and gender distribution

### 📌 **Outcome Model**

Used **IPWRA** to control for confounding variables and estimate the causal impact of legalization on crime rates. Controlled for:

* 2014 violent crime baseline
* 2019 demographics (age, gender)
* Median income
* Poverty rate
* Religious attendance

### 📈 **Model Selection & Evaluation**

* AUC and confusion matrices used to select the optimal treatment model.
* DAGs (Directed Acyclic Graphs) constructed for both treatment and outcome models to ensure causal assumptions were met.
![ ](https://github.com/MownikaKonamaneni/Econometrics/blob/main/Images/DAG_Treatment_model.jpg)

![ ](https://github.com/MownikaKonamaneni/Econometrics/blob/main/Images/DAG_Outcome_model.jpg)

* Visualizations such as propensity score histograms and covariate overlap scatterplots validated balance and comparability between treated and control groups.

![ ](https://github.com/MownikaKonamaneni/Econometrics/blob/main/Images/Propensity_Scores.png)

![ ](https://github.com/MownikaKonamaneni/Econometrics/blob/main/Images/Overlap_between_covariates.jpg)

---
## 📊 Main Results
Logistic regression models were used to estimate propensity scores.
* Model 3 (selected model) showed:
  * High predictive accuracy (balanced AUC)
  * Significant predictors (e.g., Evangelical affiliation, unemployment)
* IPWRA model estimates revealed:
  * Reduction in violent crime for both treated and untreated states
  * Average Treatment Effect (ATE), ATT, and ATU all statistically significant

---

## Files

* `data/`: Raw and cleaned datasets
* `Project/`: Stata `.do` files for model building and analysis
* `Reports/`: Final written report and other documents
* `Research Papers/`: Research papers referred for analysis and model building
* `README.md`: Project overview and usage instructions

---

## 📘 How to Reproduce
1. Open Stata and set the working directory to the project folder:
   
```stata
cd "path_to_repo"
```
2. Run the treatment and outcome models :

```stata
do https://github.com/MownikaKonamaneni/Econometrics/blob/main/Project/Final_project.do
```

