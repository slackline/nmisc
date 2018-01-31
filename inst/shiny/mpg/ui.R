ui <- fluidPage(theme = shinytheme("flatly"),
                ## Header
                dashboardHeader(title = "Fuel Efficency"),
                ## Sidebar
                dashboardSidebar(
                    sidebarMenu(
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
