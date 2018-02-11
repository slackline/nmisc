## Look at splitting header/sidebar/body as per example at https://goo.gl/HcFGz1
## Header
header <- dashboardHeader(title = "Fuel Efficency")
## Sidebar
side <- dashboardSidebar(
                fileInput("file1", "Choose CSV File",
                          accept = c("text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")),
                checkboxInput("header", "Header", TRUE),
                ## radioButtons("sep", "Separator",
                ##              choices = c(Comma = ",",
                ##                          Semicolon = ";",
                ##                          Tab = "\t"),
                ##              selected = ","),
                ## radioButtons("quote", "Quote",
                ##              choices = c(None = "",
                ##                          "Double Quote" = '"',
                ##                          "Single Quote" = "'"),
                ##              selected = '"'),
                ## radioButtons("distance", "Distance",
                ##              choices = c(Miles = "mpg",
                ##                          Kilometers = "km"),
                ##              selected = "mpg"),
                ## radioButtons("volume", "Volume",
                ##              choices = c(Litres = "l",
                ##                          Gallon = "g"),
                ##              selected = "l"),
                sidebarMenu(
                    menuItem("About",       tabName = "about",     icon = icon("dashboard")),
                    menuItem("Data",        tabName = "data",     icon = icon("dashboard")),
                    menuItem("Distance",    tabName = "distance", icon = icon("dashboard")),
                    menuItem("Fuel Prices", tabName = "prices",   icon = icon("dashboard")),
                    menuItem("MPG",         tabName = "mpg",      icon = icon("dashboard")),
                    menuItem("KPL",         tabName = "kpl",      icon = icon("dashboard"))
                )
)
## Body
body <- dashboardBody(
            tabItems(
                tabItem(tabName = "about",
                        h2("About"),
                        fluidRow(width = 12,
                                 p("This site plots your fuel efficiency and distance travelled.  Currently it requires a file to be uploaded with a specific format output by a GoogleSheet.  In time this site will be updated to allow you to use the form yourself to collect data and then upload it directly here (I hope).  For now a sample file should have been shared with you to have a go with.")
                        )),
                tabItem(tabName = "data",
                        h2("Data"),
                        fluidRow(width = 12,
                                 box(tableOutput("data"))
                        )),
                tabItem(tabName = "distance",
                        fluidRow(width = 12,
                                 h2("Distance"),
                                 box(plotOutput("distance"))
                        )),
                tabItem(tabName = "prices",
                        h2("Fuel Prices"),
                        fluidRow(width = 12,
                                 box(plotOutput("fuel_prices"))
                        )),
                tabItem(tabName = "mpg",
                        h2("Miles per Gallon"),
                        fluidRow(width = 12,
                                 box(plotOutput("mpg"))
                        )),
                tabItem(tabName = "kpl",
                        h2("Kilometeres per Litre"),
                        fluidRow(width = 12,
                                 box(plotOutput("kpl"))
                        ))
                    )
)

ui <- dashboardPage(header,
                    side,
                    body)
