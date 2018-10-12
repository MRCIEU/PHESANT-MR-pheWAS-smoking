
* ssc install metan

local homeDir : env HOME
local resDir "`homeDir'/2017-PHESANT-smoking-interaction/results/results-21753"

log using "`resDir'/results-by-interaction-pvalue/interaction-log-`1'.txt", text replace

* all results from MR-pheWAS (pvalues are imported as strings so we don't loose the very low values)
import delimited using "`resDir'/results-combined.txt", stringcols(7,12) clear

* empty column for interaction p value
gen ipvalue = .

* start and end index of results to process
local start `1'
local end `2'

di `start' 
di `end'

local countMissing 0
local countDifferent 0
local countMultinomial 0
local countSuccessCon 0
local countSuccessBin 0
local countSuccessOrd 0

local nx = _N


* loop each result and compare

forvalues i = `start'(1)`end' {


	****
	**** deciding which results we need to skip

	* if missing a result for ever or never then skip
	if ( (missing(restypeever[`i'])==1) | (missing(restypenever[`i'])==1) | (missing(lowernever[`i'])==1) | (missing(uppernever[`i'])==1) | (missing(lowerever[`i'])==1) | (missing(upperever[`i'])==1)  ) {
		di "missing results - skipped result"
                local countMissing = `countMissing' + 1
		replace ipvalue = -999 if _n==`i'
                continue
	}

	* if different tests used for ever vs never then skip
	if ((restypeever[`i'] != restypenever[`i'])) {
		di "different tests - skipped result"
		local countDifferent = `countDifferent' + 1
		replace ipvalue = -999 if _n==`i'
		continue
	}

	* we don't include multinomial logistic models
	if (restypeever[`i'] == "MULTINOMIAL-LOGISTIC") {
		di "multinomial logistic - skipped result"
		local countMultinomial = `countMultinomial' + 1
		replace ipvalue = -999 if _n==`i'
		continue
	}


	****
	**** counting results we can include, of each type

	if (restypeever[`i'] == "LINEAR") {
                local countSuccessCon = `countSuccessCon' + 1
        }
	if (restypeever[`i'] == "LOGISTIC-BINARY") {
                local countSuccessBin = `countSuccessBin' + 1
        }
	if (restypeever[`i'] == "ORDERED-LOGISTIC") {
                local countSuccessOrd = `countSuccessOrd' + 1
        }
	

	di "FOR " `i'
	*list if _n == `i'


	****
	**** get results values for example at index i

	* get beta and CI values for this result and never subset
	levelsof betanever if _n==`i', local(bn)
	levelsof lowernever if _n==`i', local(ln)	
	levelsof uppernever if _n==`i', local(un)
	di `bn'

	* get beta and CI values for this result and ever subset
	levelsof betaever if _n==`i', local(be)
        levelsof lowerever if _n==`i', local(le)
        levelsof upperever if _n==`i', local(ue)
	di `be'


	****
	**** store beta lowCI highCI in new variables, to be used by metan

	gen metanBeta = `bn' if _n==1
	gen metanlowci = `ln' if _n==1
        gen metanhighci = `un' if _n==1	

        replace metanBeta = `be' if _n==2
        replace metanlowci = `le' if _n==2
        replace metanhighci = `ue' if _n==2


	****
        **** calculate interaction P value

	*tttesti `nn' `bn' `sdn' `ne' `be' `sde'
	metan metanBeta metanlowci metanhighci

	* store this value
	replace ipvalue = $S_9 if _n==`i'
	local res $S_9

	* remove temp variables used by metan
	drop metanBeta
	drop metanlowci
	drop metanhighci

	di "`countMissing' `countDifferent' `countMultinomial' `countSuccessCon' `countSuccessBin' `countSuccessOrd'"

}

di "skipped missing `countMissing'"
di "skipped different `countDifferent'"
di "skipped multinomial `countMultinomial'"
di "success continuous `countSuccessCon'"
di "success binary `countSuccessBin'"
di "success ord `countSuccessOrd'"

* remove metan tmp params
capture drop _LCI _UCI _WT

drop if ipvalue==.
replace ipvalue=. if ipvalue==-999

* save results with interaction p value
export delimited using "`resDir'/results-by-interaction-pvalue/results-combinedI-`start'.csv", replace

log close
