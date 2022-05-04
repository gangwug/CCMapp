##uploading file
shinyUI(fluidPage(
  titlePanel(h2("Welcome to CCMapp") ),
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(6,
               fileInput('file1', label=h5('Choose data file'),
                         accept=c('text/csv', 
                                  'text/comma-separated-values,text/plain', '.csv')) ),
        column(6,
              fileInput('file2', label=h5('Choose bench file'),
                        accept=c('text/csv', 
                                 'text/comma-separated-values,text/plain', '.csv')) ),
        column(6,
               radioButtons('fstyle', label=h5('File style'),
                            choices=c("csv"='csv', "txt"='txt'),
                            selected='csv', inline=FALSE) )
      ),
     fluidRow(
        column(12,
               textInput("geneOrder", label=h5("The order of clock genes"), value="ARNTL, NPAS2, CLOCK, NFIL3, CRY1, RORC, NR1D1, BHLHE41, NR1D2, DBP, CIART, PER1 , PER3, TEF, HLF, CRY2, PER2") )
     ),
     fluidRow(
        column(6,
               textInput("mname", label=h5("plot title"), value="CCM") ), 
        column(6,
               numericInput("mnameTextSize", label=h5("title size"), value=10) )
     ),
     fluidRow(
       column(6,
              numericInput("axisTextSize", label=h5("axis size"), value=10) ), 
       column(6,
              numericInput("xaxisTextAngle", label=h5("xaxis angle"), value=60) )
     ),
     fluidRow(
       column(6,
              numericInput("legendWidth", label=h5("legend width"), value=0.15) ), 
       column(6,
              numericInput("legendHeight", label=h5("legend height"), value=0.3) )
     ),
     fluidRow(
       column(6,
              textInput("legendTitle", label=h5("legend title"), value="rho") ), 
       column(6,
              numericInput("legendTitleSize", label=h5("legend title size"), value=10) )
     ),
     fluidRow(
       column(6,
              numericInput("legendTextSize", label=h5("legend text size"), value=10) ), 
       column(6,
              numericInput("textRhoSize", label=h5("fill rho size"), value=0) )
     ),
     fluidRow(
       column(6,
              numericInput("figW", label=h5("figure width"), value=6) ), 
       column(6,
              numericInput("figH", label=h5("figure height"), value=5) )
     ),
     br(),
     br(),
     fluidRow(
       column(3,
              actionButton("update", label=h5("Draw")) ),
       column(3,
              downloadButton('download', label='Download' ) )
     )
    ),
    
    mainPanel(
      helpText(h4('Starting point: File format') ),
      helpText(h5('The input file contains expression values of measured circadian marker genes and internal control genes from each test human epidermal sample. At least 6 test samples were required. The file format should be like below:')),
      tableOutput('example'),
      helpText(h4('Step1: Upload') ),
      helpText(h5('Please take a look at the input file selected on the left:') ),
      tableOutput('contents'),
      br(),
      helpText(h4('Step2: Draw') ),
      helpText(h5('If the input file is shown as expected, please set parameters on the left and click Draw button.') ),
      br(),
      helpText(h4('Step3: Download') ),
      helpText(h5('You could download the figure by clicking Download button on the left if the figure looks good.'),
               plotOutput("plot"))
    )
  )
))
