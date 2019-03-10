* apps/stata14

local resDir : env RES_DIR
local dataDir : env PROJECT_DATA


log using "`resDir'/results-21753/facialaging-followup/csi-strength-with-boots-ci.log", text replace


*****
***** estimate CIs using bootstrap

local resDir : env RES_DIR

* beta from main regression of csi pheno on csi IV (plus covariates)
local truebeta = 0.1053448

insheet using "`resDir'/results-21753/facialaging-followup/csi-strength-boots.txt", clear

summ

sort bootbeta

** this is to check with the se method - should be similar
di "95% using quantile method:"
di "lowerCI:"
list if _n==25
di "higherCI:"
list if _n==975


di "--------"

summ bootbeta
local se = r(sd)
local lowCI = `truebeta' - 1.96*`se'
local highCI = `truebeta' + 1.96*`se'

di "95% using SE method: [`lowCI', `highCI']"



log close
exit, clear



