library(dplyr)
library(ggplot2)
library(nmisc)
library(shiny)
library(magrittr)
library(RColorBrewer)
## library(Cairo)

shinyServer(function(input, output){
    ## Subset the data
    ## if(input$to.compare != "All"){
    ##     cams.df <- dplyr::select(cams.df, manufacturer, model) %>% unique() %>% filter(manufacturer %in% manufacturer) 
    ## }
    ## All cams
    output$all <- renderPlot({
        cam.plot <- cams(df           = cams.df,
                         smooth       = 'loess',
                         free.scales  = 'free_y',
                         wrap.col     = 6,
                         text.size    = 16)
        cam.plot$all
    })
    ## By Manufacturer
    output$all.manufacturer<- renderPlot({
        cam.plot <- cams(df          = cams.df,
                         smooth      = 'loess',
                         free.scales = 'free_y',
                         wrap.col    = 6,
                         text.size   = 16)
        cam.plot$all.manufacturer
    })
    ## By Model Range
    output$model.range <- renderPlot({
        cam.plot <- cams(df          = cams.df,
                         smooth      = 'loess',
                         free.scales = 'free_y',
                         wrap.col    = 6,
                         text.size   = 16)
        cam.plot$manufacturer.model
    })
    ## Range v Strength
    output$range.strength <- renderPlot({
        cam.plot <- cams(df              = cams.df,
                         smooth          = 'loess',
                         free.scales     = 'free_y',
                         wrap.col        = 6,
                         text.size       = 16,
                         exclude.outlier = TRUE)
        cam.plot$range.strength
    })
    ## Range v Weight
    output$range.weight <- renderPlot({
        cam.plot <- cams(df          = cams.df,
                         smooth      = 'loess',
                         free.scales = 'free_y',
                         wrap.col    = 6,
                         text.size   = 16)
        cam.plot$range.weight
    })
    ## ## 
    ## output$all <- renderPlot({
    ##     cam.plot <- cams(df      = cams.df,
    ##                      smooth = 'loess',
    ##                      free.scales = 'free_y',
    ##                      wrap.col    = 6,
    ##                      text.size   = 16)
    ##     cam.plot$all.range
    ## })
})
