# gmtutils
perl scripts for gmt file manipulations



R package to pipeline limma analysis for transcriptome between two samples groups


### gmt2table.pl
convert gmt file in table with genesetID, description, and genes columns


```
perl gmt2table.pl --input mitocarta3.gmt --output reversetable.csv
```

### table2gmt.pl
convert table with genesetID, description, and genes columns in gmt file

```
perl table2gmt.pl --input reversetable.csv --output new_mito3.gmt
```
