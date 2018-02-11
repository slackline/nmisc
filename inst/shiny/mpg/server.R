server <- function(input, output, session){
    ## Read the input file
    output$data <- renderTable({
        req(input$file1)
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep    = input$sep,
                       quote  = input$quote,
                       )
        ## Tidy up names
        names(df) <- gsub("Timestamp", "date", names(df))
        names(df) <- gsub("Vehicle", "vehicle", names(df))
        names(df) <- gsub("Timestamp", "date", names(df))
        names(df) <- gsub("Mileage.on.Filling.up", "mileage", names(df))
        names(df) <- gsub("Fuel.Bought..litre", "litre", names(df))
        names(df) <- gsub("Cost....", "cost", names(df))
        names(df) <- gsub("Petrol.Station", "source", names(df))
        ## Derive cost per liter
        df <- df %>%
            mutate(date = mdy_hms(date),
                   pence_litre = litre / (cost * 100))
        return(df)
    })
    ## Plot overall distance travelled by date
    output$distance <- renderPlot({
        ggplot(df, aes(x = date,
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
        ggplot(df, aes(x = date,
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
        ggplot(df, aes(x = date,
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
    output$mpg <- renderPlot({
        ggplot(df, aes(x = date,
                       y = kml)) +
            geom_point(aes(colour = source)) +
            geom_smooth() +
            xlab("Date") +
            ylab("km/Litre") +
            theme_bw() +
            facet_wrap(~vehicle, ncol = 2) +
            scale_colour_discrete(name = "Petrol Station")

    })
}
