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
#' @export
cams <- function(id        = '',
                 passwd    = '',
                 cam.doc   = 'Cam Size Data',
                 cam.sheet = 'Plain List (2015-12-19)',
                 df        = cams.df,
                 smooth    = 'loess',
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
                          levels = c("000", "00", "0", "00/0", "0", "0/1",
                                     "0.1", "0.2", "0.3", "1/3", "1/3 to 3/8",
                                     "3/8", "3/8 to 1/2", "0.4", "0.5", "1/2",
                                     "1/2 to 3/4", "0.6", "0.75", "3/4",
                                     "3/4 to 7/8", "0.8", "4/5", "0.85",
                                     "7/8", "7/8 to 1", "0.95", "1", "1.25",
                                     "1.5", "1.75", "2", "2.5", "3", "3.5",
                                     "4", "5", "6", "7", "8", "9", "Small",
                                     "Medium", "Large"))
    }
    results <- list()
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
        ylab("Cam (Model / Size)") +
        facet_grid(manufacturer.model ~ ., scales = "free_y") +
        theme(legend.position = "none",
              axis.text.y = element_text(size  = 8),
              strip.text.y = element_text(angle = 0))
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
        geom_smooth(method = smooth, size = 1) + 
        xlab("Range (mm)") +
        ylab("Max Active Strength (kN)") +
        theme(legend.position = "none")
    # Strength v Weight
    results$range.weight <- ggplot(df,
                                   aes(range,
                                       weight)) +
        geom_point(aes(colour = factor(manufacturer.model))) +
        geom_smooth(method = smooth, size = 1) + 
        xlab("Range (mm)") +
        ylab("Weight (g)") +
        theme(legend.position = "none")
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
    # Return results
    results$df <- df
    return(results)
}
