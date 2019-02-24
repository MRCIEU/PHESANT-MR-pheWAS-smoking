

clear
graph drop _all


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



tempname memhold
postfile `memhold' str30 outcometype r2 str30 strata estimate lower upper pvalue outcomeIdx propx using "sim-results-facialaging100-0-0-pvalues.dta" , replace


* proportion of variation of outcome due to confounder
local prop = 0.8
*local increment = 0.02
local increment = 0.2
local tx =0.8

while `prop'<=`tx' {
	di "prop `prop'"
	
	local outx = 1
	while `outx' <= 10 {
	
		di "`prop' OUTX `outx'"
		
		
		
				
				
		* we assume colider bias is caused by a confounder that is a common
		* effect on the outcome and SI
		gen conf = rnormal(0,1)
		
		gen logitSmokePart=(log(0.979))*snp + (log(100))*conf + log(0.55)

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
		
		**
		** generate outcome
	
		* generate ordered categorical variable with 3 categories
		** assume no effect of snp on outcome
		** WE VARY THE PROPORTION OF THE OUTCOME EXPLAINED BY THE CONFOUNDER
	
		* normally distributed continuous variable underlying our categorical facial aging outcome
		gen outcomeCont = sqrt(1-`prop')*rnormal(0,1)+sqrt(`prop')*conf
		
	
		
		di "XXXXXXXXXXXX

		corr si outcomeCont

		di "XXXXXXXXXXXX
	
		**
		** proportion of outcome variance explained by confounder

		quietly:regress outcomeCont conf
		local r2 = `e(r2)'
		di "R2 `r2'"
	
		****
		**** CONTINUOUS OUTCOME
	
		* ever smoker
		regress outcomeCont snp if si == 1, noheader
		local beta _b[snp]
		local ciL _b[snp] - 1.96 * _se[snp]
		local ciU _b[snp] + 1.96 * _se[snp]
		local t = _b[snp]/_se[snp]
		local pval = 2*ttail(e(df_r),abs(`t'))
		di `pval'
		post `memhold' ("CONT") (`r2') ("smoking status=EVER") (`beta') (`ciL') (`ciU') (`pval') (`outx') (`prop')
	
		local outx=`outx'+1
	
		**
		** remove generated variables
	
		drop outcome* logitSmokePart si pSI siOtemp conf
	
	
	}
	
	local prop=`prop'+`increment'
	
	
}

postclose `memhold' 







***
*** generate fdr from simulated results

use "sim-results-facialaging100-0-0-pvalues.dta", clear

* propxx is the correlation, e.g. 8 is correlation 0.8
gen propxx = .
replace propxx = 0 if propx>-0.1 & propx < 0.1
replace propxx = 2 if propx>0.1 & propx < 0.3
replace propxx = 4 if propx>0.3 & propx < 0.5
replace propxx = 6 if propx>0.5 & propx < 0.7
replace propxx = 8 if propx>0.7 & propx < 0.9
replace propxx = 10 if propx>0.9 & propx < 1.1



count if pvalue < 0.05 & propxx == 0
count if pvalue < 0.05 & propxx == 2
count if pvalue < 0.05 & propxx == 4
count if pvalue < 0.05 & propxx == 6
count if pvalue < 0.05 & propxx == 8
count if pvalue < 0.05 & propxx == 10


 
 

