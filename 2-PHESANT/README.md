
## 1. Run PHESANT

Run jobs in the `sample-all`, `subsample-ever` and `subsample-never` directories.

## 2. Process results

In the `resultsProcessing` directory, run the following to combine results from multiple blue crystal jobs into a single results file, for the ever, never and whole subsamples, respectively.

```bash
sh resultsProcessingSensitivity-pcs-ever.sh
sh resultsProcessingSensitivity-pcs-never.sh
sh resultsProcessingSensitivity-pcs-all.sh
```


## 3. Plotting results

See `resultsPlots` directory.

## 4. Identify results by interaction P value

See `identifyInteractions` directory.

## 5. Results for supplementary table

Create results listings for supplementary tables and supplementary data file (containing complete list of results)

```bash
Rscript supTables.R
```

