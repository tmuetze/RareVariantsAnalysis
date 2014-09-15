vcfOr <- read.table("EVS_variant_download_GeneName_HNF4A.vcf", skip=36)
names(vcfOr) <- c("CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO")
vcf<-vcfOr[,1:5]

library(shiny)
library(graphics)
require(rCharts)
require(rCharts)
shinyUI(pageWithSidebar(
    headerPanel("Rare Variant Analysis"),
    
    sidebarPanel(
        h4("Chromosome 20, Gene HNF4A"),
        h5("The chart displays the reference base on the y axis and the position on the chromosom on the x axis. The dots are colored by base of the rare variant (two or more bases correspond to an insertion)."),
        h6("Please scroll to the side to see the entire chart.")
        
    ),
    mainPanel(
        showOutput("myChart", "polycharts")
    )
))