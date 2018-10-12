

dataDir=Sys.getenv('PROJECT_DATA')

phenoFile=paste(dataDir, '/phenotypes/derived/data.21753-phesant_header-smokingscore-followup-clean.csv', sep='')
confFile=paste(dataDir, '/confounders/confounders-all.csv', sep='')
smokeIVFile=paste(dataDir, '/smokingscore-snps/smokescore-withPhenIds-subset.csv', sep='')
smokPhenFile=paste(dataDir,'/phenotypes/derived/data.21753-phesant_header-facialaging.csv', sep='')
snpFile=paste(dataDir, '/snp/snp-withPhenIds-subset.csv', sep='')



phenos = read.table(phenoFile, header=1,sep=",")
confs = read.table(confFile, header=1,sep=",")
snp = read.table(snpFile, header=1,sep=",")
smokeIV = read.table(smokeIVFile, header=1,sep=",")
smokPhen = read.table(smokPhenFile, header=1, sep=',')

datax = merge(snp, phenos, by='eid', all=FALSE)
datax = merge(datax, smokeIV, by='eid', all=FALSE)
datax = merge(datax, confs, by='eid', all=FALSE)
datax = merge(datax, smokPhen, by='eid', all=FALSE)


library(reshape)
datax<-rename(datax, c(x1757_0_0="facial_aging"))
str(datax)

table(datax$facial_aging)
datax$facial_aging[datax$facial_aging == -3] <-NA
datax$facial_aging[datax$facial_aging == -1] <-NA

# swap so in order of aging
datax$facial_aging[datax$facial_aging == 2] <-4
datax$facial_aging[datax$facial_aging == 3] <-2
datax$facial_aging[datax$facial_aging == 4] <-3

table(datax$facial_aging)

str(datax)
summary(datax)




# generate smoking quantity as:
# 0: current or former smoker, smoking between 1 and 10 cigarettes per day
# 1: current or	former smoker, smoking between 10 and 20 cigarettes per day
# 2: current or	former smoker, smoking between 20 and 30 cigarettes per day
# 3: current or	former smoker, smoking between 30 and 40 cigarettes per day

datax$smokQuant = NA
datax$smokQuant[datax$cpd_current>=0 & datax$cpd_current<=10] = 0
datax$smokQuant[datax$cpd_former>=0 & datax$cpd_former<=10] = 0
datax$smokQuant[datax$cpd_current>=10 & datax$cpd_current<=20] = 1
datax$smokQuant[datax$cpd_former>=10 & datax$cpd_former<=20] = 1
datax$smokQuant[datax$cpd_current>=20 & datax$cpd_current<=30] = 2
datax$smokQuant[datax$cpd_former>=20 & datax$cpd_former<=30] = 2
datax$smokQuant[datax$cpd_current>30] = 3
datax$smokQuant[datax$cpd_former>30] = 3




# standardise lifetime smoking IV and phenotype
datax$smokescore = scale(datax$smokescore)
datax$csi = scale(datax$csi)

# create binary never vs ever variable
datax$neverever = NA
datax$neverever[which(datax$smoke_status==0)] = 0 
datax$neverever[which(datax$smoke_status==1)] = 1
datax$neverever[which(datax$smoke_status==2)] = 1



# save dataset

outFile=paste(dataDir, '/phenotypes/derived/facialaging-dataset.csv', sep='')
write.table(datax, outFile, quote=FALSE, row.names=FALSE, sep=',', na="")



