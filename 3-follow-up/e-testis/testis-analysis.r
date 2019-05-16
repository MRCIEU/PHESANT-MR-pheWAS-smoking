
dataDir=Sys.getenv('PROJECT_DATA')
resDir=Sys.getenv('RES_DIR')

source('testisAssoc.r')

##
## load data

phenoFile=paste(dataDir, '/phenotypes/derived/data-testis-followup.csv', sep='')
snpFile=paste(dataDir, '/snp/snp-withPhenIds-subset.csv', sep='')
smokPhenFile=paste(dataDir,'/phenotypes/derived//data.21753-phesant_header-smokingquantity.csv', sep='')
confFile=paste(dataDir, '/confounders/confounders-all.csv', sep='')

phenos = read.table(phenoFile, header=1,sep=",")
snp = read.table(snpFile, header=1,sep=",")
smokPhen = read.table(smokPhenFile, header=1, sep=',')
confs = read.table(confFile, header=1,sep=",")

datax = merge(snp, phenos, by='eid', all=FALSE)
datax = merge(datax, confs, by='eid', all=FALSE)
datax = merge(datax, smokPhen, by='eid', all=FALSE)

##
## restrict to men only

ix = which(datax$x31_0_0.x == 1)
datax = datax[ix,]


##
## make ever vs never binary variable

unique(datax$x20116_0_0)

ix = which(datax$x20116_0_0 == -3)
datax$x20116_0_0[ix] = NA

ix = which(datax$x20116_0_0 == 2)
datax$x20116_0_0[ix] = 1

unique(datax$x20116_0_0)

##
## create testis cancer variable

startidx = which(colnames(datax) == "x41202_0_0")
endidx = which(colnames(datax)	== "x41202_0_379")

pheno = datax[,startidx:endidx]
print(colnames(pheno))
numRows = nrow(pheno)


##
## analyse associations

resLogFile=paste(resDir, "/results-21753/testis-out.txt", sep="")
sink(resLogFile, append=FALSE)


## assoc for descended

print(dim(datax))

confounders = datax[,c("x21022_0_0.x", "pc1", "pc2","pc3","pc4","pc5","pc6","pc7","pc8","pc9","pc10")]
geno = datax$rs16969968


print("******************** ASSOC for descended") 

#idxForVar = which(pheno == "C62" | pheno == "C621" | pheno == "C620" | pheno == "C629", arr.ind=TRUE)
idxForVar = which(pheno == "C621", arr.ind=TRUE)
idxsTrue = idxForVar[,"row"]

# make zero vector and set 1s for those with this variable value
varBinary = rep.int(0,numRows)
varBinary[idxsTrue] = 1
varTestisCanc = factor(varBinary)

print(length(idxsTrue))


testisAssoc(varTestisCanc, datax, confounders, geno)


## assoc for unspecified


print("******************** ASSOC for unspecified")

idxForVar = which(pheno == "C629", arr.ind=TRUE)
idxsTrue = idxForVar[,"row"]
# make zero vector and set 1s for those with this variable value
varBinary = rep.int(0,numRows)
varBinary[idxsTrue] = 1
varTestisCanc = factor(varBinary)

print(length(idxsTrue))

testisAssoc(varTestisCanc, datax, confounders, geno)


sink()

