#' A wrapper to Change Directory
#' 
#' @param path  A character string: tilde expansion will be done.
#' @export
cd <- function(path){
    setwd(path)
}
