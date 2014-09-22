library(shiny)
library(graphics)
require(rCharts)
#reading in the Excel file instead of the vcf
library(xlsx)

shinyUI(
    mainPanel(
        h1("Rare Variant Analysis"),
        h4("Option 1 (Without user input) : The first chart is the same as before except for a change in layout and design."),
        showOutput("myChart1", "polycharts"),
        h4("Option 2 (With user input): As we would like to allow for user input, I added an upload field. Once the user selects a formated vcf file in Excel format (e.g. the one Vikas sent me), the preprocessed vcf file is ploted."),
        fileInput('file1', 'Choose Excel file/Please choose the excel file from https://github.com/tmuetze/RareVariantsAnalysis',
                  accept='.xls'),
        showOutput("myChart2", "polycharts"),
        h4("The second plot is only shown if a file is selected.")
        )
)