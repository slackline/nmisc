server <- function(input, output, session){
    ## Plotting GPSdata
    ## Raw Leaflet Map
    output$hill_leaflet <- renderLeaflet({
        ## Subset the data based on user specified selection
        if(input$hill != "all"){
            df <- dplyr::filter(skye_cullins_gpx, hill == input$hill)
        }
        ## df %>%
        skye_cullins_gpx %>%
            leaflet() %>%
            addProviderTiles(providers$OpenStreetMap,
                             options = providerTileOptions(noWrap = TRUE)) %>%
            addCircleMarkers(radius      = 2,
                             color       = "navy",
                             fillOpacity = 0.2,
                             popup       = ~htmlEscape(ele))
    })
}
