#--------------------------------------
# abrir datos ptsd
#--------------------------------------

data_ptsd <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
	)
)


#--------------------------------------
# funcion mean score
#--------------------------------------


mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}

# Nota: función para crear puntajes
#       empleando diferentes columnas
#       de una matriz de datos.

#--------------------------------------
# crear variable "disp"
#--------------------------------------

library(dplyr)
data_ptsd <- data_ptsd %>%
             mutate(disp = mean_score(
             	for1, for5, for6
             	))

#--------------------------------------
# evaluar confiabilidad
#--------------------------------------

data_ptsd %>%
dplyr::select(for1, for5, for6) %>%
psych::alpha()

#--------------------------------------
# prueba t
#--------------------------------------

t.test(formula = disp ~ war7,
data = data_ptsd,
alternative = c("two.sided"),
mu = 0,
paired = FALSE,
var.equal = TRUE,
conf.level = 0.95)
