library(colorspace)
library(dplyr)
library(ggplot2)
library(nmisc)
library(shiny)
library(magrittr)
library(RColorBrewer)
library(XML)
shinyUI(fluidPage(
    titlePanel("Cam oamparison (Camparison)"),
    sidebarPanel(width = 4,
                        p("Welcome, this website provides comparisons of different climbing cams.  Its a work in progress, if you have feedback, comments or ideas please email the",
                          HTML('<a href="mailto:sheffieldboulder.uk@gmail.com?subject=\'Cam site suggestions\'">author</a>'),
                          ".")
                 ),
    sidebarPanel(width = 4,
                 selectInput(inputId  = 'to.compare.manufacturer.model',
                             label    ='Choose cams to compare (By Model) :',
                             choices  = c(unique(cams.df$manufacturer.model)),
                             selected = NULL,
                             multiple = TRUE
                             ),
                 selectInput(inputId  = 'to.compare.range',
                             label    ='Choose cams to compare (By Lower Range) :',
                             choices  = c(unique(cams.df$by.lower.range)),
                             selected = NULL,
                             multiple = FALSE
                             ),
                 selectInput(inputId  = 'to.compare.number',
                             label    ='Choose cams to compare (By Number) :',
                             choices  = c('<1',
                                          '1-2',
                                          '2-3',
                                          '3-4',
                                          '4-5',
                                          '>5'),
                             selected = NULL,
                             multiple = FALSE
                             ),
                 selectInput(inputId  = 'to.compare.manufacturer.model.size',
                             label    ='Choose individual cams to compare :',
                             choices  = c(unique(cams.df$manufacturer.model.size)),
                             ## selected = 'All',
                             multiple = TRUE
                             ),
                 selectInput(inputId  = 'custom.theme',
                             label    ='Choose graph theme :',
                             choices = c('Base'              = 'theme_base',
                                         'Black & White'     = 'theme_bw',
                                         'Calc'              = 'theme_calc',
                                         'Classic'           = 'theme_classic',
                                         'Dark'              = 'theme_dark',
                                         'Economist'         = 'theme_economist',
                                         'Economist (White)' = 'theme_economist_white',
                                         'Excel'             = 'theme_excel',
                                         'Few'               = 'theme_few',
                                         'FiveThirtyEight'   = 'theme_fivethirtyeight',
                                         'Foundation'        = 'theme_foundation',
                                         'gDocs'             = 'theme_gdocs',
                                         'Get'               = 'theme_get',
                                         'Gray'              = 'theme_gray',
                                         'Grey'              = 'theme_grey',
                                         'HC'                = 'theme_hc',
                                         'iGray'             = 'theme_igray',
                                         'Light'             = 'theme_light',
                                         'Linedraw'          = 'theme_linedraw',
                                         'Map'               = 'theme_map',
                                         'Minimal'           = 'theme_minimal',
                                         'Pander'            = 'theme_pander',
                                         'Par'               = 'theme_par',
                                         'Replace'           = 'theme_replace',
                                         'Set'               = 'theme_set',
                                         'Solarized'         = 'theme_solarized',
                                         'Solarized2'        = 'theme_solarized_2',
                                         'Solid'             = 'theme_solid',
                                         'Stata'             = 'theme_stata',
                                         'Tufte'             = 'theme_tufte',
                                         'Update'            = 'theme_update',
                                         'Void'              = 'theme_void',
                                         'WSJ'               = 'theme_wsj'),
                             selected = 'Black & White',
                             )
                 ),
    sidebarPanel(width = 4,
                 selectInput(inputId  = 'free.x.axis',
                             label    = 'Free x-axis :',
                             choices  = c('Yes', 'No'),
                             selected = 'No',
                             multiple = FALSE
                             ),
                 selectInput(inputId  = 'free.y.axis',
                             label    = 'Free y-axis :',
                             choices  = c('Yes', 'No'),
                             selected = 'No',
                             multiple = FALSE
                             )

                 ),
    mainPanel(width = 12,
              column(12,
                     tabsetPanel(tabPanel("Range by Cam",
                                          fluidRow(plotOutput("all.manufacturer",
                                                              width  = 'auto',
                                                              height = '1000px'))
                                          ),
                                 tabPanel("Range by Model",
                                          fluidRow(plotOutput("model.range",
                                                              width  = 'auto',
                                                              height = '1000px'))
                                          ),
                                 tabPanel("Range v Strength",
                                          fluidRow(plotOutput("range.strength",
                                                              width  = 'auto',
                                                              height = '1000px'))
                                          ),
                                 tabPanel("Range v Weight",
                                          fluidRow(plotOutput("range.weight",
                                                              width  = 'auto',
                                                              height = '1000px'))
                                          ),
                                 tabPanel("ToDo",
                                          fluidRow(shiny::p("Here are a list of some of the things I've not done, would like to, or that have been suggested..."),
                                                   shiny::HTML("<ul>
                                                                <li> Align similar size cams in the same plot rather than faceted.
                                                                <li> Colour code cams to manufacturers colours.
                                                                <li> Mix and match individual cams from a manufacturers range.
                                                                <li> Select an individual cam and show all similar cams across manufactureres (possibly restricted to those of interest).
                                                                <li> Make graphs ineractive with ggvis() so moving mouse over points/lines on graphs displays information.
                                                                </ul>"))
                                          )
                                 )
                     )
              )
))
