#' Obtain the systems hostname
#'
#' @title System hostname
#'
#' @description \code{hostname} is a simple wrapper to return the systems hostname.
#'
#' @param shell Logical, whether to query the shell variable \code{$HOSTNAME} to obtain the hostname.
#' @param uname Logical, whether to use \code{uname -a} to obtain the hostname.  This takes precedence over \code{shell = TRUE}.
#'
#' @export
hostname <- function(shell = FALSE,
                     uname = TRUE){
    if(uname == TRUE){
        hostname <- system("uname -n", intern = TRUE)
    }
    else if(shell == TRUE){
        hostname <- system("echo $HOSTNAME", intern = TRUE)
    }
    else{
        print("Error : You must specify either 'uname = TRUE' (default) or 'shell = TRUE'.")
    }
    return(hostname)
}
