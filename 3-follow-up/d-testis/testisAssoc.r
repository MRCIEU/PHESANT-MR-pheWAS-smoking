

testisAssoc <- function(varTestisCanc, datax, confounders, geno) {


mylogit <- glm(varTestisCanc ~ geno + ., data=confounders, family="binomial")
sumx = summary(mylogit)
print(sumx)
pvalue = sumx$coefficients['geno','Pr(>|z|)']
beta = sumx$coefficients["geno","Estimate"]
cis = confint(mylogit, "geno", level=0.95)
lower = cis["2.5 %"]
upper = cis["97.5 %"]
print(paste(beta, '[', lower, ',', upper, ']',sep=''))


## ever smokers

ixEver = which(datax$x20116_0_0 == 1)
dataxE = datax[ixEver,]
confoundersE = confounders[ixEver,]
genoE = geno[ixEver]
varTestisCancE = varTestisCanc[ixEver]
print(dim(dataxE))

print('num ever')
print(length(ixEver))
print(length(which(datax$x20116_0_0 == 1 & varTestisCanc==1)))

mylogit <- glm(varTestisCancE ~ genoE + ., data=confoundersE, family="binomial")
sumx = summary(mylogit)
print(sumx)
pvalue = sumx$coefficients['genoE','Pr(>|z|)']
beta = sumx$coefficients["genoE","Estimate"]
cis = confint(mylogit, "genoE", level=0.95)
lower = cis["2.5 %"]
upper = cis["97.5 %"]
print(paste(beta, '[', lower, ',', upper, ']',sep=''))

## never smokers

ixNever = which(datax$x20116_0_0 == 0)
dataxN = datax[ixNever,]
confoundersN = confounders[ixNever,]
genoN = geno[ixNever]
varTestisCancN = varTestisCanc[ixNever]
print(dim(dataxN))

print('num never')
print(length(ixNever))
print(length(which(datax$x20116_0_0 == 0 & varTestisCanc==1)))


mylogit <- glm(varTestisCancN ~ genoN + ., data=confoundersN, family="binomial")
sumx = summary(mylogit)
print(sumx)
pvalue = sumx$coefficients['genoN','Pr(>|z|)']
beta = sumx$coefficients["genoN","Estimate"]
cis = confint(mylogit, "genoN", level=0.95)
lower = cis["2.5 %"]
upper = cis["97.5 %"]
print(paste(beta, '[', lower, ',', upper, ']',sep=''))


}


