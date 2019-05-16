
* This is a simluation for supplementary figure 6c.
* Effect of the snp on the outcome via smoking status.
* This means that there is an effect of the snp on the outcome in the whole sample, 
* but in smoking status strata there is not effect because stratifying on smoking
* status blocks this path.

clear
set seed 1234

* set number of participants
local n=1000000
set obs `n'


* create snp variable
local n0 = `n'*0.4494
local n1 = `n'*0.4422
local n2 = `n'*0.1083
gen snp = 0
replace snp = 1 if _n > `n0' & _n <= `n0'+`n1'
replace snp = 2 if _n > `n0'+`n1'



 * generate smoke status variable as a function of snp
gen logitPart=(log(0.1))*snp + log(0.1)
gen pss=exp(logitPart)/(1+exp(logitPart))

* randomly assign people to morningness according to probabilities
gen smoke_status = 0
gen sstemp = runiform()
replace smoke_status = 1 if sstemp <=pss

gen morningcont = 0.1*smoke_status + runiform()
gen morning = 0
replace morning = 1 if morningcont <=0.5


* smoking heaviness

gen smok_heav = 0
replace smok_heav = snp + rnormal(0,1) if smoke_status == 1



logistic morning snp

* ever smokers
logistic morning snp if smoke_status == 1

* never smokers
logistic morning snp if smoke_status == 0


