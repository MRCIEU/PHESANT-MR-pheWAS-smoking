local homeDir : env HOME
local resDir = "`homeDir'/2017-PHESANT-smoking-interaction/results/results-21753/facialaging-followup/"

clear
graph drop _all


*****
***** options to run all simulations

* two simulations
local comparison = 0

* orx 10 20 50 100
local orx=100
local negx=1

*****
*****


* number in our UKB sample
set obs 305650

set more off
gen id=_n
set seed 123456789





**
** make snp data with same distribution as our smoking SNP
* 0:0.45%
* 1:0.45%
* 2:0.1%

local n0 = 305650*0.4494
local n1 = 305650*0.4422
local n2 = 305650*0.1083

gen snp = 0
replace snp = 1 if _n > `n0' & _n <= `n0'+`n1'
replace snp = 2 if _n > `n0'+`n1'


* we assume colider bias is caused by a confounder that is a common
* effect on the outcome and SI
gen conf = rnormal(0,1)


if `comparison' == 0 {

	if (`orx'==10) {
		* OR=10 of conf on SI
		gen logitSmokePart=(log(0.979))*snp + (log(10))*conf + log(0.7)
	}
	else if (`orx'==20) {
		* OR=20 of conf on SI
		gen logitSmokePart=(log(0.979))*snp + (log(20))*conf + log(0.66)
	}
	else if (`orx'==50) {
		* OR=50 of conf on SI
		gen logitSmokePart=(log(0.979))*snp + (log(50))*conf + log(0.6)
	}
	else if (`orx'==100) {
		* OR=100 of conf on SI
		gen logitSmokePart=(log(0.979))*snp + (log(100))*conf + log(0.55)
	}
}
else {
	if (`orx'==100) {
	di "comparison"
	gen logitSmokePart=(log(0.8))*snp + (log(100))*conf + log(0.63)
	}
}

* probability of being an ever smoker
gen pSI=exp(logitSmokePart)/(1+exp(logitSmokePart))
gen siOtemp = runiform()

* set all to being a never smoker
gen si = 0

* select ever smokers acording to their probability of being an ever smoker
* nb. it is <= because if pSI=0.9 then this person has a 0.9 prob of being an EVER smoker
replace si = 1 if siOtemp <=pSI

* check that si0 proportions match dataset and adjust constant if not
tab si
* 1=ever, 0=never



* proportions should be never(0)=54.89 and ever(1)=45.11
summ si
tabu snp

* generate outcome with increasing amounts of 
* affect on this outcome from conf, to see how big this
* needs to be to induce an association between snp and outcome 
* when stratifying on smoking initiation.

* in our data 45% have SI=1
* with dosage 0: ~45.7% have SI=1
* with dosage 1: ~45.2% have SI=1
* with dosage 2: ~44.8% have SI=1


tempname memhold
postfile `memhold' str30 outcometype r2 str30 strata estimate lower upper using "`resDir'/sim-results-facialaging`orx'-`negx'-`comparison'.dta" , replace


* proportion of variation of outcome due to confounder
local prop = 0
local increment = 0.02
local tx = 1

while `prop'<=`tx' {
	di "prop `prop'"
	
	**
	** generate outcome
	
	* generate ordered categorical variable with 3 categories
	** assume no effect of snp on outcome
	** WE VARY THE PROPORTION OF THE OUTCOME EXPLAINED BY THE CONFOUNDER
	
	* normally distributed continuous variable underlying our categorical facial aging outcome
	if (`negx'==0) {
		gen outcomeCont = sqrt(1-`prop')*rnormal(0,1)+sqrt(`prop')*conf
	}
	else {
		* and negative association version
		gen outcomeCont = sqrt(1-`prop')*rnormal(0,1)-sqrt(`prop')*conf
	}
	
	gen outcome = .
	replace outcome = 0 if outcomeCont <= 0.61
	replace outcome = 1 if outcomeCont > 0.61 & outcomeCont <= 2.05
	replace outcome = 2 if outcomeCont > 2.05
	
	* num in each outcome category should be ~ 0: 73%, 1: 25%, 2: 2%
	tab outcome	

	**
	** proportion of outcome variance explained by confounder

	quietly:regress outcomeCont conf
	local r2 = `e(r2)'
	di "R2 `r2'"
	
	**
	** test associations in SI strata
	
	tab outcome if si==1
	tab outcome if si==0
	
	
	****
	**** FACIAL AGING CATEGORICAL OUTCOME
	
	* ever smokers
	ologit outcome snp if si == 1
	local beta _b[snp]
	local ciL _b[snp] - 1.96 * _se[snp]
	local ciU _b[snp] + 1.96 * _se[snp]
	post `memhold' ("CAT") (`r2') ("smoking status=EVER") (exp(`beta')) (exp(`ciL')) (exp(`ciU'))
	
	* never smokers
	ologit outcome snp if si == 0
	local beta _b[snp]
	local ciL _b[snp] - 1.96 * _se[snp]
	local ciU _b[snp] + 1.96 * _se[snp]
	post `memhold' ("CAT") (`r2') ("smoking status=NEVER") (exp(`beta')) (exp(`ciL')) (exp(`ciU'))
	
	****
	**** CONTINUOUS OUTCOME
	
	* ever smoker
	regress outcomeCont snp if si == 1, noheader
	local beta _b[snp]
	local ciL _b[snp] - 1.96 * _se[snp]
	local ciU _b[snp] + 1.96 * _se[snp]
	post `memhold' ("CONT") (`r2') ("smoking status=EVER") (`beta') (`ciL') (`ciU')
	
	* never smoker
	regress outcomeCont snp if si == 0, noheader
	local beta _b[snp]
	local ciL _b[snp] - 1.96 * _se[snp]
	local ciU _b[snp] + 1.96 * _se[snp]
	post `memhold' ("CONT") (`r2') ("smoking status=NEVER") (`beta') (`ciL') (`ciU')
	
	
	
	
	**
	** remove generated variables
	
	drop outcome*
	
	local prop=`prop'+`increment'
	
}

postclose `memhold' 



***
*** plot results
use "`resDir'/sim-results-facialaging`orx'-`negx'-`comparison'.dta", clear


** facial aging categorical simulation
eclplot estimate lower upper r2 if outcometype == "CAT", supby(strata) yscale(range(0.95 1.2))  ylab(0.9(0.05)1.2) yline(1)
*eclplot estimate lower upper r2 if outcometype == "CAT", supby(strata) yscale(range(0.95 1.2))  ylab(0.9(0.1)1.4) yline(1)
if (`negx'==1) {
	graph export "`resDir'/sim-fa-OR`orx'-neg-`comparison'.pdf"
}
else {
	graph export "`resDir'/sim-fa-OR`orx'-`comparison'.pdf"
}

** continuous outcome simulation 
eclplot estimate lower upper r2 if outcometype == "CONT", supby(strata) yscale(range(-0.015 0.015))  ylab(-0.015(0.005)0.015) yline(0)
*eclplot estimate lower upper r2 if outcometype == "CONT", supby(strata) yscale(range(-0.015 0.015))  ylab(-0.02(0.01)0.03) yline(0)
if (`negx'==1) {
	graph export "`resDir'/sim-cont-OR`orx'-neg-`comparison'.pdf"
}
else {
	graph export "`resDir'/sim-cont-OR`orx'-`comparison'.pdf"
}


