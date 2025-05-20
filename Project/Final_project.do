
clear

log using "Econometrics_final_project", text replace

*set working directory
cd "D:\Masters\Sem4\Econometrics\Project"

import delimited "D:\Masters\Sem4\Econometrics\Project\data\Final_data.csv" // import the data

*Data Exploration
* Generate the "treat" variable
gen treat = .

* Set "treat" to 0 for states with MML before 2016
replace treat = 0 if firstyearmml < 2016
* Set "treat" to 1 for states with MML is missing 
replace treat = 1 if missing(firstyearmml) & treat != 0

* Drop states where "treat" is missing
drop if missing(treat)

*Converting string variable into numerical variable
gen crime_2014_no_commas = subinstr(violent_crimepc_2014, ",", "", .)
gen crime_2014 = real(crime_2014_no_commas)
gen crime_2019_no_commas = subinstr(violent_crimespc_2019, ",", "", .)
gen crime_2019 = real(crime_2019_no_commas)
gen income_2019_no_commas = subinstr(income_2019, ",", "", .)
gen income_2019_n = real(income_2019_no_commas)
drop income_2019_no_commas income_2019


*Summary statistics for all the variables in treatment model 
summarize male_2014 young_2014p middle_aged_2014p	 ///
unemployment_2014 conservative catholic liberal	catholic ///	
evangelicalprotestant historicallyblackprotestant jewish ///	
mainlineprotestant	unaffiliated relig_att_week	relig_att_year

* Scaling variable (min-max) 
gen unemployment_2014_s = (unemployment_2014 - 3.5) / (9.2 - 3.5)
sum unemployment_2014_s

*Summary statistics for all the variables in outcome model 
summarize crime_2019 povertyp_2019 edu_att_2019 income_2019_n ///
male_2019 unemployment_2019 relig_att_week relig_att_year ///
young_2019p crime_2014	

* Scaling variables (min-max)
gen crime_2019_s = (crime_2019 - 115.2) / (1049 - 115.2)
gen povertyp_2019_s = (povertyp_2019 - 4.9) / (19.4 - 4.9)
gen income_2019_s = (income_2019_n - 48200) / (91900 - 48200)
gen unemployment_2019_s = (unemployment_2019 - 2.1) / (5.6 - 2.1)
gen crime_2014_s = (crime_2014 - 99.3) / (1244.4 - 99.3)
sum crime_2019_s povertyp_2019_s income_2019_s unemployment_2019_s crime_2014_s

*Exploring the each independent variable relation with treat
graph box male_2014, over(treat)
graph box young_2014p, over(treat)
graph box middle_aged_2014p, over(treat)
graph box unemployment_2014_s, over(treat)
graph box conservative, over(treat)
graph box catholic, over(treat)

//-----------------------------------------------------------------------------

*Logistic Regression Models
*Treatment selection model 1
logit treat male_2014 young_2014p middle_aged_2014p	 ///
unemployment_2014_s conservative catholic liberal ///	
evangelicalprotestant historicallyblackprotestant jewish ///	
mainlineprotestant	unaffiliated relig_att_week	relig_att_year
estimates store model1

*Propensity scores
predict ps1, p

*tabulating jewish to see variation in observations
tab jewish

*Correlation among treatment model variables
corr male_2014 young_2014p middle_aged_2014p	 ///
unemployment_2014_s conservative catholic liberal ///	
evangelicalprotestant historicallyblackprotestant jewish ///	
mainlineprotestant	unaffiliated relig_att_week	relig_att_year


*roc
roctab treat ps1
estat classification
* Generate a variable indicating the predicted treatment status based on a threshold
gen treat_predicted1 = (ps1 > 0.5)
* Cross-tabulate observed and predicted treatment status
tab treat treat_predicted1, matcell(CM1)
matrix list CM1
* Calculate type 1 error rate (false positive rate)
gen type1_err_m1 = treat_predicted1 & (treat == 0)
* Calculate type 2 error rate (false negative rate)
gen type2_err_m1 = !treat_predicted1 & (treat == 1)
sum type1_err_m1 type2_err_m1
// -------------------------------------------------------------------------------

*removing variables based on model1 output and correlation 
*Treatment selection model2
logit treat male_2014 young_2014p unemployment_2014_s ///
catholic evangelicalprotestant historicallyblackprotestant ///	
mainlineprotestant unaffiliated relig_att_year
estimates store model2
*Propensity scores
predict ps2, p

*Correlation matrix for model2 variables
corr male_2014 young_2014p unemployment_2014_s ///
catholic evangelicalprotestant historicallyblackprotestant ///	
mainlineprotestant unaffiliated relig_att_year

*roc
roctab treat ps2

* Generate a variable indicating the predicted treatment status based on a threshold
gen treat_predicted2 = (ps2 > 0.5)
* Cross-tabulate observed and predicted treatment status
tab treat treat_predicted2, matcell(CM2)
matrix list CM2
* Calculate type 1 error rate (false positive rate)
gen type1_err_m2 = treat_predicted2 & (treat == 0)
* Calculate type 2 error rate (false negative rate)
gen type2_err_m2 = !treat_predicted2 & (treat == 1)
sum type1_err_m2 type2_err_m2

// ---------------------------------------------------------------------------

*Treatment selection model3
logit treat male_2014 young_2014p unemployment_2014_s catholic ///
unaffiliated 
estimates store model3
*Propensity scores
predict ps3, p

* Generate a variable indicating the predicted treatment status based on a threshold
gen treat_predicted3 = (ps3 > 0.5)
* Cross-tabulate observed and predicted treatment status
tab treat treat_predicted3, matcell(CM3)
matrix list CM3
* Calculate type 1 error rate (false positive rate)
gen type1_err_m3 = treat_predicted3 & (treat == 0)
* Calculate type 2 error rate (false negative rate)
gen type2_err_m3 = !treat_predicted3 & (treat == 1)
sum type1_err_m3 type2_err_m3
// ---------------------------------------------------------------------------- 
*Treatment selection model 4 
logit treat male_2014 young_2014p unemployment_2014_s catholic ///
evangelicalprotestant
estimates store model4
predict ps4, p 

* Generate a variable indicating the predicted treatment status based on a threshold
gen treat_predicted4 = (ps4 > 0.5)
* Cross-tabulate observed and predicted treatment status
tab treat treat_predicted4, matcell(CM4)
matrix list CM4
* Calculate type 1 error rate (false positive rate)
gen type1_err_m4 = treat_predicted4 & (treat == 0)
* Calculate type 2 error rate (false negative rate)
gen type2_err_m4 = !treat_predicted4 & (treat == 1)
sum type1_err_m4 type2_err_m4
// -----------------------------------------------------------------------------
*selecting model3 due to auc
roctab treat ps3
roctab treat ps4

etable, estimates(model*) cstat(_r_b) cstat(_r_se)cstat(_r_p) ///
mstat(r2_p) export(logisticmodel.docx, replace)

*Histogram
twoway (histogram ps3 if treat==1, ///
	fraction color(gs8) start(0) width(.4)) ///
	(histogram ps3 if treat==0, fraction fcolor(none) ///
		lcolor(black) start(0) width(.4)), ///
	legend(order(1 "treatment" 2 "control" ))  scheme(s1mono)
	
* Covariate overlap scatter plot
twoway (scatter unemployment_2014_s male_2014  if treat==1, ms(th) ) ///
(scatter unemployment_2014_s male_2014 if treat==0, ms(oh) ) , ///
ytitle("Unemployment rate in 2014") ///
xtitle("Percentage of Catholics") ///
title("Overlap in Two Dimensions") ///
legend(label(1 "Treatment") label(2 "Control")) ///
scheme(s1mono) saving(projscatter, replace)
	
	
* Covariate overlap scatter plot
twoway (scatter catholic young_2014p if treat==1, ms(th) ) ///
(scatter catholic young_2014p if treat==0, ms(sh) ) , ///
ytitle("Percentage of Catholics") ///
xtitle("percentage of young population") ///
title("Overlap in Two Dimensions") ///
legend(label(1 "Treatment") label(2 "Control")) ///
scheme(s1mono) saving(projscatter, replace)


*Inverse Probability weight adjusted regression
teffects ipwra (crime_2019_s povertyp_2019_s edu_att_2019 income_2019_s ///
male_2019 unemployment_2019_s relig_att_week relig_att_year ///
young_2019p crime_2014_s) (treat male_2014 young_2014p unemployment_2014_s ///
catholic evangelicalprotestant, logit)


*Simpler propensity score matching
*Inverse probabilit weights
gen ipw=1/ps3 if treat==1
replace ipw=1/(1-ps3) if treat==0

*Regression adjusted model for control and treatment groups
regress crime_2019_s povertyp_2019_s edu_att_2019 income_2019_s ///
male_2019 unemployment_2019_s relig_att_week relig_att_year ///
young_2019p crime_2014_s ///
if treat==0 [aw=ipw]
predict pcontrol
regress crime_2019_s povertyp_2019_s edu_att_2019 income_2019_s ///
male_2019 unemployment_2019_s relig_att_week relig_att_year ///
young_2019p crime_2014_s ///
if treat==1 [aw=ipw]
predict ptreat

*Calculate ATU, ATT, ATE
gen teffect=ptreat-pcontrol
tabulate treat, summarize(teffect)