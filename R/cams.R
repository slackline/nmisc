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
#' @export
cams <- function(id          = '',
                 passwd      = '',
                 compare     = 'all',
                 cam.doc     = 'Cam Size Data',
                 cam.sheet   = 'Plain List (2015-12-19)',
                 df          = cams.df,
                 smooth      = 'loess',
                 free.scales = 'free_y',
                 wrap.col    = 6,
                 text.size   = 16,
                 exclude.outlier = FALSE,
                 theme       = 'ggplot2',
                 ...){
    # Apply theme function
    apply_theme <- function(x = results$all,
                            theme = theme){
        if(theme != 'ggplot2'){
            x <- x + theme_tufte()
        }
        return(x)
        ## else if(theme == 'tufte'){
        ##     else if(theme == 'base'){
        ##     else if(theme == 'light'){
        ##     else if(theme == 'manufacturers'){
        ##     else if(theme == 'calc'){
        ##     else if(theme == 'few'){
        ##     else if(theme == 'fivethirtyeight'){
        ##     else if(theme == 'gdocs'){
        ##     else if(theme == 'hc'){
        ##     else if(theme == 'par'){
        ##     else if(theme == 'pander'){
        ##     else if(theme == 'solarized'){
        ##     else if(theme == 'stata'){
        ##     else if(theme == 'wsj'){
        ##     else if(theme == 'light'){
        ##     else if(theme == ''){
        ##     }
    }
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
        df$by.range  <- ""
        df$by.number <- ""
        df <- within(df, {
                     by.range[lower < 11]                 <- 1
                     by.range[lower >= 11 & lower < 14]   <- 2
                     by.range[lower >= 14 & lower < 16]   <- 3
                     by.range[lower >= 16 & lower < 19]   <- 4
                     by.range[lower >= 19 & lower < 21]   <- 5
                     by.range[lower >= 21 & lower < 25]   <- 6
                     by.range[lower >= 25 & lower < 31]   <- 7
                     by.range[lower >= 31 & lower < 42]   <- 8
                     by.range[lower >= 42 & lower < 54]   <- 9
                     by.range[lower >= 54 & lower < 188]  <- 10
                     by.range[lower >= 188]               <- 11
                     ## by.number[size = '']  <- 1
                     ## by.number[size = '']  <- 2
                     ## by.number[size = '']  <- 3
                     ## by.number[size = '']  <- 4
                     ## by.number[size = '']  <- 5
                     ## by.number[size = '']  <- 6
                     ## by.number[size = '']  <- 7
                     ## by.number[size = '']  <- 8
                     ## by.number[size = '']  <- 9
                     ## by.number[size = '']  <- 10
                     ## by.number[size = '']  <- 11
        })
    }
    # ToDo - Take list compare and filter()
    if(compare != 'all'){
        df <- filter_(df, )
    }
    results <- list()
    results$df <- df
    # Return summary data frame by manjfacturer/model
    results$summary.df <- summary.df <- group_by(df,
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
    results$all.range <- dplyr::select(df, manufacturer.model, size, manufacturer.model.size, lower, upper) %>%
                         melt(id.vars = c("manufacturer.model", "size", "manufacturer.model.size"))
    results$all <- ggplot(results$all.range,
                          aes(value,
                              manufacturer.model.size)) +
        geom_line(aes(colour = manufacturer.model)) +
        xlab("Range (mm)") +
        ylab("Cam (Manufacturer / Model / Size)") +
        theme(legend.position = "none",
              axis.text.y = element_text(size  = 8))
    results$all.manufacturer <- ggplot(results$all.range,
                          aes(value,
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
                                    facet_wrap(facet  = "manufacturer.model",
                                               scales = free.scales,
                                               ncol   = wrap.col) +
                                    theme(text = element_text(size = text.size))
    }
    # Range covered by a manufacturers model
    results$model.range <- dplyr::select(df, manufacturer.model, lower, upper) %>%
                           group_by(manufacturer.model) %>%
                           summarise(lower = min(lower),
                                     upper = max(upper)) %>%
                           melt(id.vars = "manufacturer.model")
    results$manufacturer.model <- ggplot(results$model.range,
                                         aes(value,
                                             manufacturer.model)) +
        geom_line(aes(group = manufacturer.model, colour = manufacturer.model)) +
        xlab("Range (mm)") +
        ylab("Cam (Manufacturer / Model)") +
        theme(legend.position = "none")
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
    return(results)
}
