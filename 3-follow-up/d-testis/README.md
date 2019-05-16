



## make pheno file with 41202


```bash
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'eid'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'x31_'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'x21022_'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'x41202_'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'x20116_'
```


```bash
cut -d',' -f 1,9,7075,10231-10610,6360 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv > ${PROJECT_DATA}/phenotypes/derived/data-testis-followup.csv
```



