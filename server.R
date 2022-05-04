###load required packages one by one
packageV = c("shiny", "ape", "dplyr", "tidyr", "tibble", "ggplot2") 
for (ii in 1:length(packageV)) {
  is_package_available <- require(packageV[ii], character.only = TRUE)
  if (is_package_available) {
    library(packageV[ii], character.only = TRUE)
  } else {
    install.packages(packageV[ii])
    library(packageV[ii], character.only = TRUE)
  }
}
###load the source code
source("CCMheatmap.R")
###The file size limit is 100MB.
options(shiny.maxRequestSize = 100*1024^2, stringsAsFactors = FALSE)
###load the data
exampleD = readRDS("dataFormat.rds")
###set a flag for 'Run' button
runflag <- 0
###uploading file
shinyServer(function(input, output) {
  ## show the example data
  output$example <- renderTable({
    return( head(exampleD) )
  })
  ##the input data
  dataInput <- reactive({
    ## Change when the "update" button is pressed
    if ( input$update > runflag ) {
      ## input$file1 will be NULL initially. After the user selects and uploads a file, 
      ## it will be a data frame with 'name', 'size', 'type', and 'datapath' columns.
      ## The 'datapath' column will contain the local filenames where the data can be found.
      inFileA <- input$file1
      inFileB <- input$file2
      if (is.null(inFileA) | is.null(inFileB)) {
        return(NULL)
      }
      queryD <-  read.csv(inFileA$datapath, stringsAsFactors = FALSE)
      if ( ncol(queryD) < 2 ) {
        queryD <- read.delim(inFileA$datapath, stringsAsFactors = FALSE)
      }
      benchD <- read.csv(inFileB$datapath, stringsAsFactors = FALSE)
      if ( ncol(benchD) < 2 ) {
        benchD <- read.delim(inFileB$datapath, stringsAsFactors = FALSE)
      }
      runflag <- input$update
      return(list("query" = queryD, "bench" = benchD))
    }  else  {
      return(NULL)
    }
  })
  ## show the input data
  output$contents <- renderTable({
    queryD <-  dataInput()
    return( head(queryD[[1]]) )
  })
  ## the gplot
  plotInput <- reactive({
    if ( input$update > runflag ) {
      dataL = dataInput()
      geneOrder = unlist( strsplit(gsub("\\s+", "", input$geneOrder, perl = TRUE), ",", fixed = TRUE) )
      gplot = CCMheatmap(inputD = dataL[[1]],
                         benchD = dataL[[2]],
                         gorder = geneOrder,
                         mname = input$mname,
                         mnameTextSize = input$mnameTextSize,
                         axisTextSize = input$axisTextSize,
                         xaxisTextAngle = input$xaxisTextAngle,
                         legendWidth = input$legendWidth,
                         legendHeight = input$legendHeight,
                         legendTitle = input$legendTitle,
                         legendTitleSize = input$legendTitleSize,
                         legendTextSize = input$legendTextSize,
                         textRhoSize = input$textRhoSize)
      return(gplot)
    }  else  {
      return(NULL)
    }
  })
  ## show the figure
  output$plot <- renderPlot({
    if ( input$update > runflag ) {
      gplotA = plotInput()
      print(gplotA)
    }  else  {
      return(NULL)
    }
  })
  ## downloading file
  output$download <- downloadHandler(
    filename = function() { 
      paste("CCMplot", '.pdf', sep='') 
    },
    content = function(file) {
      ggplot2::ggsave(file, plot = plotInput(), width = input$figW, height = input$figH, units = "in")
    }
  )
})
