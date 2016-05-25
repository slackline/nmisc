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
                               if(input$to.compare.manufacturer.number == 'Offsets'){
                                   filter(cams.df,
                                          manufacturer.model.size %in% c('00/0', '0/1', '1/2 to 3/4', '1/2', '1/3', '1/3 to 3/8', '2/3', '3/4 to 1', '3/4 to 7/8', '3/4', '3/8', '3/8 to 1/2', '4/5'))
                               }
                               else if(input$to.compare.manufacturer.number == '<1'){
                               filter(cams.df,
                                      manufacturer.model.size %in% c('0', '0.1', '0.2', '0.25', '0.3', '0.4', '0.5', '0.6', '0.65', '0.7', '0.75', '0.8', '0.85', '0.95', '00', '000', '1'))
                               }
                               else if(input$to.compare.manufacturer.number == '1-2'){
                               filter(cams.df,
                                      manufacturer.model.size %in% c('1', '1.25', '1.5', '1.75', '1.80', '12', '2', 'Small'))
                               }
                               else if(input$to.compare.manufacturer.number == '2-3'){
                               filter(cams.df,
                                      manufacturer.model.size %in% c('2', '2.5', '2/3', '3'))
                               }
                               else if(input$to.compare.manufacturer.number == '3-4'){
                               filter(cams.df,
                                      manufacturer.model.size %in% c('3', '3.5', '4'))
                               }
                               else if(input$to.compare.manufacturer.number == '4-5'){
                               filter(cams.df,
                                      manufacturer.model.size %in% c('4', '5'))
                               }
                               else if(input$to.compare.manufacturer.number == '>5'){
                               filter(cams.df,
                                      manufacturer.model.size %in% c('6', '7', '7/8', '7/8', 'to', '1', '8', '9'))
                               }
                           }
                           else if(!is.null(input$to.compare.manufacturer.model.size)){
                               filter(cams.df,
                                      manufacturer.model.size %in% input$to.compare.manufacturer.model.size)
                           }
##                           else if(is.null(input$to.compare)){
                           else{
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
                         theme = input$theme)
        cam.plot$all.manufacturer
    })
    ## By Model Range
    output$model.range <- renderPlot({
        cam.plot <- cams(df          = dataInput(),
                         smooth      = 'loess',
                         free.scales = scales(),
                         wrap.col    = 6,
                         text.size   = 16)
                         theme = input$theme)
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
                         theme = input$theme)
        cam.plot$range.strength
    })
    ## Range v Weight
    output$range.weight <- renderPlot({
        cam.plot <- cams(df          = dataInput(),
                         smooth      = 'loess',
                         free.scales = scales(),
                         wrap.col    = 6,
                         text.size   = 16)
                         theme = input$theme)
        cam.plot$range.weight
    })
    ## ##
    ## output$all <- renderPlot({
    ##     cam.plot <- cams(df      = dataInput(),
    ##                      smooth = 'loess',
    ##                      free.scales = 'free_y',
    ##                      wrap.col    = 6,
    ##                      text.size   = 16)
    ##                      theme = input$theme)
    ##     cam.plot$all.range
    ## })
})
