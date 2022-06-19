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
# histograma 
#--------------------------------------

hist(data_ptsd$disp, 
ylim = c(0,40),
col  = "darkolivegreen2",
main = "Disposición para perdonar y reconstruir Sierra Leona",
xlab = "Grado de Acuerdo",
ylab = "Frecuencia" ,
breaks = 5
)

#--------------------------------------
# histograma con pipes
#--------------------------------------

data_ptsd %>%
dplyr::select(disp) %>%
dplyr::pull() %>%
hist(., 
ylim = c(0,40),
col  = "darkolivegreen2",
main = "Disposición para perdonar y reconstruir Sierra Leona",
xlab = "Grado de Acuerdo",
ylab = "Frecuencia" ,
breaks = 5
)

# Nota: extrayendo al vector numerico via pipes.
