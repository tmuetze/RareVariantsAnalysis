
vcfOr <- read.table("EVS_variant_download_GeneName_HNF4A.vcf", skip=36)
names(vcfOr) <- c("CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO")
vcf<-vcfOr[,1:5]

library(shiny)
library(graphics)
require(rCharts)

shinyServer(function(input, output) {
    output$myChart <- renderChart({
        p1 <- rPlot(REF ~ POS, data=vcf, type = "point", color="ALT",
                    xlab="Positions: 43029918 - 43061485",
                    main="Variations HNF4A (3172) in Chromosom 20",
                    ylab="Frequency")
        p1$addParams(dom = 'myChart')
        return(p1)
    })
})