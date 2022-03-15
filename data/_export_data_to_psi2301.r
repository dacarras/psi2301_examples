



iccs_09_lat <- readRDS('iccs_2009_stu_lat.rds')
save(iccs_09_lat, file='iccs_09_lat.RData')



smoking <- haven::read_dta('smoking.dta')
save(smoking, file='smoking.RData')