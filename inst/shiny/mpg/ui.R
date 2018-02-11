## Look at splitting header/sidebar/body as per example at https://goo.gl/HcFGz1
## Header
header <- dashboardHeader(title = h1("Fuel Efficency"))
## Sidebar
side <- dashboardSidebar(
                fileInput("file1", "Choose CSV File",
                          accept = c("text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")),
                checkboxInput("header", "Header", TRUE),
                radioButtons("sep", "Separator",
                             choices = c(Comma = ",",
                                         Semicolon = ";",
                                         Tab = "\t"),
                             selected = ","),
                radioButtons("quote", "Quote",
                             choices = c(None = "",
                                         "Double Quote" = '"',
                                         "Single Quote" = "'"),
                             selected = '"'),
                radioButtons("distance", "Distance",
                             choices = c(Miles = "mpg",
                                         Kilometers = "km"),
                             selected = "mpg"),
                radioButtons("volume", "Volume",
                             choices = c(Litres = "l",
                                         Gallon = "g"),
                             selected = "l"),
                sidebarMenu(
                    menuItem("Price", tabName = "price", icon = icon("dashboard")),
                    menuItem("MPG", tabName = "mpg", icon = icon("dashboard")),
                    menuItem("KPL", tabName = "kpl", icon = icon("dashboard")),
                    menuItem("Mileage", tabName = "mileage", icon = icon("dashboard")),
                    menuItem("KM", tabName = "km", icon = icon("dashboard"))
                )
)
## Body
body <- dashboardBody(
            tabItems(
                tabItem(tabname = "data",
                        h2("Data"),
                        fluidRow(width = 10,
                                 box(tableOutput("data"))
                        )),
                tabItem(tabname = "distance",
                        fluidRow(width = 10,
                                 h2("Distance"),
                                 box(plotOutput("distance"))
                        )),
                tabItem(tabname = "price",
                        h2("Fuel Prices"),
                        fluidRow(width = 10,
                                 box(plotOutput("fuel_prices"))
                        )),
                tabItem(tabname = "mpg",
                        h2("Miles per Gallon"),
                        fluidRow(width = 10,
                                 box(plotOutput("mpg"))
                        )),
                tabItem(tabname = "kpl",
                        h2("Kilometeres per Litre"),
                        fluidRow(width = 10,
                                 box("Hello",
                                     plotOutput("kpl"))
                        ))
                    )
)

ui <- dashboardPage(header,
                    side,
                    body)
