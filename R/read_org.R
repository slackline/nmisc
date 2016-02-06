#' Read Emacs Org-mode files
#' 
#' @param file  Path of file to be read
#' @export
read_org <- function(file = '',
                     ...){
    ## Read the file
    raw <- readLines(con   = file) %>%
           data.frame()
    names(raw) <- c("raw")
    ## Parse out projects, tasks and times
    raw <- within(raw,{
                  project[grepl('\\*\\* ', raw)] <- raw
                  task[grepl('\\*\\*\\* ', raw)] <- raw
                  time[grepl('CLOCK:', raw)]     <- raw
    })
    ## Return results
    return(raw)
}
