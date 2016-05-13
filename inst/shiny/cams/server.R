library(colorspace)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(nmisc)
library(shiny)
library(magrittr)
library(RColorBrewer)
library(XML)

shinyServer(function(input, output){
    ## Subset the data
    ##
    ## See Lesson 5 and 6
    ##
    ## http://shiny.rstudio.com/tutorial/lesson5/
    ## http://shiny.rstudio.com/tutorial/lesson6/
    ## https://stackoverflow.com/questions/32148144/condition-filter-in-dplyr-based-on-shiny-input
    ##
    dataInput <- reactive({
                           if(!is.null(input$to.compare.manufacturer.model)){
                               filter(cams.df,
                                      manufacturer.model.size %in% input$to.compare.manufacturer.model)
                           }
                           else if(!is.null(input$to.compare.manufacturer.range)){
                               filter(cams.df,
                                      manufacturer.model.size %in% input$to.compare.manufacturer.range)
                           }
                           else if(!is.null(input$to.compare.manufacturer.number)){
                               filter(cams.df,
                                      manufacturer.model.size %in% input$to.compare.manufacturer.number)
                           }
                           else if(!is.null(input$to.compare.manufacturer.model.size)){
                               filter(cams.df,
                                      manufacturer.model.size %in% input$to.compare.manufacturer.model.size)
                           }
                           else(is.null(input$to.compare)){
                               cams.df
                           }
    })
    ## Set scales based on responses
    scales <- reactive({
        if(input$free.x.axis == "Yes" & input$free.y.axis == "No"){
            'free_x'
        }
        else if(input$free.x.axis == "No" & input$free.y.axis == "Yes"){
            'free_y'
        }
        else{
            'free'
        }
    })
    ## All cams
    ## output$all <- renderPlot({
    ##     cam.plot <- cams(df           = dataInput(),
    ##                      smooth       = 'loess',
    ##                      free.scales  = 'free_y',
    ##                      wrap.col     = 6,
    ##                      text.size    = 16)
    ##     cam.plot$all
    ## })
    ## By Manufacturer
    output$all.manufacturer<- renderPlot({
        print(df)
        cam.plot <- cams(df          = dataInput(),
                         smooth      = 'loess',
                         free.scales = scales(),
                         wrap.col    = 6,
                         text.size   = 16)
                         ## theme = input$theme)
        cam.plot$all.manufacturer
    })
    ## By Model Range
    output$model.range <- renderPlot({
        cam.plot <- cams(df          = dataInput(),
                         smooth      = 'loess',
                         free.scales = scales(),
                         wrap.col    = 6,
                         text.size   = 16)
                         ## theme = input$theme)
        cam.plot$manufacturer.model
    })
    ## Range v Strength
    output$range.strength <- renderPlot({
        cam.plot <- cams(df              = dataInput(),
                         smooth          = 'loess',
                         free.scales     = scales(),
                         wrap.col        = 6,
                         text.size       = 16,
                         exclude.outlier = TRUE)
                         ## theme = input$theme)
        cam.plot$range.strength
    })
    ## Range v Weight
    output$range.weight <- renderPlot({
        cam.plot <- cams(df          = dataInput(),
                         smooth      = 'loess',
                         free.scales = scales(),
                         wrap.col    = 6,
                         text.size   = 16)
                         ## theme = input$theme)
        cam.plot$range.weight
    })
    ## ##
    ## output$all <- renderPlot({
    ##     cam.plot <- cams(df      = dataInput(),
    ##                      smooth = 'loess',
    ##                      free.scales = 'free_y',
    ##                      wrap.col    = 6,
    ##                      text.size   = 16)
    ##                      ## theme = input$theme)
    ##     cam.plot$all.range
    ## })
})
