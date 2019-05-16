clear
set seed 1234

* set number of participants
local n=1000000
set obs `n'


* This is a simluation for supplementary figure 6d.
* This example shows how smoking status can modulate the effect of the snp on
* an outcome even when the effect is not via smoking heaviness.


* create binary smoking status variable
*gen smoke_status_cont = rnormal(0,1)
*gen smoke_status = 0
*replace smoke_status = 1 if  smoke_status_cont > 1

* create snp variable
local n0 = `n'*0.4494
local n1 = `n'*0.4422
local n2 = `n'*0.1083
gen snp = 0
replace snp = 1 if _n > `n0' & _n <= `n0'+`n1'
replace snp = 2 if _n > `n0'+`n1'


* compulsive behaviours
gen compulsiveScore = snp + runiform()

* risk taking
gen riskTakingScore = runiform()

* drinking
gen drinkingScore = 2*compulsiveScore + riskTakingScore  + 2*compulsiveScore*riskTakingScore + runiform()


* generate morning/evening variable as a function of smoke_status and snp
gen logitPart=(log(0.1))*riskTakingScore + log(0.1)
gen pss=exp(logitPart)/(1+exp(logitPart))

* randomly assign people to morningness according to probabilities
gen smoke_status = 0
gen sstemp = runiform()
replace smoke_status = 1 if sstemp <=pss

* associations in the whole sample
regress drinkingScore snp

* ever smokers
regress drinkingScore snp if smoke_status == 1

* never smokers
regress drinkingScore snp if smoke_status == 0



