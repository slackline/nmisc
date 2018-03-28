server <- function(input, output, session){
    ## Plotting GPSdata
    ## Raw Leaflet Map
    output$hill_leaflet <- renderLeaflet({
        ## Subset the data based on user specified selection
        dplyr::filter(skye_cullin_gpx, hill == input$hill) %>%
        leaflet() %>%
            addProviderTiles(providers$OpenStreetMap,
                             options = providerTileOptions(noWrap = TRUE)
                             ) %>%
            addCircleMarkers(radius      = 2,
                             color       = "navy",
                             fillOpacity = 0.2,
                             popup       = ~htmlEscape(date_time))
                                 ## paste0("Latitude  : ", ~htmlEscape(lat), "\n",
                                 ##            "Longitude : ", ~htmlEscape(lng), "\n",
                                 ##            "Speed     : ", ~htmlEscape(speed), "\n",
                                 ##            "Bearing   : ", ~htmlEscape(bearing), "\n",
                                 ##            "Height    : ", ~htmlEscape(height), "\n"))
    })
}
