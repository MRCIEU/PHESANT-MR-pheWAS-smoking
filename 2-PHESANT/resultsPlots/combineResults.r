
resdir=paste(Sys.getenv('RES_DIR'),'/results-21753',sep='')

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
resNever = resNever[,c("varName", "resType", "beta", "lower", "upper", "pvalue")]
resAll = resAll[,c("varName", "resType", "beta", "lower", "upper", "pvalue")]


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

names(resAll)[which(names(resNever)=="beta")] = "betaall"
names(resAll)[which(names(resNever)=="resType")] = "restypeall"
names(resAll)[which(names(resNever)=="lower")] = "lowerall"
names(resAll)[which(names(resNever)=="upper")] = "upperall"
names(resAll)[which(names(resNever)=="pvalue")] = "pvaluenall"



##
## merge, sort and save combined results

res = merge(resEver, resNever, by="varName", all=TRUE)
res = merge(res, resAll, by="varName", all=TRUE)

res = res[order(res$pvalueever),]

res$description = gsub(",","",res$description)

write.table(res, file=paste(resdir, '/results-combined.txt', sep=''), sep=',', row.names=FALSE, quote=c(2), na="")



