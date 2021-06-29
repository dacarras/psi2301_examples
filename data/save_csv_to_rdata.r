
list.files()
b5 <- readr::read_csv('b5.csv')

dplyr::glimpse(b5)

library(dplyr)
r4sda::get_desc(b5) %>%
knitr::kable(., digits = 2)

save(b5, file='b5.RData')


# load from psi2301

devtools::install_github("dacarras/psi2301")
psi2301::b5 %>%
dplyr::glimpse()