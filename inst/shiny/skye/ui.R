## Define Title
title <- titlePanel("Walks on The Black Cullins")
## Define Sidebar Panel
side <- sidebarPanel(width = 2,
    selectInput(inputId  = "hill",
                label    = "Hill",
                selected = "All",
                choices  = c("All"                        = "all",
                             "Ambasteir"                  =  "ambasteir",
                             "Bruchna Frithe"             = "bruachnafrithe",
                             "The Innaccessible Pinnacle" = "innpinn",
                             "Sgurr Mihc Choinnich"       = "sgurr-mhic-choinnich",
                             "Sgurr Aghredaidh"           = "sgurraghreadaidh",
                             "Scgurr Alasdair"            = "sgurralasdair",
                             "Sgurr Nan Eag"              = "sgurrnaneag",
                             "Scurr Nan Gillean"          = "sgurrnangillean",
                             "Sgurr Nastri"               = "sgurrnastri")
                )
)
## Define mainPanel
main <- mainPanel(
    fluidRow(width = 2,
             h2("")## ,
             ## box(width = 12,
             ##     leafletOutput("hill_leaflet")
             ##     )
             )
)

## Pass title, side and main to ui as a Fluid Page
ui <- fluidPage(title,
                side,
                main)
