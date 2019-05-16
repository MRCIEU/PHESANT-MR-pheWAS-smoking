
* This is a simluation for supplementary figure 6b.
* Independent effects of the snp and smoking status on being a morning person.
* This means that the effect of the snp on the outcome overall and in 
* smoking status strata are consistent.

clear
set seed 1234

* set number of participants
local n=1000000
set obs `n'

* create binary smoking status variable
gen smoke_status_cont = rnormal(0,1)
gen smoke_status = 0
replace smoke_status = 1 if  smoke_status_cont > 1

* create snp variable
local n0 = `n'*0.4494
local n1 = `n'*0.4422
local n2 = `n'*0.1083
gen snp = 0
replace snp = 1 if _n > `n0' & _n <= `n0'+`n1'
replace snp = 2 if _n > `n0'+`n1'

* smoking heaviness

gen smok_heav = 0
replace smok_heav = snp + rnormal(0,1) if smoke_status == 1

**
** generate morning/evening variable as a function of smoking heaviness and snp

** horizontal pleiotropy and effect via smoking heaviness
** - effects in both ever and never strata, and also interaction between them
gen logitPart=(log(0.8))*snp + (log(0.5))*smok_heav + log(0.1)

** no horiz pleiotropy, effect only via smoking heaviness
** - effect seen in ever stratum but no effect in never strata
*gen logitPart=(log(0.8))*smok_heav + log(0.1)

** only a horiz pleiotropic effect 
** - effects in strata are consistent with effects in whole sample
*gen logitPart=(log(0.5))*snp + log(0.1)




gen pMorning=exp(logitPart)/(1+exp(logitPart))

* randomly assign people to morningness according to probabilities
gen morning = 0
gen morntemp = runiform()
replace morning = 1 if morntemp <=pMorning

* associations in the whole sample
logistic morning smoke_status

logistic morning snp

* ever smokers
logistic morning snp if smoke_status == 1

* never smokers
logistic morning snp if smoke_status == 0


