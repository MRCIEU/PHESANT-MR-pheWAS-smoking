* apps/stata14

local resDir : env RES_DIR
local dataDir : env PROJECT_DATA


log using "`resDir'/results-21753/facialaging-followup/csi-causal-estimate-with-boots-ci.log", text replace


*****
***** estimate CIs using bootstrap

local resDir : env RES_DIR

* beta from IVprobit regression - i.e. not the odds we derive from this and in the paper but the original coef
local truebeta = 0.1564251

insheet using "`resDir'/results-21753/facialaging-followup/csi-causal-estimate-boots.txt", clear

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

local betaodds = exp(1.6*(`truebeta'))
local ciLodds = exp(1.6*(`lowCI'))
local ciUodds = exp(1.6*(`highCI'))

di "95% using SE method odds approximation: `betaodds' [`ciLodds', `ciUodds']"



log close
exit, clear



