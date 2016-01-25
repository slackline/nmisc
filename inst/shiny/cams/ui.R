shinyUI(fluidPage(
    titlePanel("Cam Comparison"),
    sidebarPanel(width = 4,
                        p("Welcome, this website provides comparisons of different climbing cams.  Its a work in progress, if you have any ideas please email the",
                          HTML('<a href="mailto:sheffieldboulder.uk@gmail.com?subject=\'Cam site suggestions\'">author</a>'),
                          ".")
                 ),
    sidebarPanel(width = 4,
                 ## Get a list of cams to compare
                 ## compare.cams <- c("All",
                 ##                   dplyr::select(cams.df, model) %>% unique()
                 ##                   ),
                 selectInput(inputId  = 'to.compare',
                             label    ='Choose cams to compare :',
                             choices  = c("All",
                                          dplyr::select(cams.df, manufacturer.model) %>% unique() %>% arrange(manufacturer.model)
                                          ),
                             selected = 'All',
                             multiple = TRUE
                             )
                 ),
    sidebarPanel(width = 4,
                 ## Get a list of cams to compare
                 ## compare.cams <- c("All",
                 ##                   dplyr::select(cams.df, model) %>% unique()
                 ##                   ),
                 selectInput(inputId  = 'free_x',
                             label    = 'Free x-axis :',
                             choices  = c("Yes", "No"),
                             selected = 'No',
                             multiple = TRUE
                             )
                 ),
    mainPanel(width = 12,
              column(12,
                     tabsetPanel(tabPanel("Range by Cam",
                                          fluidRow(plotOutput("all.manufacturer",
                                                              width  = 'auto',
                                                              height = '2000px'))
                                          ),
                                 tabPanel("Range by Model",
                                          fluidRow(plotOutput("model.range",
                                                              width  = 'auto'))
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
                                          )
                                 )
                     )
              )
))
