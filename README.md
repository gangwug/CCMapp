## Introduction about CCMapp

CCMapp is a Shiny app of drawing the heatmap of clock correlation matrix. 

## License
This package is free and open source software, licensed under GPL(>= 2).
 
## Usage
```r
# install 'shiny' package (if 'shiny' is not installed yet)
install.packages("shiny")
# load 'shiny' package
library(shiny)

# the easy way to run this app 
runGitHub("CCMapp", "gangwug")

# Or you can download all files from this page, and place these files into an directory named 'CCMapp'. 
# Then set 'CCMapp' as your working directory (see more introduction about working directory-http://shiny.rstudio.com/tutorial/quiz/). 
# Now you can launch this app in R with the below commands.
runApp("CCMapp")

```
There is an input example data and bench matrix file ('exampleData.csv' and 'benchMatrix.csv') in this folder. 

## For more information about the clock correlation matrix
1. Wu G, Ruben MD, Schmidt RE, Francey LJ, Smith DF, Anafi RC, Hughey JJ, Tasseff R, Sherrill JD, Oblong JE, Mills KJ, Hogenesch JB, Population-level rhythms in human skin with implications for circadian medicine. Proc Natl Acad Sci U S A. 2018, 115(48):12313-12318.
2. Wu G, Ruben MD, Francey LJ, Smith DF, Sherrill JD, Oblong JE, Mills KJ, Hogenesch JB, A population-based gene expression signature of molecular clock phase from a single epidermal sample. Genome Med. 2020. 12(1):73.

## Contact information
wggucas@gmail.com
