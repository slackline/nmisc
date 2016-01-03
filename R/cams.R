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
                 cams.df   = cams.df,
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
        cams.df <- gs_read(ss = cams,
                           ws = cam.sheet)
    # Rename
        names(cams.df) <- gsub("_", ".", names(cams.df))
    # Generate unique ID
        cams.df <- mutate(cams.df,
                          manufacturer.model      = paste(manufacturer, model, sep = " "),
                          model.size              = paste(model, size, sep = " "),
                          manufacturer.model.size = paste(manufacturer, model, size, sep = " "))
    }
    results <- list()
    # Plot every cam
    results$all.range <- dplyr::select(cams.df, manufacturer.model, manufacturer.model.size, lower, upper) %>%
                         melt(id.vars = c("manufacturer.model", "manufacturer.model.size"))
    results$all <- ggplot(results$all.range,
                          aes(value,
                              manufacturer.model.size)) +
        geom_line(aes(colour = manufacturer.model)) +
        xlab("Range (mm)") +
        ylab("Cam (Manufacturer / Model / Size)") +
        theme(legend.position = "none")
    # Range covered by a manufacturers model
    results$model.range <- dplyr::select(cams.df, manufacturer.model, lower, upper) %>%
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
    ## results$all.manufacturer <- ggplot(cams.df,
    ##                                    aes(range,
    ##                                        model.size)) +
    ##     geom_line() +
    ##     xlab("Range (mm)") +
    ##     ylab("Cam (Manufacturer / Model)") +
    ##     facet_grid(manufacturer ~.)
    # Strength v Range
    results$range.strength <- ggplot(cams.df,
                                     aes(range,
                                         strength.active.max)) +
        geom_point(aes(colour = factor(manufacturer.model))) +
        geom_smooth(method = smooth, size = 1) + 
        xlab("Range (mm)") + ylab("Max Active Strength (kN)")
    # Strength v Weight
    results$range.weight <- ggplot(cams.df,
                                   aes(range,
                                       weight)) +
        geom_point(aes(colour = factor(manufacturer.model))) +
        geom_smooth(method = smooth, size = 1) + 
        xlab("Range (mm)") + ylab("Max Active Weight (kN)")
    # Return summary data frame by manjfacturer/model
    results$summary.df <- summary.df <- group_by(cams.df,
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
    results$cams.df <- cams.df
    return(results)
}
