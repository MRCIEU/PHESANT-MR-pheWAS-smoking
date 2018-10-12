

1. Combine results into one file

We combine results from the ever, never and full samples, into a single results file.

```bash
Rscript combineResults.r
```

2. Plot top results amongst ever smokers

We plot all results passing the 5% FDR threshold among ever smokers.

Three plots are generated for binary, linear, and ordered categorical results, respectively. 

Each plot shows the ever and never results (beta and confidence interval) side by side.

```bash
matlab -r plotTopEverResults
```


