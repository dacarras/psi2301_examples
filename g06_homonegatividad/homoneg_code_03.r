# -----------------------------------------------
# abrir datos
# -----------------------------------------------

data_hom <- read.csv2(
url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/homonegatividad.csv'
	), na = -99
)

# -----------------------------------------------
# mostrar datos
# -----------------------------------------------

library(dplyr)
dplyr::glimpse(data_hom)


# -----------------------------------------------
# mean_score functiion
# -----------------------------------------------

mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}


# -----------------------------------------------
# reverse function
# -----------------------------------------------

reverse <- function (var) {
    var <- labelled::remove_labels(var)
    var <- haven::zap_labels(var)
    max <- max(var, na.rm = TRUE)
    min <- min(var, na.rm = TRUE)
    return(max + min - var)
}

# -----------------------------------------------
# revisar correlaciones de items a puntaje total
# -----------------------------------------------

data_hom %>%
dplyr::select(afe1gay:afe4gay) %>%
psych::alpha()

# -----------------------------------------------
# crear puntajes: afectos positivos hacia gay
# -----------------------------------------------

data_hom <- data_hom %>%
            mutate(affg = mean_score(
                afe1gay, afe2gay, afe3gay, afe4gay
                ))

# -----------------------------------------------
# descriptivo por grupo
# -----------------------------------------------

data_hom %>%
group_by(sexo) %>%
summarize(
mean     = mean(affg, na.rm = TRUE),
sd       = sd(affg, na.rm = TRUE),
n        = sum(!is.na(affg)),
missing  = sum(is.na(affg))
    ) %>%
knitr::kable(., digits = 2)


# -----------------------------------------------
# descriptivo por grupo, con intervalos de confianza
# -----------------------------------------------

library(srvyr)
data_home_srs <- data_hom %>%
                 as_survey_design(ids = 1)

data_home_srs %>%
group_by(sexo) %>%
summarize(
    affg = survey_mean(affg, 
           na.rm = TRUE,
           vartype = "ci"
           )
    ) %>% 
knitr::kable(., digits = 2)
