#' Wrapper to build and install a development package
#'
#' @param document Logical, whether to call \code{document()}
#' @param build Logical, whether to call \code{build()}.  By default \code{vignettes = FALSE} and youi should instead build them seperately using the \code{build_vignettes} option.
#' @param build_vignettes Logical, whether to call \code{build_vignettes}.
#' @param install Logical, whether to call \code{install()}
#'
#' @export
build_install <- function(document         = TRUE,
                          build            = TRUE,
                          build_vignettes  = TRUE,
                          install          = TRUE){
    if(document == FALSE & build == FALSE & build_vignettes == FALSE & install == FALSE){
        print("ERROR : You must specify at least one action.")
    }
    if(document == TRUE){
        document()
    }
    if(build == TRUE){
        build(vignettes = FALSE)
    }
    if(build_vignettes == TRUE){
        build_vignettes()
    }
    if(install == TRUE){
        install()
    }
}
