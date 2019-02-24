
## 1. Run PHESANT to generate processed variables

Run jobs in the `sample-all-save` directory.

## 2. Test associations with derived variables

Run jobs in the `all`, `ever` and `never` sub-directories of the `PHESANT-from-saved` directory.

## 3. Process results

In the `resultsProcessing` directory, run the following to combine results from multiple blue crystal jobs into a single results file, for the ever, never and whole subsamples, respectively.

```bash
sh resultsProcessingSensitivity-pcs-ever.sh
sh resultsProcessingSensitivity-pcs-never.sh
sh resultsProcessingSensitivity-pcs-all.sh
```


## 4. Plotting results

See `resultsPlots` directory.

## 5. Identify results by interaction P value

See `identifyInteractions` directory.

## 6. Results for supplementary table

Create results listings for supplementary tables and supplementary data file (containing complete list of results)

```bash
Rscript supTables.R
```

