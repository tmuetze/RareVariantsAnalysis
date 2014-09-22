library(shiny) #required for web interface/design
#library(graphics)
require(rCharts) #required for creating hovering (over points)
library(xlsx) #required for loading Excel files

#reading in the Excel file instead of the .vcf file
xl <- read.xlsx2("HNF4A_coding_table2.xls", 1)
formatEditedVcf = function(excelFile){
    ### converts a preprocessed vcf Excel file into the format for plotting
    #convert frequency to a numeric fraction for both cases and controls
    excelFile$frequency_controls <- sapply(strsplit(as.character(excelFile$frequency_controls), split = "/"),
                                           function(x) as.numeric(x[1]) / as.numeric(x[2]))
    excelFile$frequency_cases <- sapply(strsplit(as.character(excelFile$frequency_cases), split = "/"),
                                        function(x) as.numeric(x[1]) / as.numeric(x[2]))
    #add another column for the log10 values for the frequencies, a small error term
    #is added so that 0 frequencies (aka -Inf Log frequencies) don't distort the graph
    excelFile$frequency_controlsLog <- log10(excelFile$frequency_controls+0.00001)
    excelFile$frequency_casesLog <- log10(excelFile$frequency_cases+0.000001)
    #returns the formated excel file
    return(excelFile)
}
xl <- formatEditedVcf(xl)


#server-end of shiny app
shinyServer(function(input, output) {
    datasetInput <- reactive({
        ####reads in uploaded preprocessed Excel files and formates them
        inFile <- input$file1
        
        if (is.null(inFile)){
            return(NULL)
        }else{
            library(xlsx)
            xl2 <- read.xlsx2(file=inFile$datapath, sheetIndex = 1)
        }
        formatEditedVcf2 = function(excelFile){
            ### converts a preprocessed vcf Excel file into the format for plotting
            #convert frequency to a numeric fraction for both cases and controls
            excelFile$frequency_controls <- sapply(strsplit(as.character(excelFile$frequency_controls), split = "/"),
                                                   function(x) as.numeric(x[1]) / as.numeric(x[2]))
            excelFile$frequency_cases <- sapply(strsplit(as.character(excelFile$frequency_cases), split = "/"),
                                                function(x) as.numeric(x[1]) / as.numeric(x[2]))
            #add another column for the log10 values for the frequencies, a small error term
            #is added so that 0 frequencies (aka -Inf Log frequencies) don't distort the graph
            excelFile$frequency_controlsLog <- log10(excelFile$frequency_controls+0.00001)
            excelFile$frequency_casesLog <- log10(excelFile$frequency_cases+0.000001)
            #returns the formated excel file
            return(excelFile)
        }
        xl2 <- formatEditedVcf2(xl2)
    })
    output$myChart1 <- renderChart({
        #xl <- datasetInput()
        #plot chart showing allele frequency by coding position, colored by functional impact
        rp <- rPlot(frequency_controlsLog ~ coding_position, data=xl, size = list(const = 2),
                    type = "point", color="functional_impact",
                    useInteractiveGuideline=TRUE,
                    tooltip = "#! function(item){return 'Log Frequency (controls): ' + item.frequency_controlsLog + '; Coding Position: ' + item.coding_position + '; Functional impact: ' + item.functional_impact +'; Frequency (cases): '+item.frequency_cases} !#")
                    #tooltip="function(item){return item.frequency_controlsLog}") # +'\n' + item.coding_position + '\n' + item.functional_impac}")
        rp$addParams(width = 1000, height = 300, dom = 'myChart1',
                     title = "Rare Variants in gene HNF4A (3172) on Chromosom 20")
        rp$guides(
            x = list(title = 'Transcript position',
                     max = as.numeric(as.character(tail(xl$coding_position, n = 1)))+30,
                     min = as.numeric(as.character(head(xl$coding_position, n = 1)))-30
                     #ticks = list(formatter = "#!function(d){return Number(d).toPrecision(0.01)}!#")
                     #ticks= "#!function(d) {return d3.format('0,.0')(d)}!#"
                     ),
            #labels = pretty(xl$coding_position)
            y = list(title = 'Allele log10 frequency',
                     max = 0,
                     min = -6)
            )
        rp
        
        return(rp)
    })
    output$myChart2 <- renderChart({
        xl <- datasetInput()
        #plot chart showing allele frequency by coding position, colored by functional impact
        rp <- rPlot(frequency_controlsLog ~ coding_position, data=xl, size = list(const = 2),
                    type = "point", color="functional_impact",
                    useInteractiveGuideline=TRUE,
                    tooltip = "#! function(item){return 'Log Frequency (controls): ' + item.frequency_controlsLog + '; Coding Position: ' + item.coding_position + '; Functional impact: ' + item.functional_impact +'; Frequency (cases): '+item.frequency_cases} !#")
        #tooltip="function(item){return item.frequency_controlsLog}") # +'\n' + item.coding_position + '\n' + item.functional_impac}")
        rp$addParams(width = 1000, height = 300, dom = 'myChart2',
                     title = "Rare Variants in gene HNF4A (3172) on Chromosom 20")
        rp$guides(
            x = list(title = 'Transcript position',
                     max = as.numeric(as.character(tail(xl$coding_position, n = 1)))+30,
                     min = as.numeric(as.character(head(xl$coding_position, n = 1)))-30
                     #ticks = list(formatter = "#!function(d){return Number(d).toPrecision(0.01)}!#")
                     #ticks= "#!function(d) {return d3.format('0,.0')(d)}!#"
            ),
            #labels = pretty(xl$coding_position)
            y = list(title = 'Allele log10 frequency',
                     max = 0,
                     min = -6)
        )
        rp
        
        return(rp)
    })
    output$contents <- renderTable({
        ### CURRENTLY NOT USED
        
        # input$file1 will be NULL initially. After the user selects and uploads a 
        # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
        # columns. The 'datapath' column will contain the local filenames where the 
        # data can be found.
        inFile <- input$file1
    
        if (is.null(inFile)){
            return(NULL)
        }else{
            library(xlsx)
            xl <- read.xlsx2(file=inFile$datapath, sheetIndex = 1)
        }
        
    })
})