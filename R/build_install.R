#' Wrapper to build and install a development package
#' @export
build_install <- function(...){
    build()
    install()
}
