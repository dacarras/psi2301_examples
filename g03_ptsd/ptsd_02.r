# abrir datos ptsd
data_ptsd <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
	)
)


# Do you sometimes have nightmares or troubling 
#    memories and thoughts about the war?
dplyr::count(data_ptsd, ie18)


library(dplyr)
data_ptsd <- data_ptsd %>%
             mutate(night = case_when(
              ie18 == 1 ~ 1, 
              ie18 == 2 ~ 1, 
              ie18 == 3 ~ 2, 
              ie18 == 4 ~ 3, 
              ie18 == 5 ~ 3,
              TRUE ~ NA_real_
              )) %>%
             dplyr::glimpse()

dplyr::count(data_ptsd, ie18, night)