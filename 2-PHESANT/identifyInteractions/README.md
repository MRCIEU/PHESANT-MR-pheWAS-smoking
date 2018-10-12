


# Generating interaction-based results

In this directory we take the ever and never results from PHESANT, and generate results based on how much these results interact.



1. Generate interaction pvalues

```bash
cd jobs/
qsub j.sh
```


3. Combine results with interaction p value

```bash
RES_DIR_I="${RES_DIR}/results-21753/results-by-interaction-pvalue"
cat ${RES_DIR_I}/results-combinedI-1.csv  > ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-1001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-2001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-3001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-4001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-5001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-6001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-7001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-8001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-9001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-10001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-11001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-12001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-13001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-14001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-15001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-16001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-17001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
cat ${RES_DIR_I}/results-combinedI-18001.csv | grep -v 'varname' >> ${RES_DIR_I}/results-combinedI-all.csv
```



4. Sorted list of interaction results for supplementary material

This command takes the first header line, and sorts the remaining lines.

```bash
(head -n1 ${RES_DIR}/results-21753/results-by-interaction-pvalue/results-combinedI-all.csv && tail -n +2 ${RES_DIR}/results-21753/results-by-interaction-pvalue/results-combinedI-all.csv | sort -t, -g -k13) > ${RES_DIR}/results-21753/results-by-interaction-pvalue/results-combinedI-all-sorted.csv
```

5. Generate QQ plot using the interaction P values

```bash
Rscript interaction-qq.r
```
