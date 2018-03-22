# Load required packages
require("dplyr")
require("stringr")
library(corrplot) #https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
library(ggally)

# Read tables of results for all the taxonomical levels
Genera <- read.table(file = "Genera_all.tsv", header = T, row.names = 1, sep = "\t")
Family <- read.table(file = "Family_all.tsv", header = T, row.names = 1, sep = "\t")
Order <- read.table(file = "Order_all.tsv", header = T, row.names = 1, sep = "\t")
Class <- read.table(file = "Class_all.tsv", header = T, row.names = 1, sep = "\t")
Phylum <- read.table(file = "Phylum_all.tsv", header = T, row.names = 1, sep = "\t")

# Function for counting abundance of all samples
mgwascor <- function(TaxLev) {
  # Add colum containing row names for further filtering steps
  TaxLev$Taxa <- row.names(TaxLev)
  # Filter samples to those containing VDP in their names
  TaxLev_VDP <- dplyr::filter(TaxLev, grepl("VDP", TaxLev$Taxa))
  # Add back row names
  rownames(TaxLev_VDP) <- TaxLev_VDP$Taxa
  # Remve Taxa column
  TaxLev_VDP$Taxa <- NULL
  # Convert to matrix and sum columns
  TaxLev_VDP <- as.matrix(TaxLev_VDP)
  TaxLev_Counts <- as.data.frame(colSums(TaxLev_VDP))
  colnames(TaxLev_Counts) <- "Abundance"
  return(TaxLev_Counts)
}

# Count abundances for each taxa level
GeneraCounts <- mgwascor(Genera)
FamilyCounts <- mgwascor(Family)
OrderCounts <- mgwascor(Order)
ClassCounts <- mgwascor(Class)
PhylumCounts <- mgwascor(Phylum)

# Combine all the taxa
GeneraCounts$Type <- "Genera"
FamilyCounts$Type <- "Family"
OrderCounts$Type <- "Order"
ClassCounts$Type <- "Class"
PhylumCounts$Type <- "Phylum"
Counts <- rbind(GeneraCounts,FamilyCounts,OrderCounts,ClassCounts,PhylumCounts)

# Read Loci counts results
LociCounts <- read.table("All_CountTable.txt", header=TRUE, row.names = 1)
LociCounts$Taxa <- rownames(LociCounts)
# Identify if any taxa repeated
CleanNames <- str_sub(LociCounts$Taxa,3,-1)
duplicated <- data.frame(table(CleanNames))[data.frame(table(CleanNames))$Freq > 1,]
##LociCounts <-LociCounts[!(LociCounts$Taxa=="duplicated"),] # Change duplicated to actual values
rownames(LociCounts) <- str_sub(LociCounts$Taxa,3,-1)
LociCounts$Taxa <- NULL

# Merge datasets
AbundanceLociCounts <- transform(merge(Counts,LociCounts,by=0), row.names=Row.names, Row.names=NULL)

# Estimate correlation and plot it using corrplot or ggally
corAbundanceLoci <- cor(AbundanceLociCounts)
corrplot(CorAbundanceLoci, type = "upper")
ggpairs(AbundanceLociCountsCla)
