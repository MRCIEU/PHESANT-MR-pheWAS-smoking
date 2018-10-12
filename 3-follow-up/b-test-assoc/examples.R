


datadir=Sys.getenv('PROJECT_DATA')
phenodir=paste(datadir, '/phenotypes/derived/', sep='')
datax = read.table(paste(phenodir, 'facialaging-dataset.csv',sep=''), header=1, sep=',')



sd(datax$csi, na.rm=TRUE)
# csi score sd is 0.6758


###
### examples of smoking history that equates to a 1 SD change.


tau<-18
delta<-0


# never smoker
dur=0;tsc=0;int=0;
tsc_star <- unlist(lapply(tsc-delta, function (x) max(x, 0)))
dur_star <- unlist(lapply(dur+tsc-delta, function (x) max(x, 0))) - tsc_star
out<-(1-0.5^(dur_star/tau))*(0.5^(tsc_star/tau))*(log(int+1))
out
# out=0


# 12 years duration, current smoker, cigarettes per day=5
dur=12;tsc=0;int=5;
tsc_star <- unlist(lapply(tsc-delta, function (x) max(x, 0)))
dur_star <- unlist(lapply(dur+tsc-delta, function (x) max(x, 0))) - tsc_star
out<-(1-0.5^(dur_star/tau))*(0.5^(tsc_star/tau))*(log(int+1))
out
# 0.66

# 21 years duration, former smoker who quit 10 years ago, cigarettes per day=5
dur=21;tsc=10;int=5;
tsc_star <- unlist(lapply(tsc-delta, function (x) max(x, 0)))
dur_star <- unlist(lapply(dur+tsc-delta, function (x) max(x, 0))) - tsc_star
out<-(1-0.5^(dur_star/tau))*(0.5^(tsc_star/tau))*(log(int+1))
out
# out=0.68

