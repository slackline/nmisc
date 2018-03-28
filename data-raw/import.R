## Read in various data sets
ukc_logbook <- read_csv(file = 'csv/slacky_Logbook.csv')
names(ukc_logbook) <- c('route', 'grade', 'style', 'partner', 'notes', 'date', 'crag')
ukc_logbook <- cbind(ukc_logbook,
                     str_locate(ukc_logbook$grade, pattern = ' \\*+')) %>%
               mutate(stars  = substring(grade,
                                         start,
                                         end),
                      grade_ = substring(grade,
                                         1,
                                         start - 1),
                      grade_ = gsub(' $', '', grade_),
                      ## If route does not have any stars the grade
                      ## needs replacing
                      grade_ = ifelse(!is.na(grade_),
                                      yes = grade_,
                                      no  = grade),
                      ## A few grades need manually sorting
                      grade_ = ifelse(grade_ == '1',
                                      yes = 'M',
                                      no  = grade_),
                      grade_ = ifelse(grade_ == '6c+ 2',
                                      yes = '6c+',
                                      no  = grade_),
                      ## grade  = factor(grade_,
                      ##                 levels = c('M', 'D', 'HD',
                      ##                            'VD', 'S,)),
                      ## ToDo - Determine the type of climb based on the grade
                      ##
                      ##        Trad
                      ##        Bouldering
                      ##        Sport
                      ##        Multi-pitch?
                      ##        Winter
                      ##
                      ## type   = case_when(grade == )
                      ## ToDo - Substitute '\n' for ';'
                      ## notes = gsub(notes, '', ';'),
                      date   = dmy(date)) ## %>%
                ## dplyr::select(-grade_)
save(ukc_logbook, file = '../data/ukc_logbook.RData')

head(ukc_logbook)
dplyr::filter(ukc_logbook, route == 'Angle Rib') %>%
    dplyr::select(route, grade, grade_, date)

dplyr::filter(ukc_logbook, grade_ == '6c+ 2') %>%
    dplyr::select(route, grade, grade_, date)

## Read in GPX files and append
t <- 1
files <- list.files(path = "skye/gpx/", pattern = ".gpx")
for(file in files){
    hill <- gsub("\\.gpx", "", file)
    read_file <- paste0("skye/gpx/", file)
    if(t == 1){
        skye_cullins_gpx <- readGPS(i = "gpx", f = read_file)
        if(ncol(skye_cullins_gpx) == 28){
            skye_cullins_gpx <- skye_cullins_gpx %>%
                        dplyr::select(-V3, -V5)
            names(skye_cullins_gpx) <- c(paste0("V", seq(1:26)))
        }
        skye_cullins_gpx$hill <- hill
    }
    else{
        temp <- readGPS(i = "gpx", f = read_file)
        if(ncol(temp) == 28){
            temp <- temp %>%
                    dplyr::select(-V3, -V5)
            names(temp) <- c(paste0("V", seq(1:26)))
        }
        temp$hill <-  hill
        skye_cullins_gpx <- rbind(skye_cullins_gpx,
                          temp)
    }
    t <- t + 1
}
skye_cullins_gpx <- skye_cullins_gpx %>%
            dplyr::select(V5, V6, V16, hill)
names(skye_cullins_gpx) <- c("lat", "lon", "ele", "hill")
save(skye_cullins_gpx,
     file = "../data/skye_cullins_gpx.Rda")
