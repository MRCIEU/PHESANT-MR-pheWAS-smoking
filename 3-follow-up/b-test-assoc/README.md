


## Facial aging analysis

```bash
stata -b facialAgingAssocs.do
```


## CSI analysis - strength of genetic IV


Generate bootstrap betas:

```bash
qsub jcsistrength.sh
```


Get CI from bootstraps:

```bash
stata -b csiStrengthCIFromBootstraps.do
```



## CSI analysis - estimating the causal effect

Generate bootstrap betas:

```bash
qsub jcsicausaleffect.sh
```

Then combine boots

```bash
echo "bootn,bootbeta" > $RES_DIR/results-21753/facialaging-followup/csi-causal-estimate-boots.txt
cat $RES_DIR/results-21753/facialaging-followup/csi-causal-estimate-bootsx*.txt >> $RES_DIR/results-21753/facialaging-followup/csi-causal-estimate-boots.txt
```

Get CI from bootstraps:

```bash
stata -b csiCausalEstimateCIFromBootstraps.do
```



### Sensitivity


Generate bootstrap betas:

```bash
qsub jcsicausaleffectsensitivity.sh
```

Then combine boots

```bash
echo "bootn,bootbeta" > $RES_DIR/results-21753/facialaging-followup/csi-causal-estimate-boots-sensitivity.txt
cat $RES_DIR/results-21753/facialaging-followup/csi-causal-estimate-boots-sensitivityx*.txt >> $RES_DIR/results-21753/facialaging-followup/csi-causal-estimate-boots-sensitivity.txt
```

Get CI from bootstraps:

```bash
stata -b csiCausalEstimateCIFromBootstrapsSensitivity.do
```



## Examples of SD change of lifetime smoking

```bash
Rscript examples.R
```
