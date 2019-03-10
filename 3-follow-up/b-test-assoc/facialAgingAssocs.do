* apps/stata15

local resDir : env RES_DIR
local dataDir : env PROJECT_DATA


log using "`resDir'/results-21753/facialaging-followup/facialaging-results.log", text replace

insheet using "`dataDir'/phenotypes/derived/facialaging-dataset.csv", clear



summ

count if facial_aging!=. & neverever==0
count if facial_aging!=. & neverever==1


hist csi
graph export "`resDir'/results-21753/facialaging-followup/csi-hist.pdf", replace
hist smokescore 
graph export "`resDir'/results-21753/facialaging-followup/smokescore-hist.pdf", replace


**
** basic associations

rename x31_0_0 sex
rename x21022_0_0 age

* snp effect on smoking quantity
ologit smokquant rs16969968 sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10
local beta _b[rs16969968]
local ciL _b[rs16969968] - 1.96 * _se[rs16969968]
local ciU _b[rs16969968] + 1.96 * _se[rs16969968]
di exp(`beta')
di exp(`ciL')
di exp(`ciU')


* snp effect on ever versus never
logit smoke_status rs16969968 sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10
local beta _b[rs16969968]
local ciL _b[rs16969968] - 1.96 * _se[rs16969968]
local ciU _b[rs16969968] + 1.96 * _se[rs16969968]
di exp(`beta')
di exp(`ciL')
di exp(`ciU')


****
**** stats needed for colider bias sim

* facial aging sim

logit smoke_status rs16969968 if facial_aging !=. & smoke_status!=., or
tab rs16969968 if facial_aging !=. & smoke_status!=.


* general sim

logit smoke_status rs16969968 if smoke_status!=., or
tab rs16969968 if smoke_status!=.




****
**** estimate effect of snp on facial aging, and interaction between ever and never smokers

	**
	** in ever smokers

	ologit facial_aging rs16969968 sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 if neverever==1
	local betaE _b[rs16969968]
	local ciLE _b[rs16969968] - 1.96 * _se[rs16969968]
	local ciUE _b[rs16969968] + 1.96 * _se[rs16969968]

	gen metanBeta = `betaE' if _n==1
        gen metanlowci = `ciLE' if _n==1
        gen metanhighci = `ciUE' if _n==1

	di exp(`betaE')
	di exp(`ciLE')
	di exp(`ciUE')


	**
	** in never smokers

	ologit facial_aging rs16969968 sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 if neverever==0
        local betaN _b[rs16969968]
        local ciLN _b[rs16969968] - 1.96 * _se[rs16969968]
        local ciUN _b[rs16969968] + 1.96 * _se[rs16969968]

	replace metanBeta = `betaN' if _n==2
        replace metanlowci = `ciLN' if _n==2
        replace metanhighci = `ciUN' if _n==2

	di exp(`betaN')
	di exp(`ciLN')
	di exp(`ciUN')


	**
	** p for interaction

	metan metanBeta metanlowci metanhighci
	local res $S_9
	di "P for interaction `res'"

	* store this value

	* remove temp variables
	drop metanBeta
	drop metanlowci
	drop metanhighci


	***
	*** sensitivity analysis adjusting also for first 40 pcs, assessment centre and genetic batch

	**
	** in ever smokers

	ologit facial_aging rs16969968 sex age pc* if neverever==1
        local betaE _b[rs16969968]
        local ciLE _b[rs16969968] - 1.96 * _se[rs16969968]
        local ciUE _b[rs16969968] + 1.96 * _se[rs16969968]

	gen metanBeta = `betaE' if _n==1
        gen metanlowci = `ciLE' if _n==1
        gen metanhighci = `ciUE' if _n==1

	di exp(`betaE')
	di exp(`ciLE')
	di exp(`ciUE')

        **
	** in never smokers

        ologit facial_aging rs16969968 sex age pc* if neverever==0
        local betaN _b[rs16969968]
        local ciLN _b[rs16969968] - 1.96 * _se[rs16969968]
        local ciUN _b[rs16969968] + 1.96 * _se[rs16969968]

	di exp(`betaN')
        di exp(`ciLN')
        di exp(`ciUN')

	replace metanBeta = `betaN' if _n==2
        replace metanlowci = `ciLN' if _n==2
        replace metanhighci = `ciUN' if _n==2

	metan metanBeta metanlowci metanhighci
        local res $S_9
        di "P for interaction `res'"
	
	* remove temp variables
        drop metanBeta
        drop metanlowci
        drop metanhighci




*****
***** CSI analysis


***
*** how strong is our csi instrument


* association after adjustment
regress csi smokescore sex age pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10


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



* close file writing

log close

exit, clear



