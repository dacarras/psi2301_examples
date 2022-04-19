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
              mutate(serv_b = mean_score(
              s01, s02, s03, s04, s05, s06, s07
              )) %>%
              dplyr::glimpse()

# -----------------------------------------------
# histograma
# -----------------------------------------------

hist(data_terce$serv_b)

# -----------------------------------------------
# dispersiongramas en relacion a resultados
# -----------------------------------------------

data_terce %>%
dplyr::select(mat, len, cie, serv_b) %>%
pairs()

# -----------------------------------------------
# descriptivos
# -----------------------------------------------

data_terce %>%
dplyr::select(serv_b) %>%
summarize(
  mean = mean(serv_b, na.rm = TRUE),
  sd = sd(serv_b, na.rm = TRUE),
  p25 = quantile(serv_b, probs = .25, na.rm = TRUE),
  p50 = quantile(serv_b, probs = .50, na.rm = TRUE),
  p75 = quantile(serv_b, probs = .75, na.rm = TRUE),
  missing = sum(is.na(serv_b)),
  valid   = sum(!is.na(serv_b)),
  n       = n()
) %>%
knitr::kable(., digits = 2)

# -----------------------------------------------
# descriptivos intervalares
# -----------------------------------------------

data_terce %>%
dplyr::select(serv_b) %>%
na.omit() %>%
mutate(serv_c = case_when(
  between(serv_b,  0, .1) ~ '0.0 - 0.1',
  between(serv_b, .1, .2) ~ '0.1 - 0.1',
  between(serv_b, .2, .3) ~ '0.2 - 0.3',
  between(serv_b, .3, .4) ~ '0.3 - 0.4',
  between(serv_b, .4, .5) ~ '0.4 - 0.5',
  between(serv_b, .5, .6) ~ '0.5 - 0.6',
  between(serv_b, .6, .7) ~ '0.6 - 0.7',
  between(serv_b, .7, .8) ~ '0.7 - 0.8',
  between(serv_b, .8, .9) ~ '0.8 - 0.9',
  between(serv_b, .9,  1) ~ '0.9 - 1.0'
  )) %>%
group_by(serv_c) %>%
summarize(
  n       = n()
) %>%
mutate(p = n/sum(n)) %>%
mutate(cumulativo = cumsum(p)) %>%
knitr::kable(., digits = 2)



# -----------------------------------------------
# como guardar a excel
# -----------------------------------------------

tabla_2 <- data_terce %>%
dplyr::select(serv_b) %>%
na.omit() %>%
mutate(serv_c = case_when(
  between(serv_b,  0, .1) ~ '0.0 - 0.1',
  between(serv_b, .1, .2) ~ '0.1 - 0.1',
  between(serv_b, .2, .3) ~ '0.2 - 0.3',
  between(serv_b, .3, .4) ~ '0.3 - 0.4',
  between(serv_b, .4, .5) ~ '0.4 - 0.5',
  between(serv_b, .5, .6) ~ '0.5 - 0.6',
  between(serv_b, .6, .7) ~ '0.6 - 0.7',
  between(serv_b, .7, .8) ~ '0.7 - 0.8',
  between(serv_b, .8, .9) ~ '0.8 - 0.9',
  between(serv_b, .9,  1) ~ '0.9 - 1.0'
  )) %>%
group_by(serv_c) %>%
summarize(
  n       = n()
) %>%
mutate(p = n/sum(n)) %>%
mutate(cumulativo = cumsum(p))


knitr::kable(tabla_2, digits = 2)


tabla_2 %>%
openxlsx::write.xlsx(., 'tabla_2.xlsx', overwrite = TRUE)