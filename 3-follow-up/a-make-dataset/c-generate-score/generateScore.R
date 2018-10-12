

datadir=paste(Sys.getenv('HOME'), '/2017-PHESANT-smoking-interaction/data', sep='')

smokingscoredatadir=paste(datadir, '/smokingscore-snps/', sep='')

# ukb snp data
snpdata = read.table(paste(smokingscoredatadir, 'snp-data.txt', sep=''), header=1, sep=',')

# snp list with beta so we know which allele is CSI increasing
snpinfo = read.table('../CSI_genome-wideSNPs_MRBase.txt', header=1, sep=' ')


snpdata$smokescore = 0

# loop all snps in file and add dosage to score
for (i in 1:nrow(snpinfo)) {

	thisbeta = snpinfo$beta[i]
	thisSNP = snpinfo$SNP[i]

	# get data for this snp
	thisSNPcol = which(colnames(snpdata) == thisSNP)

	# our dosages are in terms of other allele in ../CSI_genome-wideSNPs_MRBase.txt
	# if beta is -ve then add dosage, if negative then do 2-dosage to harmonise
	if (thisbeta <0) {
		snpdata$smokescore = snpdata$smokescore + snpdata[,thisSNPcol]
	}
	else {
		# if effect is in terms of other allele then reverse dosage
		snpdata$smokescore = snpdata$smokescore	+ (2-snpdata[,thisSNPcol])
	}

}

scoredata = snpdata[,c('userId', 'smokescore')]

write.table(scoredata, paste(smokingscoredatadir, 'smokingscore.txt',sep=''), row.names=FALSE, sep=',')

