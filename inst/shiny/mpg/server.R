server <- function(input, output, session){
    ## Read the input file
    df <- reactive({
        req(input$file1)
        df <- read.csv(input$file1$datapath,
                       header = input$header)
        ## Tidy up names
        names(df) <- gsub("Timestamp", "date", names(df))
        names(df) <- gsub("Vehicle", "vehicle", names(df))
        names(df) <- gsub("Timestamp", "date", names(df))
        names(df) <- gsub("Mileage.on.Filling.up", "mileage", names(df))
        names(df) <- gsub("Fuel.Bought..litre.", "litre", names(df))
        names(df) <- gsub("Cost....", "cost", names(df))
        names(df) <- gsub("Petrol.Station", "source", names(df))
        ## Derive metrics
        df <- df %>%
            dplyr::filter(vehicle == "VW T4 Campervan") %>%
            mutate(date        = mdy_hms(date),
                   pence_litre = (cost * 100) / litre,
                   km          = mileage * 1.609344,
                   gallon      = litre * 0.2199692) %>%
            group_by(vehicle) %>%
            arrange(vehicle, date) %>%
            mutate(travelled_miles = mileage - lag(mileage, n = 1),
                   travelled_km    = km - lag(km, n = 1),
                   mpg             = travelled_miles / gallon,
                   kpl             = travelled_km / litre) %>%
            ungroup()
        return(df)
        print("Post Reading")
        names(df) %>% print()
    })
    ## Render table
    output$data <- renderTable({
        return(df())
    })
    ## Plot overall distance travelled by date
    output$distance <- renderPlot({
        names(df()) %>% print()
        dplyr::select(df(), date, mileage, vehicle) %>% print()
        ggplot(df(), aes(x = date,
                         y = mileage,
                         colour = vehicle)) +
            geom_line() +
            xlab("Date") +
            ylab("Mileage") +
            theme_bw() +
            facet_wrap(~vehicle, ncol = 2, scales = "free_y")
    })
    ## Plot Fuel Prices
    output$fuel_prices <- renderPlot({
        ggplot(df(), aes(x = date,
                         y = pence_litre,
                         colour = source)) +
            geom_line() +
            xlab("Date") +
            ylab("Cost (pence/litre)") +
            theme_bw() +
            scale_colour_discrete(name = "Petrol Station")
    })
    ## Fuel efficiency in mpg
    output$mpg <- renderPlot({
        ggplot(df(), aes(x = date,
                         y = mpg)) +
            geom_point(aes(colour = source)) +
            geom_smooth() +
            xlab("Date") +
            ylab("MPG") +
            theme_bw() +
            facet_wrap(~vehicle, ncol = 2) +
            scale_colour_discrete(name = "Petrol Station")

    })
    ## Fuel efficiency in mpg
    output$kpl <- renderPlot({
        ggplot(df(), aes(x = date,
                         y = kpl)) +
            geom_point(aes(colour = source)) +
            geom_smooth() +
            xlab("Date") +
            ylab("km/Litre") +
            theme_bw() +
            facet_wrap(~vehicle, ncol = 2) +
            scale_colour_discrete(name = "Petrol Station")

    })
}
