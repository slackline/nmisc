#' Read and summarise Fuel Efficiency Data from Google Sheets
#'
#' @title Summarisation of Fuel Efficiency
#'
#' @param id Your Google ID.
#' @param passwd Your Google Password.
#' @param mpg.doc Name of your Google Sheet holding data.
#' @param mpg.sheet Name of worksheet within Google Sheet holding data.
#' @param zoneinfo Your timezone.
#' @export
mpg <- function(id        = '',
                passwd    = '',
                mpg.doc   = 'Fuel Efficiency (Responses)',
                mpg.sheet = 'Form Responses 1',
                df        = fuel,
                zoneinfo  = 'GMT',
                ...){
    # Refresh data if id/password specified
    if(id != '' | passwd != ''){
        # Get authorisation
        session.info <- gs_auth(new_user = FALSE,
                                verbose  = FALSE)
        # Identify specified spreadsheet
        fuel <- gs_title(mpg.doc, verbose = FALSE)
        # Read the data
        df <- gs_read(ss = fuel,
                           ws = mpg.sheet)
        # Rename and format things
        names(df) <- c("date", "vehicle", "mileage", "litre", "gbp", "station")
        df <- df %>%
            mutate(date    = mdy_hms(date, tz = zoneinfo),
                   vehicle = factor(vehicle,
                                     levels = c("Honda Jazz","VW T4 Campervan")),
                   station = factor(station,
                                    levels = c("Tescos",
                                               "Morrisons",
                                               "Sainsburys",
                                               "Shell",
                                               "BP",
                                               "Texaco",
                                               "Esso",
                                               "Nisa",
                                               "Other")))
        ## df <- within(df, {
        ##                   date <- mdy_hms(date, tz = zoneinfo)
        ##                   vehicle <- factor(vehicle,
        ##                                     levels = c("Honda Jazz","VW T4 Campervan"))
        ##                   station <- factor(station,
        ##                                     levels = c("Tescos",
        ##                                                "Morrisons",
        ##                                                "Sainsburys",
        ##                                                "Shell",
        ##                                                "BP",
        ##                                                "Texaco",
        ##                                                "Esso",
        ##                                                "Nisa",
        ##                                                "Other"))
        ## })
        # Derive miles, km, gallon, mpg, mpl, kpg, kpl, ppl, ppm, ppk
        df <- mutate(df,
                     miles  = mileage - lag(mileage),
                     km     = miles * 1.60934,
                     gallon = litre * 0.219969,
                     price  = gbp / litre,
                     mpg    = miles / gallon,
                     mpl    = miles / litre,
                     kpg    = km / gallon,
                     kpl    = km /litre,
                     ppm    = gbp / miles,
                     ppk    = gbp / km,
                     month  = month(date),
                     year   = year(date))
        # Melt the data to long format for ease of plotting
        df <- melt(df,
                   id.vars = c("vehicle", "date", "station"),
                   measure.vars = c("mileage",
                                    "litre",
                                    "gallon",
                                    "gbp",
                                    "price",
                                    "miles", "mpg", "mpl", "ppm",
                                    "km",    "kpg", "kpl", "ppk"))
    }
    # Short helper function for plotting
    fuel_plot <- function(.df = df,
                          x   = 'date',
                          y   = 'mpg',
                          by  = NA){
        # Set labels
        xlab <- 'Date'
        if(y == 'price')      ylab <- 'Price (GBP)'
        else if(y == 'litre') ylab <- 'Litres'
        else if(y == 'gbp')   ylab <- 'Cost (GBP)'
        else if(y == 'miles') ylab <- 'Miles'
        else if(y == 'mpg')   ylab <- 'Miles per Gallon'
        else if(y == 'mpl')   ylab <- 'Miles per Litre'
        else if(y == 'ppm')   ylab <- 'Price per Mile (GBP)'
        else if(y == 'km')    ylab <- 'Kilometres'
        else if(y == 'kpg')   ylab <- 'Kilometres per Gallon'
        else if(y == 'kpl')   ylab <- 'Kilometres per Litre'
        else if(y == 'ppk')   ylab <- 'Price per Kilometre (GBP)'
        # Filter the data
        .df <- dplyr::filter(.df, variable == y)
        plot <- ggplot(.df, aes(date, value)) + geom_smooth() +
            xlab(xlab) + ylab(ylab)
        if(!is.na(by)){
            plot <- plot + aes_(fill = by)
        }
        return(plot)
    }
    # Generate graphs and save to list for returning
    results <- list()
    results$df        <- df
    results$mean.mpg_ <- df %>% mean(mpg, na.rm = TRUE)
    results$sd.mpg    <- df %>% sd(kpg, na.rm = FALSE)
    results$mean.kpg  <- df %>% mean(kpg, na.rm = TRUE)
    results$sd.kpg    <- df %>% sd(kpg, na.rm = FALSE)
    results$mean.kpl  <- df %>% mean(kpl, na.rm = TRUE)
    results$sd.kpl    <- df %>% sd(kpl, na.rm = FALSE)
    ## Plot things
    results$price     <- fuel_plot(y = 'price')
    results$price     <- fuel_plot(y = 'price', by = 'station')
    results$litre     <- fuel_plot(y = 'litre')
    results$gbp       <- fuel_plot(y = 'gbp')
    results$miles     <- fuel_plot(y = 'miles')
    results$mpg       <- fuel_plot(y = 'mpg')
    results$mpl       <- fuel_plot(y = 'mpl')
    results$ppm       <- fuel_plot(y = 'ppm')
    results$km        <- fuel_plot(y = 'km')
    results$kpg       <- fuel_plot(y = 'kpg')
    results$kpl       <- fuel_plot(y = 'kpl')
    results$ppk       <- fuel_plot(y = 'ppk')
    # Plot Stations
    results$station.df <- dplyr::select(df, station, date) %>% unique()
    results$station <- ggplot(results$station.df, aes(station, fill = station)) + geom_bar() +
                       xlab("Petrol Station") + ylab("N") + guides(fill = FALSE)
    return(results)
}
