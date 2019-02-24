
* simulation testing the relationship between p value of 2sls estimate with p value of direct test (of snp on the outcome)
* generated plots are shown in supplementary material of paper.

clear
*graph drop _all
set obs 10000
set more off
gen id=_n
set seed 123456789


gen snpCont = rnormal(0,1)
gen snp = 0
replace snp = 1 if snpCont > 0.5
replace snp = 2 if snpCont > 2


gen pdirect = .
gen ptsls = .
gen pTruth = .
gen fstat = .

local ix = 1

while `ix'<=1000 {

	gen exposure = 0.1 * snp + rnormal(0,1)
	gen outcome = 0.01*exposure + rnormal(0,1)

	regress exposure snp
	replace fstat = `e(F)' if _n == `ix'
	
	* true effect of the exposure on the outcome
	regress outcome exposure
	local beta _b[exposure]
	local se _se[exposure]
	local t = _b[exposure]/_se[exposure]
	local pTruth = 2*ttail(e(df_r),abs(`t'))
	
	
	* direct test of IV on the outcome
	regress outcome snp

	local beta _b[snp]
	local se _se[snp]
	local t = _b[snp]/_se[snp]
	local pDirect = 2*ttail(e(df_r),abs(`t'))
	
	* causal estimate
	ivreg outcome (exposure=snp)
	
	local beta _b[exposure]
	local se _se[exposure]
	local t = _b[exposure]/_se[exposure]
	local pTSLS = 2*ttail(e(df_r),abs(`t'))
	
	*post `memhold'  (`pDirect') (`pTSLS')
	replace pdirect = `pDirect' if _n == `ix'
	replace ptsls = `pTSLS' if _n == `ix'	
	replace pTruth = `pTruth' if _n == `ix'
	
	local ix = `ix'+1
	

	drop exposure outcome 
}

* compare direct and tsls p values
twoway (scatter pdirect ptsls if fstat<10, mc(red))  ///
(scatter pdirect ptsls if fstat>=10 & fstat<30, mc(orange)) ///
(scatter pdirect ptsls if fstat>=30 & fstat<50, mc(green)) ///
(scatter pdirect ptsls if fstat>=50, mc(yellow)) ///
, legend(label(1 "F-stat <10") label(2 "10<= F-stat <30") label(3 "30<= F-stat <50") label(4 "50> F-stat") ) name("pvalues7x") plotregion(fcolor(white)) graphregion(fcolor(white))
	
	
* fstat distribution
twoway (hist fstat, name("fstat3")), plotregion(fcolor(white)) graphregion(fcolor(white))
	

gen pTruthSig = 0
replace pTruthSig = 1 if pTruth < 0.05
gen ptslsSig = 0
replace ptslsSig = 1 if ptsls <0.05
gen pdirectSig = 0
replace pdirectSig =1 if pdirect < 0.05

* p value of tsls is more conservative than p value of direct test
tab pTruthSig pdirectSig
tab pTruthSig ptslsSig

