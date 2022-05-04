######==========================================================================draw the heatmap of clock correlation matrix
CCMheatmap <- function(inputD, benchD, gorder, mname = "CCM", mnameTextSize = 10, axisTextSize = 10, xaxisTextAngle = 60, 
                       legendWidth = 0.15, legendHeight = 0.3, legendTitle = "rho", legendTitleSize = 10, legendTextSize = 10, textRhoSize = 0)  {
  ###the input data
  colnames(inputD)[1] = "geneSym"
  rownames(inputD) = inputD$geneSym
  ###the reference data
  colnames(benchD)[1] = "geneSym"
  ##this is only for human clock genes; a better/correct way is to use homolog gene list table
  benchD$geneSym = toupper(benchD$geneSym)
  rownames(benchD) = benchD$geneSym
  colnames(benchD)[-1] = toupper(colnames(benchD)[-1])
  ###the overlapped genes
  bothID = intersect(intersect(gorder, inputD$geneSym), benchD$geneSym)
  geneOrderD = data.frame(geneSym = gorder, rankv = 1:length(gorder)) %>% 
    dplyr::filter(geneSym %in% bothID) %>% 
    dplyr::arrange(rankv)
  gorder = geneOrderD$geneSym
  ###the reference correlation matrix
  corA <- as.matrix(benchD[gorder,gorder])
  ###the correlation matrix of the data
  corB <- cor(t(inputD[gorder,-1]), method = "spearman")
  colnames(corB) <- rownames(corB) <- gorder
  ###calculate the similarity between matrix with 'ape' package
  simD <- mantel.test(corA, corB, nperm = 1000)
  ##get the main name
  if (simD$p < 0.001) {
    pva = "p<0.001"
  } else if (simD$p < 0.01) {
    pva = "p<0.01"
  } else if (simD$p < 0.05) {
    pva = "p < 0.05"
  } else if (simD$p >= 0.05) {
    pva = paste0("p=", round(simD$p,2))
  }
  mname = paste0(mname, ", zstat=", round(simD$z.stat, 2), ", ", pva)
  ##prepare the data frame for drawing the heatmap
  corM <- corB[rev(gorder),gorder]
  figD <- corM %>% tbl_df() %>%
    tibble::rownames_to_column('Var1') %>%
    tidyr::gather(Var2, value, -Var1) %>%
    dplyr::mutate( Var1 = factor(Var1, levels=length(gorder):1), Var2 = factor(Var2, levels=rev(gorder)) )
  ##not fill with rho value
  gplot <- ggplot(figD, aes(Var1, Var2)) +
    geom_tile(aes(fill = value)) +
    labs(x="", y="", title = mname, fill = legendTitle) +
    scale_x_discrete(breaks=as.character(length(gorder):1),labels=gorder) +
    scale_y_discrete(breaks=gorder,labels=gorder) +
    scale_fill_gradient2(limits = c(-1, 1), low = "blue", mid="white", high = "red", midpoint=0, space="Lab") +
    theme(axis.line = element_blank(),
          axis.text=element_blank(),
          legend.title = element_text(size = legendTitleSize),
          legend.text = element_text(size = legendTextSize),
          legend.key.width = unit(legendWidth, "inches"), 
          legend.key.height = unit(legendHeight, "inches"),
          legend.margin = margin(t=0.1, r=0.05, b=0.1, l=0.05, unit="inches"), 
          plot.title = element_text(size = mnameTextSize, face = "bold", hjust = 0.5) )
  ##fill rho value
  if (textRhoSize > 0) {
    gplot <- gplot +
      geom_text(aes(label = round(value, 1)), size = textRhoSize)
  }
  ##with label
  if (axisTextSize) {
    gplot <- gplot +
      theme(axis.text.x = element_text(size = axisTextSize, angle=xaxisTextAngle, hjust=1),
            axis.text.y = element_text(size = axisTextSize, hjust=1) )
  }
  return(gplot)
}
