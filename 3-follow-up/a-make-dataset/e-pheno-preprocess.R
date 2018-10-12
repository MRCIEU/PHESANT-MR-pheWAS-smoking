

## Adapted from Robyn Wootton's script for the paper - Causal effects of lifetime smoking on risk for depression and schizophrenia: Evidence from a Mendelian randomisation study


##########################################################################
#1. Read in data
##########################################################################


datadir=Sys.getenv('PROJECT_DATA')
phenodir=paste(datadir, '/phenotypes/derived/', sep='')
df2 = read.table(paste(phenodir, 'data.21753-phesant_header-smokingscore-followup.csv',sep=''), header=1, sep=',')




##########################################################################
# 2. Tidy up data - name variables appropriately
##########################################################################

print('Tidy up data - name variables appropriately')


print('- rename')
# Rename the variables
library(reshape)
tidy<-rename(df2, c(x20116_0_0="smoke_status",x40001_0_0="cause", x3436_0_0="start_current", x2897_0_0="stop", x2867_0_0="start_former",  x3456_0_0="cpd_current", x2887_0_0="cpd_former", x31_0_0="sex", x189_0_0="SES", x21000_0_0="ethnic", x6138_0_0="edu", x21022_0_0="Age"))
str(tidy)

print('restrict to required variables')
# #subset the time point 1 variables
df<-subset(tidy, select=c("eid", "smoke_status", "start_current", "start_former", "stop", "cpd_current",  "cpd_former", "cause", "sex", "Age"))
str(df)
head(df)

##########################################################################
# 3. Restrict to our included subsample
##########################################################################


print('Restrict to our included subsample')

# load score data - this is the right subsample
smokingscoredatadir=paste(datadir, '/smokingscore-snps/', sep='')
smokingscore = read.table(paste(smokingscoredatadir, '/smokescore-withPhenIds-subset.csv',sep=''), header=1, sep=',')

# restrict to this subsample
data = merge(df, smokingscore, by='eid')
print(dim(data))



########################################################################
# 4. Create duration and cpd variables
########################################################################

print('Create duration and cpd variables')

#Make all missing values into NA
print('- start_current')
table(data$start_current)
data$start_current[data$start_current == -3] <-NA
data$start_current[data$start_current == -1] <-NA
table(data$start_current)

print('- start_former')
table(data$start_former)
data$start_former[data$start_former == -3] <-NA
data$start_former[data$start_former == -1] <-NA
table(data$start_former)

print('- stop')
table(data$stop)
data$stop[data$stop == -3] <-NA
data$stop[data$stop == -1] <-NA
table(data$stop)

print('- cpd_current')
table(data$cpd_current)
data$cpd_current[data$cpd_current == -3] <-NA
data$cpd_current[data$cpd_current == -1] <-NA
data$cpd_current[data$cpd_current == -10] <-NA
table(data$cpd_current)

print('- cpd_former')
table(data$cpd_former)
data$cpd_former[data$cpd_former == -3] <-NA
data$cpd_former[data$cpd_former == -1] <-NA
data$cpd_former[data$cpd_former == -10] <-NA
table(data$cpd_former)

print('- smoke_status')
#levels(data$smoke_status)
table(data$smoke_status)
data$smoke_status[data$smoke_status == -3] <-NA
table(data$smoke_status)



print('- Derive num years a smoker')

# Robyn's code
#for (i in 1:nrow(data)){
#	if (is.na(data$start_current[i])){
#		data$durOFF[i]<-(data$stop[i]-data$start_former[i])}
#	else {
#		data$durOFF[i]<-(data$Age[i]-data$start_current[i])
#	}
#}

# my code (faster)
data$dur=NA
ixNACurrent = is.na(data$start_current)
data$dur[ixNACurrent] = (data$stop[ixNACurrent]-data$start_former[ixNACurrent])
data$dur[!ixNACurrent] = (data$Age[!ixNACurrent] -data$start_current[!ixNACurrent])

# checking my version gives the same as Robyn's code above
#str(data)
#ix=data$dur==data$durOFF
#which(ix==FALSE)
#summary(data[,c('dur', 'durOFF')])


print('- create tsc variable')
#Create tsc (time since cessation) variable
str(data)
data$tsc<-data$Age-data$stop


print('- create cpd variable')
#Create cpd (cigarettes per day) variable by merging cpd_current and cpd_former
data$cpd<-data$cpd_current
my.na <- is.na(data$cpd_current)
data$cpd[my.na] <- data$cpd_former[my.na]

head(data)

#Make NAs ==0
print('- set all non-smokers to 0')
# Set non smokers to 0 but those with missing smoking status are still NA
data$cpd[!is.na(data$smoke_status) & is.na(data$cpd)] <-0
data$dur[!is.na(data$smoke_status) & is.na(data$dur)] <-0
data$tsc[!is.na(data$smoke_status) & is.na(data$tsc)] <-0
#data$cpd[is.na(data$cpd)] <-0
#data$dur[is.na(data$dur)] <-0
#data$tsc[is.na(data$tsc)] <-0


levels(data$smoke_status)
ix = which(is.na(data$smoke_status))
print(data[ix[1:5],])
head(data)


########################################################################
# 5. Create csi with the best fitting values
########################################################################
#the best fitting values were 18 years for tau and 0 for delta
tau<-18
delta<-0


# csi (comprehensive smoking index) function
csi <- function(dur, tau, delta, tsc, int){

  #The function
  tsc_star <- unlist(lapply(tsc-delta, function (x) max(x, 0)))
  dur_star <- unlist(lapply(dur+tsc-delta, function (x) max(x, 0))) - tsc_star
  out<-(1-0.5^(dur_star/tau))*(0.5^(tsc_star/tau))*(log(int+1))
  out
}


data$csi<-csi(data$dur, tau, delta, data$tsc, data$cpd)
str(data)
summary(data)


data = data[,c('eid', 'csi', 'cpd_current', 'cpd_former', 'smoke_status')]


write.table(data, paste(phenodir, 'data.21753-phesant_header-smokingscore-followup-clean.csv',sep=''), row.names=FALSE, sep=',')



