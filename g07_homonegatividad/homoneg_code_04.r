# abrir datos
data_hom <- read.csv2(
url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/homonegatividad.csv'
	), na = -99
)

# mostrar datos
dplyr::glimpse(data_hom)


# agregar función de puntajes cmoo medias de respuestas
mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}

# crear una variable
data_hom <- data_hom %>%
            mutate(afect_mujeres = mean_score(
            	afe1les,afe2les,afe3les,afe4les))

# crear una tabla descriptiva
data_hom %>%
group_by(sexo) %>%
summarize(
mean = mean(afect_mujeres, na.rm = TRUE)
) %>%
knitr::kable(., digits = 2)