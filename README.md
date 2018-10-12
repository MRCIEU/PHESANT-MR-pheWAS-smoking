
# MR-pheWAS of smoking heaviness

Proof of principal MR-pheWAS for interactions, using 'smoking heaviness' SNP rs16969968 in gene CHRNA5.

We perform 3 MR-pheWAS in:

1. The whole UK Biobank sample.
2. The subsample of ever-smokers.
3. The subsample of never-smokers.


This repository accompanies the paper:

Millard, LAC, et al. A proof of principle GxE MR-pheWAS: searching for the causal effects of smoking heaviness, in ever versus never smokers, 2017


## Environment details

I use the following language versions: R-3.3.1-ATLAS, State v14, and Matlab-r2015a.

The code uses some environment variables, which needs to be set in your linux environment. I set some permanently (that I'll use across projects), and some temporarily, that are relevant to just this project.

I set the results directory and project data directory temporarily with:

```bash
export RES_DIR="${HOME}/2017-PHESANT-smoking-interaction/results"
export PROJECT_DATA="${HOME}/2017-PHESANT-smoking-interaction/data"
```

I set the IEU shared UKB data directory, and the PHESANT code directory (i.e. my path to the code from the PHESANT git repository) permanently, by adding the following to my ~/.bash_profile file.

```bash
export UKB_DATA="/path/to/ukb/data"
export PHESANT="/path/to/phesant/package"
```


