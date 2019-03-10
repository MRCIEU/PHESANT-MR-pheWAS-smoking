

datadir=Sys.getenv('PROJECT_DATA')


second = read.table(paste0(datadir, '/snp/snp-withPhenIds-rs1051730.csv'), sep=',', header=1)
dim(second)

first = read.table(paste0(datadir, '/snp/snp-withPhenIds-subset.csv'),sep=',', header=1)
dim(first)

x = merge(first, second, by='userId')
dim(x)

cor(x$rs16969968, x$rs1051730)

