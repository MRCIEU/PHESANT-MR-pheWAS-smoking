* apps/stata15

args ixStart ixEnd

local homeDir : env HOME
local resDir = "`homeDir'/2017-PHESANT-smoking-interaction/results/"
local dataDir = "`homeDir'/2017-PHESANT-smoking-interaction/data/"


log using "`resDir'/results-21753/facialaging-followup/csi-causal-estimate-with-boots`ixStart'.log", text replace

insheet using "`dataDir'/phenotypes/derived/facialaging-dataset.csv", clear



summ

rename x31_0_0 sex
rename x21022_0_0 age


*****
***** CSI analysis


***
*** convert facial aging to binary so we can use iv probit regression

gen facial_agingBin = .
replace facial_agingBin = 0 if facial_aging == 1
replace facial_agingBin = 0 if facial_aging == 2
replace facial_agingBin = 1 if facial_aging == 3


***
*** IV of lifetime smoking

ivprobit facial_agingBin sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (csi = smokescore), first
local beta _b[csi]
local ciL _b[csi] - 1.96 * _se[csi]
local ciU _b[csi] + 1.96 * _se[csi]
di exp(1.6*(`beta')) 
di exp(1.6*(`ciL')) 
di exp(1.6*(`ciU'))

* sensitivity - 40 pcs
ivprobit facial_agingBin sex age pc* (csi = smokescore), first
local beta _b[csi]
local ciL _b[csi] - 1.96 * _se[csi]
local ciU _b[csi] + 1.96 * _se[csi]
di exp(1.6*(`beta')) 
di exp(1.6*(`ciL'))
di exp(1.6*(`ciU'))





*****
***** bootstrap to get CIs

program define myboots, rclass
	 preserve 
	  bsample
	  ivprobit facial_agingBin sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (csi = smokescore)
	  return scalar bcsi = _b[csi]
	restore
end

local thisseed=`ixStart'+1234
set seed `thisseed'

file open myfile using "`resDir'/results-21753/facialaging-followup/csi-causal-estimate-bootsx`ixStart'.txt", write replace
*file write myfile "bootn,bootbeta" _n
forval i = `ixStart'/`ixEnd' {
	myboots
	di r(bcsi)
	file write myfile "`i',`r(bcsi)'" _n
}
file close myfile



log close
exit, clear



