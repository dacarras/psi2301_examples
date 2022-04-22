# -----------------------------------------------
# cargar datos
# -----------------------------------------------

library(dplyr)
data_terce <- read.csv(
  url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/terce_n.csv'
  )
)

# -----------------------------------------------
# mean_score function
# -----------------------------------------------

mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}


# -----------------------------------------------
# crear puntaje de medias
# -----------------------------------------------

data_terce <- data_terce %>%
              mutate(rela_pa = mean_score(
              re1, re2, re3, re4, re5, re6, re7
              )) %>%
              dplyr::glimpse()


# -----------------------------------------------
# descriptivos
# -----------------------------------------------

data_terce %>%
summarize(
  min = min(rela_pa, na.rm = TRUE),
  max = max(rela_pa, na.rm = TRUE)
  ) %>%
knitr::kable(., digits = 2)


# -----------------------------------------------
# descriptivo de tabla 7
# -----------------------------------------------

library(dplyr)
tabla_7 <- data_terce %>%
  group_by(dep) %>%
  summarize(
    mean = mean(rela_pa, na.rm = TRUE
    )) 

# -----------------------------------------------
# mostrar tabla
# -----------------------------------------------

tabla_7 %>%
knitr::kable()

# -----------------------------------------------
# reclasificar variable
# -----------------------------------------------


data_terce <- data_terce  %>%
              mutate(tipo = case_when(
                between(rela_pa, 1.0 , 1.5) ~ '1.0 - 1.5',
                between(rela_pa, 1.5 , 2.0) ~ '1.5 - 2.0',
                between(rela_pa, 2.0 , 2.5) ~ '2.0 - 2.5',
                between(rela_pa, 2.5 , 3.0) ~ '2.5 - 3.0'
              ))

# -----------------------------------------------
# reclasificar variable
# -----------------------------------------------


library(dplyr)
tabla_8 <- data_terce %>%
  group_by(tipo) %>%
  summarize(
    mean = mean(rela_pa, na.rm = TRUE
    )) 


tabla_8 %>%
knitr::kable()


