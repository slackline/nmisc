#' Bland-Altman ggplot2
#'
#' Procduces customisable Bland-Altman Plots using ggplot2
#'
#' Produces Bland-Altman plots of repeated measurements.  It first
#' standardises variables before calculating the mean and difference
#' of measurements for plotting.
#' 
#' @param df Data frame
#' @param x Measurement 1
#' @param y Measurement 2
#' @param ylabel Y-axis label (Difference between)
#' @param xlabel X-axis label (Difference between)
#' @param measurement Description of what has been measured and is being compared
ba_plot <- function(df,
                    x,
                    y,
                    xlabel      = 'Mean',
                    ylabel      = 'Difference',
                    measurement = 'Measurement',
                    ...){
    ## Derive standardised mean and difference
    df <- within(df,{
        ## Standardise
        xstd = (x - mean(x)) / sd(x)
        ystd = (y - mean(y)) / sd(y)
        ba.mean = (xstd + ystd) / 2
        ba.diff = (ystd - xstd)
    })
    ## Generate plot
    ggplot(df, aes(ba.mean, ba.diff)) + geom_point() +
        ggtitle(paste0("Bland-Altman plot of standardised ",
                       measurement,
                       " and ")) +
        xlab(xlabel) + ylab(ylabel) +
        ## Add lines
        geom_hline(yintercept = mean(df$ba.diff)) +
        geom_hline(yintercept = mean(df$ba.diff) + 1.96 * sd(df$ba.diff)) +
        geom_hline(yintercept = mean(df$ba.diff) - 1.96 * sd(df$ba.diff))
}
