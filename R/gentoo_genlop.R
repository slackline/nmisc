#' Read genlop from system
#'
#' Reads and summarises Gentoo genlop output
#'
#' Gentoo's system application for analysing logs, genlop, is called.
#' The output is read in and summaries of emerge times and packages
#' are made.
#'
#' Optionally the user can specify a dataframe of the systems details
#' at given times (e.g. CPU, RAM) to augment the data with.  The gcc version
#' is derived internally from the emerges themselves.
#'
#' @param profile
#'
#' @export
gentoo_genlop <- function(profile = data.frame(),
                          ...){
    raw <- system('genlop -ln', intern = TRUE) %>%
           ## ToDo...
           ## read.table(sep = '>>>') %>%
           as.data.frame() %>%
           head(n = -1) %>% tail(n = -3) ## Remove header/footer
    names(raw) <- 'V1'
    ## Tidy
    clean <- mutate(raw,
                    date    = sub('^(.*)(>>> )(.*)$', '\\1', V1) %>%
                              trimws() %>%
                              substring(first = 5),
                    year    = substring(date, first = 17),
                    month   = substring(date, first = 1, last = 3),
                    day     = substring(date, first = 5, last = 6),
                    time    = substring(date, first = 8, last = 15),
                    date    = paste(year,
                                     month,
                                     day,
                                     sep = '-'),
                    date    = paste(date, time, sep = ' ') %>%
                               ymd_hms(),
                    package = sub('^(.*)(>>> )(.*)$', '\\3', V1) %>%
                              trimws(),
                    install = date - lag(date, 1)
                    ) %>%
              dplyr::select(package, date, install)
}
