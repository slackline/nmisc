#' Obtain the systems hostname
#'
#' @title System hostname
#'
#' @param id Your Google ID.
#' @param passwd Your Google Password.
#' @param mpg.doc Name of your Google Sheet holding data.
#' @param mpg.sheet Name of worksheet within Google Sheet holding data.
#' @param zoneinfo Your timezone.
#'
#' @export
hostname <- function(){
    hostname <- system("uname -n", intern = TRUE)
    return(hostname)
}
