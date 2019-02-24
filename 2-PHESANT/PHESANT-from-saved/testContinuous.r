
testContinuous <- function(resDir, partNum, numParts, confounders, traitofinterest, traitofinterestname, userId, phenoDir) {

	resLogFile = paste(resDir, "results-log-", partNum, "-", numParts, ".txt",sep="")

        ## load phenotype data

        phenos = read.table(paste(phenoDir, '/data-cont-', partNum, '-', numParts, '.txt',sep=''), sep=',', header=1, comment.char="")

	if (ncol(phenos)==1) {
		return(NULL)
	}

	confNames = colnames(confounders)
        confNames = confNames[-which(confNames==userId)]
        phenoNames = colnames(phenos)
        phenoNames = phenoNames[-which(phenoNames=='userID')]

        ## merge datasets
        data = merge(traitofinterest, confounders, by=userId)
        data = merge(data, phenos, by.x=userId, by.y='userID')

	for (i in 1:length(phenoNames)) {

		varName = phenoNames[i]
		print(varName)

		varType=''
		pheno = data[,varName]

		sink(resLogFile, append=TRUE)
                cat(paste(varName, ' || linear || ', sep=''))
                sink()


		numNotNA = length(which(!is.na(pheno)))
		if (numNotNA<500) {
			sink(resLogFile, append=TRUE)
			cat('<500 in total (', numNotNA, ') || SKIP ',sep='')
			sink()
		}
		else {

		sink(resLogFile, append=TRUE)
                cat('testing || ')
                sink()

		# standardise outcome because it's continuous and normal (i.e. irnt)
		pheno = scale(pheno)

		exp = data[,traitofinterestname]
		confs = data[,confNames]


		## linear regression model
		fit <- lm(pheno ~ exp + ., data=confs)

		sumx = summary(fit)
#		print(sumx)

		pvalue = sumx$coefficients['exp','Pr(>|t|)']
		beta = sumx$coefficients['exp',"Estimate"]
		cis = confint(fit, level=0.95)
		lower = cis['exp', "2.5 %"]
                upper = cis['exp', "97.5 %"]
		numNotNA = length(which(!is.na(pheno)))

		## save result to file
		sink(resLogFile, append=TRUE)
		cat("SUCCESS results-linear")
		sink()
		write(paste(varName, varType, numNotNA, beta, lower, upper, pvalue, sep=","), file=paste(resDir,"results-linear-",partNum, "-", numParts,".txt", sep=""), append=TRUE)
		}

		sink(resLogFile, append=TRUE)
		cat("\n")
		sink()

	}

}



