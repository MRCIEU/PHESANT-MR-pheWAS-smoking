ukbdatadir=Sys.getenv('UKB_DATA')
datadir=Sys.getenv('PROJECT_DATA')

phenodatadir=paste(datadir, "/phenotypes/derived/", sep="")
confdatadir=paste(datadir, "/confounders/", sep="")

###
### Generate confounder file for sensitivity analysis
### Adjusting for age, sex, genotype chip, top 10 principal components and assessment centre

####
## confounder data

# age, sex, geno chip, assessment centre
confs = read.table(paste(phenodatadir,'data.21753-phesant_header-confounders.csv', sep=""), sep=',', header=1)
print(dim(confs))

# top 40 genetic principal components
pcs40 = read.table(paste(ukbdatadir,'/_latest/UKBIOBANK_Array_Genotypes_500k_HRC_Imputation/data/derived/principal_components/data.pca1-40.field_22009.txt',sep=""), sep=' ', col.names=c('id', 'id2', 'pc1', 'pc2', 'pc3', 'pc4', 'pc5', 'pc6', 'pc7', 'pc8', 'pc9', 'pc10', 'pc11', 'pc12', 'pc13', 'pc14', 'pc15', 'pc16', 'pc17', 'pc18', 'pc19', 'pc20', 'pc21', 'pc22', 'pc23', 'pc24', 'pc25', 'pc26', 'pc27', 'pc28', 'pc29', 'pc30', 'pc31', 'pc32', 'pc33', 'pc34', 'pc35', 'pc36', 'pc37', 'pc38', 'pc39', 'pc40'))
pcs40$id2 = NULL
pcs = pcs40



# id link file
bridge = read.table(paste(datadir,'/bridging/ukb7341.enc_ukb',sep=""), sep=',', header=1)


####
## merge data

# merge bridge file with confs
myconfs = merge(confs, bridge, by.x="eid", by.y="app16729", all.y=FALSE, all.x=FALSE)
print(dim(myconfs))

# merge pcs into myconfs
myconfs = merge(myconfs, pcs, by.x="app8786", by.y="id", all.y=FALSE, all.x=FALSE)
print(dim(myconfs))

# merge genetic batch
#myconfs = merge(myconfs, batch, by.x="app8786", by.y="id", all.y=FALSE, all.x=FALSE)
#print(dim(myconfs))

# remove genetic id, we use our pheno id
myconfs$app8786 = NULL

# remove chip (we don't use this anymore)
myconfs$x22000_0_0 = NULL


####
## process confounders into correct format



####
## basic checking

# min mean max age
min(myconfs$x21022_0_0)
max(myconfs$x21022_0_0)
mean(myconfs$x21022_0_0)

# number of each sex
unique(myconfs$x31_0_0)
length(which(myconfs$x31_0_0==0))
length(which(myconfs$x31_0_0==1))

## save file containing all confounders - age, sex, first 40 genetic principal components
write.table(myconfs, paste(confdatadir,'confounders-all.csv',sep=""), sep=',', row.names=FALSE)

