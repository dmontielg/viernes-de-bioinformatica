################################################################################################################
### Ejemplo de la documentacion de Bioconductor EnhancedVolcano
### https://bioconductor.org/packages/3.23/bioc/vignettes/EnhancedVolcano/inst/doc/EnhancedVolcano.html
################################################################################################################
# airway es un dataset de RNA-Seq que contiene conteos génicos de células humanas de músculo liso 
# de las vías respiratorias, comparando muestras tratadas con dexametasona frente a controles.

library(DESeq2)          # Análisis de expresión diferencial
library(EnhancedVolcano) # Visualización con volcano plots
library(airway)          # Dataset RNA-Seq de ejemplo
library(magrittr)        # Operador pipe %>%
library(org.Hs.eg.db)    # Anotación de genes humanos

data('airway')
airway$dex %<>% relevel('untrt')
ens <- rownames(airway)

symbols <- mapIds(org.Hs.eg.db, keys = ens, column = c('SYMBOL'), keytype = 'ENSEMBL')
symbols <- symbols[!is.na(symbols)]
symbols <- symbols[match(rownames(airway), names(symbols))]
rownames(airway) <- symbols
keep <- !is.na(rownames(airway))
airway <- airway[keep,]

dds <- DESeqDataSet(airway, design = ~ cell + dex)
dds <- DESeq(dds, betaPrior=FALSE)
res <- results(dds,
  contrast = c('dex','trt','untrt'))
res <- lfcShrink(dds,
  contrast = c('dex','trt','untrt'), res=res, type = 'normal')

EnhancedVolcano(res,
    lab = rownames(res),
    x = 'log2FoldChange',
    y = 'pvalue',
    xlab = bquote(~Log[2]~ 'fold change'),
    pCutoff = 10e-32,
    FCcutoff = 2.0,
    pointSize = 4.0,
    labSize = 6.0,
    colAlpha = 1,
    legendPosition = 'right',
    legendLabSize = 12,
    legendIconSize = 4.0,
    drawConnectors = TRUE,
    widthConnectors = 0.75)
