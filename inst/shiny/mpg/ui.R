ui <- fluidPage(theme = shinytheme("flatly"),
                ## Header
                dashboardHeader(title = h1("Fuel Efficency")),
                ## Sidebar
                dashboardSidebar(
                    sidebarMenu(
                        ## menuItem("File Upload", tabName = "upload", icon = icon("th")),
                        fileInput("file1", "Choose CSV File",
                                  accept = c("text/csv",
                                             "text/comma-separated-values,text/plain",
                                             ".csv")),
                        checkboxInput("header", "Header", TRUE),
                        # Input: Select separator ----
                        radioButtons("sep", "Separator",
                                     choices = c(Comma = ",",
                                                 Semicolon = ";",
                                                 Tab = "\t"),
                                     selected = ","),
                        # Input: Select quotes ----
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
                        menuItem("Price", tabName = "price", icon = icon("dashboard")),
                        menuItem("MPG", tabName = "mpg", icon = icon("dashboard")),
                        menuItem("KPL", tabName = "kpl", icon = icon("dashboard")),
                        menuItem("Mileage", tabName = "mileage", icon = icon("dashboard")),
                        menuItem("KM", tabName = "km", icon = icon("dashboard"))
                    )
                ),
                ## Body
                dashboardBody(
                    tabItems(
                        tabItem(tabname = "price",
                                fluidRow(
                                    box()
                                )),
                        tabItem(tabname = "mpg",
                                fluidRow(
                                    box()
                                )),
                        tabItem(tabname = "kpl",
                                fluidRow(
                                    box()
                                )),
                        tabItem(tabname = "mileage",
                                fluidRow(
                                    box()
                                )),
                        tabItem(tabname = "km",
                                fluidRow(
                                    box()
                                ))
                    )
                ))
