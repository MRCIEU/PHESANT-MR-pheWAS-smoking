

module add languages/R-3.3.1-ATLAS

# PHESANT code subdirectory
dir="${PHESANT}/resultsProcessing/"

# directory with PHESANT results
resDir="${RES_DIR}/results-21753/results-main-never-PHESANTv0_17-fromsaved/"

outcomeInfo="${PHESANT}/variable-info/outcome-info.tsv"

cd $dir
Rscript mainCombineResults.r --resDir=${resDir} --numParts=200 --variablelistfile=$outcomeInfo

