# Functional enrichments from: id_file and EggNOG annotation
# change lines in block INPUT (###HERE)
# Eliminate the header and tail with "##"!! (eggnog.tsv)
#install.packages("BiocManager")  # Install BiocManager if not already installed
#BiocManager::install("topGO")   # Install topGO package
  
library(topGO)
library(ggplot2)
library(stringr)
# INPUT (###HERE)
setwd("workdir") # working directory
file_genes <- "file.id"                       # file with identifiers
file_background <- "out.emapper.annotations" # Annotation file from eggnog-mapper
Nodes <- 20 

# Result folder
FOLDER <- "eggnog_enrichment"
if (!dir.exists(FOLDER)){
  dir.create(FOLDER)
}


#Create temp file
data <- read.csv(file_background, sep = "\t", header = TRUE, row.names = NULL)
data[["X.query"]] <- as.character(gsub('_\\d$', '', data[["X.query"]]))
file_temp <- paste0(file_background, "2")
selected_data <- data[, c("X.query", "GOs")]
write.table(selected_data, file = file_temp, sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE)
genes <- read.csv(file_genes, header = FALSE)$V1

# Get background annotation
GOesByID <- readMappings(file = file_temp)
bg_genes <- names(GOesByID)

compared_genes <- factor(as.integer(bg_genes %in% genes))
names(compared_genes) <- bg_genes

# Create topGO object
ONT <- "BP"
GOdata <- new("topGOdata", ontology = ONT, allGenes = compared_genes,
              annot = annFUN.gene2GO, gene2GO = GOesByID)
asd <- unlist(Term(GOTERM))

# Run Fisher test
resultFisher <- runTest(GOdata, algorithm = "classic", statistic = "fisher")

# Create and print table with enrichment result
allRes <- GenTable(GOdata, classicFisher = resultFisher, topNodes = Nodes)
allRes <- allRes[order(allRes$Expected),] # sort the data frame by the expected value "Expected".

# Figure
########
layout(t(1:2), widths=c(8,3))
par(mar=c(4, .5, .7, .7), oma=c(3, 15, 3, 4), las=1)

pvalue <- as.numeric(gsub("<", "", allRes$classicFisher)) # remove '<' symbols
allRes$classicFisher <- pvalue
max_value <- as.integer(max(-log(pvalue)))+1
pv_range <- exp(-seq(max_value, 0, -1))

mylabels <- paste (allRes$GO.ID)
mybreaks <- 10^-(0:30)

p <- ggplot(data = allRes, aes(x=reorder(Term, Significant), y = Significant)) +
  geom_bar(stat = "identity", position = position_dodge2(), color = "black", aes(fill=as.numeric(log(classicFisher))), 
           linewidth = 0.5) +
  coord_flip() + xlab("GO terms") + ylab("Number of genes") + ggtitle(bquote(bold("pratense.id"))) + 
  guides(fill = guide_colourbar(barheight = 25, reverse=T)) + theme_bw() +
  scale_fill_gradientn(name = "p-value", colours = c("firebrick3","lavenderblush1", "royalblue3"), 
                       breaks = log(mybreaks), guide = guide_colourbar(reverse = TRUE), labels = mybreaks) +
  scale_y_continuous(breaks = seq(0, max(allRes$Significant), by = 10)) +
  theme(axis.title.x = element_text(face = "bold", size = 14),  axis.title.y = element_text(face = "bold", size = 14), 
        axis.text.y = element_text(face = "bold", color="black", size = 12), 
        axis.text.x = element_text(color="black", size=10), plot.title = element_text(size = 16, face = "bold")) +
  geom_text(aes(label=mylabels), position=position_dodge2(width = 0.9), hjust= 1, fontface="bold", size = 5)

print(p)

print(allRes)

# Save induced subgraphs for Fisher test
pdf(paste0(FOLDER, "/enrichment_", ONT, ".pdf"), width = 20, height = 10, paper = 'special')
showSigOfNodes(GOdata, score(resultFisher), firstSigNodes = 3, useInfo = 'all')
dev.off()

# Save results
if (exists("allRes") & nrow(allRes) > 4) {
  # Save table and figure 
  write.table(allRes, file = paste0(FOLDER, "/enrichment_", ONT, ".tsv"), quote = F, row.names = F, sep = "\t")
  png(paste0(FOLDER, "/enrichment_", ONT, ".png"), width = 1020, height = 700) 
  print(p)
  dev.off()
}

#List of genes by enriched GO
GOnames <- as.vector(allRes$GO.ID)
allGenes <- genesInTerm(GOdata, GOnames)
significantGenes <- list() 
for(x in 1:Nodes){
  significantGenes[[x]] <- allGenes[[x]][allGenes[[x]] %in% as.vector(genes)]
}
names(significantGenes) <- allRes$Term
significantGenes
new_folder <- (paste0(FOLDER, "/", ONT, "/"))
if (!file.exists(new_folder)) { dir.create(new_folder) }
for(x in 1:Nodes){
  write.table(significantGenes[x], quote = FALSE, sep = "\t", 
              file = paste(new_folder, x, "-", str_replace_all(names(significantGenes)[x], "/", "_"), ".tsv", sep=""),
              col.names = F, row.names = F)
}

