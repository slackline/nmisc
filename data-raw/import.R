## Read in various data sets
ukc_logbook <- read_csv(file = 'csv/slacky_Logbook.csv')
names(ukc_logbook) <- c('route', 'grade', 'style', 'partner', 'notes', 'date', 'crag')
ukc_logbook <- cbind(ukc_logbook,
                     str_locate(ukc_logbook$grade, pattern = ' \\*+')) %>%
               mutate(stars = substring(grade,
                                        start,
                                        end),
                      grade = substring(grade,
                                        1,
                                        start - 1),
                      ## notes = gsub(notes, '', ';'),
                      date  = dmy(date))
head(ukc_logbook)
save(ukc_logbook, '../data/ukc_logbook.RData')
