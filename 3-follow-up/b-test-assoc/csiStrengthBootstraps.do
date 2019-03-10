* apps/stata15

local homeDir : env HOME
local resDir = "`homeDir'/2017-PHESANT-smoking-interaction/results/"
local dataDir = "`homeDir'/2017-PHESANT-smoking-interaction/data/"


log using "`resDir'/results-21753/facialaging-followup/csi-strength-with-boots.log", text replace

insheet using "`dataDir'/phenotypes/derived/facialaging-dataset.csv", clear



summ

rename x31_0_0 sex
rename x21022_0_0 age


*****
***** CSI analysis


***
*** how strong is our csi instrument


* association after adjustment
regress csi smokescore sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10



*****
***** bootstrap to get CIs

*bootstrap _b, reps(10) seed(1234): regress csi smokescore sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10

program define myboots, rclass
	 preserve 
	  bsample
	  regress csi smokescore sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10
	  return scalar bsmokescore = _b[smokescore]
	 restore
end

set seed 1234
*simulate bsmokescore=r(bsmokescore), reps(10) seed(12345): myboot

file open myfile using "`resDir'/results-21753/facialaging-followup/csi-strength-boots.txt", write replace
file write myfile "bootn,bootbeta" _n
forval i = 1/1000 {
	myboots
	di r(bsmokescore)
	file write myfile "`i',`r(bsmokescore)'" _n
}
file close myfile



log close
exit, clear



