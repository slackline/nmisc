## 2018-03-28 - GPX plots of Skye Walks
dplyr::filter(skye_cullins_gpx, hill == "innpinn") %>%
##    skye_cullins_gpx
        leaflet() %>%
            addProviderTiles(providers$OpenStreetMap,
                             options = providerTileOptions(noWrap = TRUE)
                             ) %>%
            addCircleMarkers(radius      = 2,
                             color       = "navy",
                             fillOpacity = 0.2,
                             ##popup       = paste0("Elevtaion : ", ~htmlEscape(ele)))
                             popup       = ~htmlEscape(ele))


## 2018-02-11 - Developing Shiny application for fuel efficency
df <- read.csv("~/work/R/nmisc/data-raw/fuel_20180211.csv")
names(df) <- gsub("Timestamp", "date", names(df))
names(df) <- gsub("Vehicle", "vehicle", names(df))
names(df) <- gsub("Timestamp", "date", names(df))
names(df) <- gsub("Mileage.on.Filling.up", "mileage", names(df))
names(df) <- gsub("Fuel.Bought\\.\\.litre\\.", "litre", names(df))
names(df) <- gsub("Cost\\.\\.\\.\\.", "cost", names(df))
names(df) <- gsub("Petrol.Station", "source", names(df))
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
             kml             = travelled_km / litre) %>%
      ungroup()


## Distance
ggplot(df, aes(x = date,
               y = mileage,
               colour = vehicle)) +
    geom_line() +
    xlab("Date") +
    ylab("Mileage") +
    theme_bw() +
    scale_colour_discrete(guide = FALSE) +
    facet_wrap(~vehicle, ncol = 2, scales = "free_y")

## Fuel prices
ggplot(df, aes(x = date,
               y = pence_litre,
               colour = source)) +
    geom_line() +
    xlab("Date") +
    ylab("Cost (pence/litre)") +
    theme_bw() +
    scale_colour_discrete(name = "Petrol Station")

## Fuel Efficency mpg
ggplot(df, aes(x = date,
               y = mpg)) +
    geom_point(aes(colour = source)) +
    geom_smooth() +
    xlab("Date") +
    ylab("MPG") +
    theme_bw() +
    facet_wrap(~vehicle, ncol = 2) +
    scale_colour_discrete(name = "Petrol Station")

## Fuel Efficency kml
ggplot(df, aes(x = date,
               y = kml)) +
    geom_point(aes(colour = source)) +
    geom_smooth() +
    xlab("Date") +
    ylab("km/Litre") +
    theme_bw() +
    facet_wrap(~vehicle, ncol = 2) +
    scale_colour_discrete(name = "Petrol Station")

##
## 2018-02-01 - Developing Shiny application for fuel efficency
mpg(id = "nshephard@gmail.com")
