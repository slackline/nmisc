#' Runs Shiny for Cam comparison
#'
#' @param example The Shiny example you wish to run (omit for a list of possible options).
#' @export
nmisc_example <- function(example = 'cams') {
    # locate all the shiny app examples that exist
    valid_examples <- list.files(system.file("shiny", package = "nmisc"))
    valid_examples_msg <-
        paste0("Valid examples are: '",
               paste(valid_examples, collapse = "', '"),
               "'")
    
    # if an invalid example is given, throw an error
    if (missing(example) || !nzchar(example) ||
        !example %in% valid_examples){
        stop('Please run `nmisc_example()` with a valid example app as an argument.\n',
            valid_examples_msg,
            call. = FALSE)
    }
    # find and launch the app
    app_dir <- system.file("shiny", example, package = "nmisc")
    shiny::runApp(app_dir, display.mode = "normal")
}
