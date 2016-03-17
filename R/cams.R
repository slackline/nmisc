#' Read and summarise Climbing Cam data from Google Sheets
#'
#' @title Summarisation of Climbing Cams
#'
#' @param id Google ID.
#' @param passwd Google Password.
#' @param cam.doc Name of Google Sheet holding data (don't change this).
#' @param cam.sheet Name of worksheet within Google Sheet holding data (don't change this).
#' @param cams.df Name of R data frame version of data.
#' @param smooth Smoothing function for plots.
#' @param free.scales Whether to allow the scales of faceted plots to be free.
#' @param wrap.col Number of columns to wrap \code{facet_wrap} by.
#' @param wrap.row Number of rows to wrap \code{facet_wrap} by.
#' @param text.size Size of text in graphs in pts.
#' @param exclude.outlier Excludes the Valley Giant 12 from smoothing.
#' @param theme Theme for plotting, will support ggthemes() and custom themes.
#' @param cam.range Range of cams (in size) to display.
#' @param cam.number Range of cams (by manufacturers number) to display.
#' @param cam.min Minimum range of cam to display.
#' @param cam.max Maximum range of cam to display.
#' @export
cams <- function(id              = '',
                 passwd          = '',
                 compare         = 'all',
                 cam.doc         = 'Cam Size Data',
                 cam.sheet       = 'Plain List (2015-12-19)',
                 df              = cams.df,
                 smooth          = 'loess',
                 free.scales     = 'free_y',
                 wrap.col        = 6,
                 text.size       = 16,
                 exclude.outlier = FALSE,
                 theme           = 'ggplot2',
                 cam.range       = NA,
                 cam.number      = NA,
                 cam.min         = 5.5,
                 cam.max         = 305,
                 ...){
    # Refresh data if id/password specified
    if(id != '' | passwd != ''){
        session.info <- gs_auth(new_user = FALSE,
                                verbose  = FALSE)
        # Identify specified spreadsheet
        cams <- gs_title(cam.doc,
                         verbose = FALSE)
        # Read the data
        df <- gs_read(ss = cams,
                      ws = cam.sheet)
        # Rename
        names(df) <- gsub("_", ".", names(df))
        # Generate unique ID
        df <- mutate(df,
                     manufacturer.model      = paste(manufacturer, model, sep = " "),
                     model.size              = paste(model, size, sep = " "),
                     manufacturer.model.size = paste(manufacturer, model, size, sep = " "))
        # Create factor out of size
        df$size <- factor(df$size,
                          levels = c("000", "00", "00/0", "0/1", "0",
                                     "0.1", "0.2", "0.25", "0.3", "1/3", "3/8",
                                     "0.4", "0.5", "1/2", "0.6", "2/3", "0.65",
                                     "0.7", "0.75", "3/4", "0.8", "4/5", "0.85", "7/8",
                                     "0.95", "1", "1.25", "1.5",
                                     "1.75", "2", "2.5", "3", "3.5",
                                     "4", "5", "6", "7", "8", "9", "12",
                                     "Small", "Medium", "Large", 
                                     "1/3 to 3/8",
                                     "3/8 to 1/2",
                                     "1/2 to 3/4",
                                     "3/4 to 7/8", "3/4 to 1",
                                     "7/8 to 1"))
        # Align cams based on minimum and maximum size
        df$by.lower.range  <- NA
        df$by.upper.range  <- NA
        df$by.number <- NA
        df <- within(df, {
                     by.lower.range[lower < 11]                 <- 1
                     by.lower.range[lower >= 11 & lower < 14]   <- 2
                     by.lower.range[lower >= 14 & lower < 16]   <- 3
                     by.lower.range[lower >= 16 & lower < 19]   <- 4
                     by.lower.range[lower >= 19 & lower < 21]   <- 5
                     by.lower.range[lower >= 21 & lower < 25]   <- 6
                     by.lower.range[lower >= 25 & lower < 31]   <- 7
                     by.lower.range[lower >= 31 & lower < 42]   <- 8
                     by.lower.range[lower >= 42 & lower < 54]   <- 9
                     by.lower.range[lower >= 54 & lower < 188]  <- 10
                     by.lower.range[lower >= 188]               <- 11
                     by.lower.range <- factor(by.lower.range,
                                        levels = c(1:11),
                                        labels = c('< 11mm',
                                                   '11 to < 14mm',
                                                   '14 to < 16mm',
                                                   '16 to < 18mm',
                                                   '19 to < 21mm',
                                                   '21 to < 25mm',
                                                   '25 to < 31mm',
                                                   '31 to < 42mm',
                                                   '42 to < 54mm',
                                                   '54 to < 188mm',
                                                   '>= 188mm'))
                     by.upper.range[upper < 11]                 <- 1
                     by.upper.range[upper >= 11 & upper < 14]   <- 2
                     by.upper.range[upper >= 14 & upper < 16]   <- 3
                     by.upper.range[upper >= 16 & upper < 19]   <- 4
                     by.upper.range[upper >= 19 & upper < 21]   <- 5
                     by.upper.range[upper >= 21 & upper < 25]   <- 6
                     by.upper.range[upper >= 25 & upper < 31]   <- 7
                     by.upper.range[upper >= 31 & upper < 42]   <- 8
                     by.upper.range[upper >= 42 & upper < 54]   <- 9
                     by.upper.range[upper >= 54 & upper < 188]  <- 10
                     by.upper.range[upper >= 188]               <- 11
                     by.upper.range <- factor(by.upper.range,
                                        levels = c(1:11),
                                        labels = c('< 11mm',
                                                   '11 to < 14mm',
                                                   '14 to < 16mm',
                                                   '16 to < 18mm',
                                                   '19 to < 21mm',
                                                   '21 to < 25mm',
                                                   '25 to < 31mm',
                                                   '31 to < 42mm',
                                                   '42 to < 54mm',
                                                   '54 to < 188mm',
                                                   '>= 188mm'))
                     by.number[size = '000']        <- 1
                     by.number[size = '00']         <- 1
                     by.number[size = '00/0']       <- 1
                     by.number[size = '0']          <- 1
                     by.number[size = '0.1']        <- 1
                     by.number[size = '0.2']        <- 1
                     by.number[size = '0.3']        <- 1
                     by.number[size = '1/3']        <- 1
                     by.number[size = '3/8']        <- 1
                     by.number[size = '0.4']        <- 1
                     by.number[size = '0.5']        <- 2
                     by.number[size = '1/2']        <- 2
                     by.number[size = '0.6']        <- 2
                     by.number[size = '2/3']        <- 2
                     by.number[size = '0.65']       <- 2
                     by.number[size = '0.7']        <- 2
                     by.number[size = '3/4']        <- 2
                     by.number[size = '0.8']        <- 2
                     by.number[size = '4/5']        <- 2
                     by.number[size = '0.85']       <- 2
                     by.number[size = '7/8']        <- 2
                     by.number[size = '0.95']       <- 2
                     by.number[size = '1']          <- 3
                     by.number[size = '1.25']       <- 3
                     by.number[size = '1.5']        <- 3
                     by.number[size = '1.75']       <- 3
                     by.number[size = '2']          <- 4
                     by.number[size = '2']          <- 4
                     by.number[size = '2']          <- 4
                     by.number[size = '2.5']        <- 4
                     by.number[size = '3']          <- 4
                     by.number[size = '3.5']        <- 4
                     by.number[size = '4']          <- 4
                     by.number[size = 'Small']      <- 4
                     by.number[size = 'Medium']     <- 4
                     by.number[size = 'Large']      <- 5
                     by.number[size = '5']          <- 5
                     by.number[size = '6']          <- 5
                     by.number[size = '7']          <- 5
                     by.number[size = '8']          <- 5
                     by.number[size = '9']          <- 5
                     by.number[size = '12']         <- 5
                     by.number[size = '1/3 to 3/8'] <- 6
                     by.number[size = '3/8 to 1/2'] <- 6
                     by.number[size = '1/2 to 3/4'] <- 6
                     by.number[size = '3/4 to 7/8'] <- 6
                     by.number <- factor(by.number,
                                         levels = c(1:6),
                                         labels = c('Micro (< 0.5)',
                                                    'Small (0.5 to < 1.0)',
                                                    'Medium (1.0 to < 2.0)',
                                                    'Large (2.0 to < 5.0)',
                                                    'Monster (>= 5.0)',
                                                    'Offsets'))
        })
    }
    results <- list()
    results$df <- df
    # ToDo - Take list compare and filter()
    if(!is.na(cam.range) | !is.na(cam.number) | ! is.na(cam.min) | is.na(cam.max)){
    # ToDo - Filter data based on above four then plot once, should permit filtering on
    #        range/number first and then by min/max
        if(!is.na(cam.range)){
            df <- dplyr::filter(results$df, by.lower.range == cam.range) %>%
                  dplyr::select(manufacturer.model.size, model.size, manufacturer.model, size,  lower, upper, range) %>%
                melt(id.vars = c("manufacturer.model.size", "model.size", "manufacturer.model", "size"))
            head(df) %>% print()
        }
        else if(!is.na(cam.number)){
            df <- dplyr::filter(results$df, by.number == cam.number) %>%
                  dplyr::select(manufacturer.model.size, model.size, manufacturer.model, size, lower, upper, range) %>%
                  roup_by(manufacturer.model.size) %>%
                  melt(id.vars = c("manufacturer.model.size", "model.size", "manufacturer.model", "size"))
            head(df) %>% print()
        }
        if(!is.na(cam.min) | !is.na(cam.max)){
            if(!is.na(cam.min) & is.na(cam.max)){
                cam.max <- filter(results$df, lower > cam.min & lower < (cam.min * 1.5)) %>%
                           max(upper)
            }
            else if(is.na(cam.min) & !is.na(cam.max)){
                cam.max <- filter(results$df, lower > cam.min & lower < (cam.min * 1.5)) %>%
                           max(upper)
            }
            df <- dplyr::filter(results$df, lower > cam.min & upper < cam.max) %>%
                  dplyr::select(manufacturer.model.size, model.size, manufacturer.model, size, lower, upper, range) %>%
                  melt(id.vars = c("manufacturer.model.size", "model.size", "manufacturer.model", "size"))
            head(df) %>% print()
        }
        # Selected range
        ## results$filtered <- ggplot(df,
        ##                            aes(value,
        ##                                manufacturer.model.size)) +
        ##                     geom_line(aes(group = manufacturer.model.size, colour = manufacturer.model.size)) +
        ##                     xlab("Range (mm)") +
        ##                     ylab("Cam (Manufacturer / Model)") +
        ##                     theme(legend.position = "none")
    }
    else{
        names(df) %>% print()
        df <- dplyr::select(results$df, manufacturer.model.size, model.size, manufacturer.model, size, lower, upper) %>%
            melt(id.vars = c("manufacturer.model.size", "model.size", "manufacturer.model", "size"))        
        head(df) %>% print()
    }
    # Return a filtrered data frame
    results$df.filtered <- df
    # Return summary data frame by manjfacturer/model
    results$summary.df <- summary.df <- group_by(results$df,
                                                 manufacturer.model) %>%
                          summarise(n            = n(),
                                    min.size     = min(lower),
                                    max.size     = max(upper),
                                    min.range    = min(range),
                                    max.range    = max(range),
                                    min.weight   = min(weight),
                                    max.weight   = max(weight),
                                    stem         = mean(stem),
                                    axels        = mean(axels),
                                    lobes        = mean(lobes))
    # Plot every cam
    ## all.range <- dplyr::select(df, manufacturer.model, size, manufacturer.model.size, lower, upper) %>%
    ##                      melt(id.vars = c("manufacturer.model", "size", "manufacturer.model.size"))
    results$all <- dplyr::filter(df, variable != 'range') %>%
                   ggplot(aes(value,
                              manufacturer.model.size)) +
        geom_line(aes(colour = manufacturer.model)) +
        xlab("Range (mm)") +
        ylab("Cam (Manufacturer / Model / Size)") +
        theme(legend.position = "none",
              axis.text.y = element_text(size  = 8))
    results$all.manufacturer <- dplyr::filter(df, variable != 'range') %>%
                                ggplot(aes(value,
                                           size)) +
        geom_line(aes(colour = manufacturer.model)) +
        xlab("Range (mm)") +
        ylab("Cam (Size)") +
        theme(legend.position = "none",
              axis.text.y = element_text(size  = 8),
              strip.text.y = element_text(angle = 0))
    ## ToDo - Change the following to just use facet_*() to add specfieid custom scales
    ##        regardless of x or y and have ncol added by facet wrap conditional on it
    ##        being specified
    if(free.scales == 'free_y'){
        results$all.manufacturer <- results$all.manufacturer +
                                    facet_grid(manufacturer.model ~ .,
                                               scales = free.scales)
    }
    else if(free.scales == 'free_x' | free.scales == 'free' ){
        results$all.manufacturer <- results$all.manufacturer +
                                    facet_wrap(facet  = 'manufacturer.model',
                                               scales = free.scales,
                                               ncol   = wrap.col) +
                                    theme(text = element_text(size = text.size))
    }
    # Range covered by a manufacturers model
    model.range <-  ##%>%
#        melt(id.vars = 'manufacturer.model', varnames = 'variable', value.name = 'value') %>%
        ## tail() %>% print()
        ##            dcast(manufacturer.model ~ variable, value.var = 'valueo') %>%
        ## head() %>% print()
        ##                    group_by(manufacturer.model, variable) %>%
        ##            summarise(lower = min(value),
        ##                      upper = max(value)) %>%
        ##            mutate(range <- lower) %>%
        ##            mutate(range[upper > lower] <- upper) %>%
        ## head() %>% print()
        ##            melt(id.vars = 'manufacturer.model') %>%
        ## head() %>% print()

    results$manufacturer.model <- dplyr::filter(df, variable != 'range') %>%
                                  dplyr::select(manufacturer.model, variable, value) %>%
                                  ggplot(aes(value,
                                             manufacturer.model)) +
                                  geom_line(aes(group = manufacturer.model, colour = manufacturer.model)) +
                                  xlab("Range (mm)") +
                                  ylab("Cam (Manufacturer / Model)") +
                                  theme(legend.position = "none") ## +
                                  ## scale_y_reverse()
    # Facet by manufacturer
    ## results$all.manufacturer <- ggplot(df,
    ##                                    aes(range,
    ##                                        model.size)) +
    ##     geom_line() +
    ##     xlab("Range (mm)") +
    ##     ylab("Cam (Manufacturer / Model)") +
    ##     facet_grid(manufacturer ~.)
    # Strength v Range
    results$range.strength <- ggplot(df,
                                     aes(range,
                                         strength.active.max)) +
                              geom_point(aes(colour = factor(manufacturer.model))) +
                              xlab("Range (mm)") +
                              ylab("Max Active Strength (kN)") +
                              theme(legend.position = "none")
    if(exclude.outlier == FALSE){
        results$range.strength = results$range.strength +
                                 geom_smooth(method = smooth, size = 1) 
        
    }
    else if(exclude.outlier == TRUE){
        results$range.strength <- results$range.strength +
                                  geom_smooth(data = filter(df, size != "12") ,
                                          aes(range,
                                              strength.active.max),
                                          method = smooth)
    }
    # Strength v Weight
    results$range.weight <- ggplot(df,
                                   aes(range,
                                       weight)) +
                              geom_point(aes(colour = factor(manufacturer.model))) +
                              geom_smooth(method = smooth, size = 1) + 
                              xlab("Range (mm)") +
                              ylab("Weight (g)") +
                              theme(legend.position = "none")
    if(theme == 'ggplot2'){
        return(results)
    }
    else if(theme == 'tufte'){
        results$all                <- results$all + theme_tufte() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_tufte() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_tufte() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_tufte() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_tufte() + theme(legend.position = "none")
    }
    else if(theme == 'base'){
        results$all                <- results$all + theme_base() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_base() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_base() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_base() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_base() + theme(legend.position = "none")
    }
    else if(theme == 'light'){
        results$all                <- results$all + theme_light() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_light() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_light() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_light() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_light() + theme(legend.position = "none")
    }
    else if(theme == 'manufacturers'){
        results$all                <- results$all + theme_manufacturers() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_manufacturers() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_manufacturers() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_manufacturers() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_manufacturers() + theme(legend.position = "none")
    }
    else if(theme == 'calc'){
        results$all                <- results$all + theme_calc() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_calc() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_calc() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_calc() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_calc() + theme(legend.position = "none")
    }
    else if(theme == 'few'){
        results$all                <- results$all + theme_few() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_few() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_few() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_few() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_few() + theme(legend.position = "none")
    }
    else if(theme == 'fivethirtyeight'){
        results$all                <- results$all + theme_fivethirtyeight() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_fivethirtyeight() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_fivethirtyeight() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_fivethirtyeight() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_fivethirtyeight() + theme(legend.position = "none")
    }
    else if(theme == 'gdocs'){
        results$all                <- results$all + theme_gdocs() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_gdocs() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_gdocs() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_gdocs() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_gdocs() + theme(legend.position = "none")
    }
    else if(theme == 'hc'){
        results$all                <- results$all + theme_hc() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_hc() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_hc() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_hc() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_hc() + theme(legend.position = "none")
    }
    else if(theme == 'par'){
        results$all                <- results$all + theme_par() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_par() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_par() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_par() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_par() + theme(legend.position = "none")
    }
    else if(theme == 'pander'){
        results$all                <- results$all + theme_pander() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_pander() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_pander() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_pander() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_pander() + theme(legend.position = "none")
    }
    else if(theme == 'solarized'){
        results$all                <- results$all + theme_solarized() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_solarized() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_solarized() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_solarized() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_solarized() + theme(legend.position = "none")
    }
    else if(theme == 'stata'){
        results$all                <- results$all + theme_tufte() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_tufte() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_tufte() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_tufte() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_tufte() + theme(legend.position = "none")
    }
    else if(theme == 'wsj'){
        results$all                <- results$all + theme_wsj() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_wsj() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_wsj() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_wsj() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_wsj() + theme(legend.position = "none")
    }
    else if(theme == 'light'){
        results$all                <- results$all + theme_light() + theme(legend.position = "none")
        results$all.manufacturer   <- results$all.manufacturer + theme_light() + theme(legend.position = "none")
        results$manufacturer.model <- results$manufacturer.model + theme_light() + theme(legend.position = "none")
        results$range.strength     <- results$range.strength + theme_light() + theme(legend.position = "none")
        results$range.weight       <- results$range.weight + theme_light() + theme(legend.position = "none")
    }
    ## else if(theme == ''){
    ## }
    return(results)
}
