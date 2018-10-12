
	resDir=paste(Sys.getenv('RES_DIR'), '/results-21753',sep='')

	
	# results file containing the interaction P values, used to make the qq-plot
	res = read.table(paste(resDir, '/results-by-interaction-pvalue/results-combinedI-all.csv',sep=""), header=1, sep=',', comment.char="", quote="\"")

	# rename columns
	res  = res[,c("ipvalue", "varname")]

	ixNotNA = which(!is.na(res$ipvalue))
	res = res[ixNotNA,]

	##
	## sort results by p value
	pSort = sort(res[,"ipvalue"])
	numRes = length(pSort)
	#fids = res$fid[order(res$ipvalue)]

	print(paste('Number of tests:', numRes))


	##
	## generate value for plotting
	rank = rank(pSort, ties.method="first")
	rankProportion = rank/numRes
	rankProportionLog10 = -log10(rankProportion)
	pLog10 = -log10(pSort)

	
	##
	## do bonferroni correction and output this.
	bonf= 0.05/numRes
	print(paste('Bonferroni threshold:', bonf))
	threshold = -log10(bonf)
	belowBonf = length(which(pSort<bonf))
	print(paste('Number below Bonferroni threshold:', belowBonf));


	##
	## check pvalues are valid (not zero)
        idxZero = which(pSort==0)
        if (length(idxZero)>0) {
                print(paste("There are ", length(idxZero)," results with pvalues too small to be stored exactly, colored red on QQ plot.", sep=""))
        }


	##
	## set indicator for pvalue ~zero (we don't have a precise p value for these results), these are coloured red on QQ plot

	zeroVal  = rep(0, length(rankProportionLog10))
	zeroVal[idxZero] = 1
	zeroVal = as.factor(zeroVal)
	pLog10[idxZero] = -log10(5e-324)


	##
	## plot qqplot

	pdf(paste(resDir,"/results-by-interaction-pvalue/qqplot-interaction.pdf",sep=""))

	# qq
	par(pch='.')

	# axis range
	xmin=0
	xmax=max(rankProportionLog10)+1.8
	ymin=0
	ymax=max(threshold, max(pLog10))

	plot(rankProportionLog10, pLog10,col=c("#990099", "red")[zeroVal], xlab='expected -log10(p)', ylab='actual -log10(p)',cex=0.8, pch=c(16, 8)[zeroVal], xlim=c(xmin, xmax), ylim=c(ymin, ymax))


	###
	### bonferroni threshold

        # horizontal threshold line, dashed green
        segments(0, threshold, xmax, threshold, col='#008000',lty=2)


	###
	### FDR threshold
	threshold=-log10(0.05*12/16683)
	# horizontal threshold line, dashed green
        segments(0, threshold, xmax, threshold, col='#800000',lty=4)


	###
	### ascending diagonal, dotted blue

	minVal = min(max(rankProportionLog10), max(pLog10))
	segments(0, 0, minVal, minVal, col='#0066cc',lty=3)	

	junk<- dev.off()

	print("Finished QQ plot")

