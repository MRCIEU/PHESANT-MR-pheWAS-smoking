
testCategoricalUnordered <- function(resDir, partNum, numParts, confounders, traitofinterest, traitofinterestname, userId, phenoDir) {


	require(nnet)

	resLogFile = paste(resDir, "results-log-", partNum, "-", numParts, ".txt",sep="")

        ## load phenotype data

        phenos = read.table(paste(phenoDir, '/data-catunord-', partNum, '-', numParts, '.txt',sep=''), sep=',', header=1, comment.char="")

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

		sink(resLogFile, append=TRUE)
                cat(paste(varName, ' || catunord || ', sep=''))
                sink()

		varType=''
		pheno = data[,varName]

		uniqVar = unique(na.omit(pheno))
		
		numNotNA = length(which(!is.na(pheno)))
		if (numNotNA<500) {
			print('<500 in total')
			sink(resLogFile, append=TRUE)
			cat('<500 in total (', numNotNA, ') || SKIP ',sep='')
                        sink()
		}
		else if (length(uniqVar)<=1) {
			print('<2 unique values')
                        sink(resLogFile, append=TRUE)
                        cat('<2 unique values (', length(uniqVar), ') || SKIP ',sep='')
                        sink()

		}
		else {

		exp = data[,traitofinterestname]
		confs = data[,confNames]

		numUnique = length(unique(na.omit(pheno)))
		numWeights=(numUnique-1)*(ncol(confs)+1+1)

		if (numWeights>1000) {
			sink(resLogFile, append=TRUE)
			cat("Too many weights in model: ", numWeights, " > 1000, (num outcomes values: ", numUnique, ") || SKIP ", sep="")
			sink()
		}
		else {

		sink(resLogFile, append=TRUE)
                cat('testing || ')
                sink()

	
		phenoFactor = chooseReferenceCategory(pheno)
		reference = levels(phenoFactor)[1]

		print(unique(phenoFactor))

		## unordered logistic regression

		sink('/tmp/off.txt')
		fit <- multinom(phenoFactor ~ exp + ., data=confs, maxit=1000)

		## baseline model with only confounders, to which we compare the model above
		fitB <- multinom(phenoFactor ~ ., data=confs, maxit=1000)

		sink()

		## compare model to baseline model
		require(lmtest)
		lres = lrtest(fit, fitB)
		modelP = lres[2,"Pr(>Chisq)"]

		maxFreq = length(which(phenoFactor==reference))
		numNotNA = length(which(!is.na(phenoFactor)))

		sink(resLogFile, append=TRUE)
                cat("SUCCESS results-catunord")
                sink()
	    	write(paste(paste(varName,"-",reference,sep=""), varType, paste(maxFreq,"/",numNotNA,sep=""), -999, -999, -999, modelP, sep=","), file=paste(resDir,"results-multinomial-logistic-",partNum, "-", numParts,".txt",sep=""), append="TRUE")

		}


		}

		sink(resLogFile, append=TRUE)
                cat("\n")
                sink()
	}
}



chooseReferenceCategory <- function(pheno) {

	uniqVar = unique(na.omit(pheno));
	phenoFactor = factor(pheno)

	maxFreq=0;
	maxFreqVar = "";
	for (u in uniqVar) {
		withValIdx = which(pheno==u)
		numWithVal = length(withValIdx);
		if (numWithVal>maxFreq) {
			maxFreq = numWithVal;
			maxFreqVar = u;
		}
	}

	cat("reference: ", maxFreqVar,"=",maxFreq, " || ", sep="");
		
	## choose reference (category with largest frequency)
	phenoFactor <- relevel(phenoFactor, ref = paste("",maxFreqVar,sep=""))
	
	return(phenoFactor);
}

