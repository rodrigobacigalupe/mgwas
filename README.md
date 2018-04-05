# MGWAS Results Processing Cookbook

## Manhattan Plots
### Description
Running these scripts will create a series of Manhattan plots, displaying the significance of each SNP associated with the microbial taxa tested. Plots for all the models run are produced and results can be merged by taxonomical group (eg. Proteobacteria) or by taxonomical level (eg. genera). 

### Methods

#### 1 - Pull out the required information from tables with all the results.
For creating the Manhattan plots, only the SNP names ("SNP"), chromosomes ("CHR"), base pair coordinates ("BP") and p-values ("P") are needed (one p-value for each statistical model used to perform the MGWAS analysis).

```
# In a directory containing all the results for each taxa:
ls > all_taxa.txt
mkdir tables_mhplots && cd tables_mhplots/
bash produce_tables.sh
```

#### 2 - x

#### 3 - y

#### 4 - z


## Phylogenetic tree in iTOL
### Description
Producing a phylogenetic tree of the taxa under study with overlaying piecharts containing information on loci counts (using different methods) and branches coloured according to heritability.

### Methods

#### 1 - Construct phylogenetic tree

#### 2 - Retrieve information on loci counts

#### 3 - Retrieve information on heritability

#### 4 - Upload data into iTOL and export tree

```
python3 mgwas_itol.py all_taxa.tree counts.txt heritability.txt
```
