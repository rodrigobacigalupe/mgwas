#!bin/bash

#Extract the only required columns out of the MGWAS analysis for Manhattan plots in R. 

#First identify if it taxa has been run using hurdle binary model.
for taxa in `cat all_taxa.txt `; do    head -1 "../"$taxa"/all_models_merged"/chr01.gwas | tr "\t" "\n" | wc -l; done > colcounts.txt
paste all_taxa.txt colcounts.txt | awk '{if ($2==48) print $1}' > taxaHB.txt
paste all_taxa.txt colcounts.txt | awk '{if ($2==33) print $1}' > taxanoHB.txt

#If analysis performed using hurdle binary model, select columns as follows
for taxa in `cat taxaHB.txt`
do
	cat ../$taxa/all_models_merged/*gwas | grep -v "chromosome" | awk '{print $2,$3,$4,$31,$36,$41,$47}' | grep -v "position" | grep -v "chromosome" > $taxa"_summary".tmp
    cat headerHB.txt $taxa"_summary".tmp > $taxa.table 
    rm $taxa"_summary".tmp
done

#If hurdle binary have not been performed, select other columns
for taxa in `cat taxanoHB.txt`
do
	cat ../$taxa/all_models_merged/*gwas | grep -v "chromosome" | awk '{print $1,$2,$3,$22,$27,$32}' | grep -v "position" | grep -v "chromosome" > $taxa"_summary".tmp
    cat headernoHB.txt $taxa"_summary".tmp > $taxa.table 
    rm $taxa"_summary".tmp
done

rm colcounts.txt *tmp
