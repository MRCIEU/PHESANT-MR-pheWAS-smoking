
resdir=paste(Sys.getenv('RES_DIR'), '/results-21753',sep='')


resDirSubEver=paste(resdir,"/results-main-ever-PHESANTv0_17-fromsaved/",sep='')
resDirSubNever=paste(resdir,"/results-main-never-PHESANTv0_17-fromsaved/", sep='')
resDirAll=paste(resdir,"/results-main-all-PHESANTv0_17-fromsaved/", sep='')


##
## read results of MR-pheWAS

resEver = read.table(paste(resDirSubEver, 'results-combined.txt', sep=''), header=1, sep='\t', comment.char='', quote='')
resNever = read.table(paste(resDirSubNever, 'results-combined.txt', sep=''), header=1, sep='\t', comment.char='', quote='')
resAll = read.table(paste(resDirAll, 'results-combined.txt', sep=''), header=1, sep='\t', comment.char='', quote='')


##
## keep only the columns we need

resEver = resEver[,c("varName", "description", "resType", "beta", "lower", "upper", "pvalue")]
resEver$varName = gsub("X","",resEver$varName)
resEver$varName = gsub(".","#",resEver$varName, fixed=TRUE)

resNever = resNever[,c("varName", "resType", "beta", "lower", "upper", "pvalue")]
resNever$varName = gsub("X","",resNever$varName)
resNever$varName = gsub(".","#",resNever$varName, fixed=TRUE)

resAll = resAll[,c("varName", "resType", "beta", "lower", "upper", "pvalue")]
resAll$varName = gsub("X","",resAll$varName)
resAll$varName = gsub(".","#",resAll$varName, fixed=TRUE)


resEver$varName = gsub('-.+', '', resEver$varName)
resNever$varName = gsub('-.+', '', resNever$varName)
resAll$varName = gsub('-.+', '', resAll$varName)


##
## rename subsample results so when combining they are labelled

names(resEver)[which(names(resEver)=="beta")] = "betaever"
names(resEver)[which(names(resEver)=="resType")] = "restypeever"
names(resEver)[which(names(resEver)=="lower")] = "lowerever"
names(resEver)[which(names(resEver)=="upper")] = "upperever"
names(resEver)[which(names(resEver)=="pvalue")] = "pvalueever"

names(resNever)[which(names(resNever)=="beta")] = "betanever"
names(resNever)[which(names(resNever)=="resType")] = "restypenever"
names(resNever)[which(names(resNever)=="lower")] = "lowernever"
names(resNever)[which(names(resNever)=="upper")] = "uppernever"
names(resNever)[which(names(resNever)=="pvalue")] = "pvaluenever"

names(resAll)[which(names(resAll)=="beta")] = "betaall"
names(resAll)[which(names(resAll)=="resType")] = "restypeall"
names(resAll)[which(names(resAll)=="lower")] = "lowerall"
names(resAll)[which(names(resAll)=="upper")] = "upperall"
names(resAll)[which(names(resAll)=="pvalue")] = "pvalueall"



##
## merge, sort and save combined results

res = merge(resEver, resNever, by="varName", all=TRUE)
res = merge(res, resAll, by="varName", all=TRUE)

res$description = gsub(",","",res$description)


print(head(res))

res$assocEver=""
i = which(!is.na(res$betaever))
res$assocEver[i] = paste(format(round(res$betaever[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ' [', format(round(res$lowerever[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ', ', format(round(res$upperever[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ']', sep="")

res$assocNever=""
i = which(!is.na(res$betanever))
res$assocNever[i] =  paste(format(round(res$betanever[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ' [', format(round(res$lowernever[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ', ', format(round(res$uppernever[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ']', sep="")

res$assocAll=""
i = which(!is.na(res$betaall))
res$assocAll[i] = paste(format(round(res$betaall[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ' [', format(round(res$lowerall[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ', ', format(round(res$upperall[i],3), nsmall=3, scientific=FALSE, trim=TRUE, width=0), ']', sep="")




## Supplementary venn diagram

res$topever = FALSE
res = res[order(res$pvalueever),]
res$topever[1:69] = TRUE

res$topnever = FALSE
res = res[order(res$pvaluenever),]
res$topnever[1:8] = TRUE

res$topall = FALSE
res = res[order(res$pvalueall),]
res$topall[1:48] = TRUE

print("Number for supplementary venn diagram")

num = length(which(res$topever == TRUE & res$topnever == TRUE & res$topall == TRUE))
print(paste("EVER and NEVER and ALL:", num))

num = length(which(res$topever == TRUE & res$topnever == TRUE & res$topall == FALSE))
print(paste("EVER and NEVER and not ALL:", num))

num = length(which(res$topever == TRUE & res$topnever == FALSE & res$topall == TRUE))
print(paste("EVER and not NEVER and ALL:", num))

num = length(which(res$topever == FALSE & res$topnever == TRUE & res$topall == TRUE))
print(paste("not EVER and NEVER and ALL:", num))

num = length(which(res$topever == FALSE & res$topnever == FALSE & res$topall == TRUE))
print(paste("not EVER and not NEVER and ALL:", num))

num = length(which(res$topever == FALSE & res$topnever == TRUE & res$topall == FALSE))
print(paste("not EVER and NEVER and not ALL:", num))

num = length(which(res$topever == TRUE & res$topnever == FALSE & res$topall == FALSE))
print(paste("EVER and not NEVER and not ALL:", num))



print("#################################")
print('Interaction results')
resInteraction = c("20150", "20154", "3063", "1180", "30030","30000","30140","30020","22130", "41204#J439", "40011#8071", "1757")
print(res[which(res$varName %in% resInteraction),c("varName", "topever", "topnever", "topall")])




##
## Ever supplementary table

# find all ever results

res = res[order(res$pvalueever),]

ix = which(!is.na(res$betaever))
resx = res[ix,]
i=1
everfile=paste(resdir, '/sup-ever.txt', sep='')

# clear file
sink(everfile)
sink()

for (i in 1:69) {

	# only include never results if type of regression is the same as ever test
	assocNever = ''
	if (!is.na(resx$restypenever[i]) & (resx$restypeever[i] == resx$restypenever[i])) {
		assocNever = resx$assocNever[i]
	}

	line = paste(resx$varName[i], format(resx$pvalueever[i], digits=3, scientific=TRUE), resx$assocEver[i], assocNever, resx$restypeever[i], resx$description[i], sep='\t')
	write(line, file=everfile, append=TRUE)
}


##
## Never supplementary table

# find all ever results

res = res[order(res$pvaluenever),]

ix = which(!is.na(res$betanever))
resx = res[ix,]
i=1
neverfile=paste(resdir, '/sup-never.txt', sep='')

# clear file
sink(neverfile)
sink()

for (i in 1:8) {

        # only include ever results if type of regression is the same as never test
        assocEver = ''
        if (!is.na(resx$restypeever[i]) & (resx$restypeever[i] == resx$restypenever[i])) {
		assocEver = resx$assocEver[i]
        }

	line = paste(resx$varName[i], format(resx$pvaluenever[i], digits=3, scientific=TRUE), resx$assocNever[i], assocEver, resx$restypenever[i], resx$description[i], sep='\t') 
       	write(line, file=neverfile, append=TRUE)
}


## All supplementary table

# find all 'all' results

res = res[order(res$pvalueall),]

ix = which(!is.na(res$betaall))
resx = res[ix,]
print(paste('number of all results:', length(ix)))
i=1
allfile=paste(resdir, '/sup-all.txt', sep='')

# clear file
sink(allfile)
sink()


for (i in 1:48) {

        # only include ever results if type of regression is the same as 'all' test
        assocEver = 'X'
        if (!is.na(resx$restypeever[i]) & (resx$restypeever[i] == resx$restypeall[i])) {
                assocEver = resx$assocEver[i]
        }
	# only include ever results if type of regression is the same as 'all' test
	assocNever = 'X'
        if (!is.na(resx$restypenever[i]) & (resx$restypenever[i] == resx$restypeall[i])) {
                assocNever = resx$assocNever[i]
        }


	line = paste(resx$varName[i], format(resx$pvalueall[i], digits=3, scientific=TRUE), resx$assocAll[i], assocEver, assocNever, resx$restypeall[i], resx$description[i], sep='\t')
        write(line, file=allfile, append=TRUE)
}




## Full results supplementary data file

# add interaction pvalue to results
resDirI=paste(resdir,"/results-by-interaction-pvalue/", sep='')
resI = read.table(paste(resDirI, 'results-combinedI-all.csv', sep=''), header=1, sep=',', comment.char='', quote='')
resI$varname = gsub("X","",resI$varname)
resI$varname = gsub(".","#",resI$varname, fixed=TRUE)


print(head(resI))
resI = resI[,c("varname", "ipvalue")]
res = merge(res, resI, by.x="varName", by.y="varname", all=TRUE)


res = res[order(res$pvalueever),c("varName","restypeever","assocEver", "pvalueever", "restypenever", "assocNever", "pvaluenever", "restypeall", "assocAll", "pvalueall", "ipvalue", "description")]

write.table(res, file=paste(resdir, '/supplementary-data-file.tsv', sep=''), sep='\t', row.names=FALSE, na="", quote=FALSE)

