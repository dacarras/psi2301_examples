#--------------------------------------
# abrir datos
#--------------------------------------

bdrrss <- readr::read_csv(
url('https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/bdrrss.csv')
)

#--------------------------------------
# crear datos para usuario
#--------------------------------------

# fijar semilla
set.seed(83838383) # reemplazar este valor con su rut

# crear datos específicos para el usuario
data_tarea_3 <- bdrrss[sample(1:nrow(bdrrss), 1000), ]

# dimensiones esperadas (filas = 1000, columnas = 3)
dim(data_tarea_3)

#--------------------------------------
# variables datos
#--------------------------------------

# variables
# sexo
# “Hombre”; “Mujer”.

# comuna
# “Comuna pequeña” y “Comuna grande”.

# ursdia
# “Tiempo de uso de redes sociales al día” (escala continua que varía entre 1 y 5 horas diarias).

#--------------------------------------
# medias con intervalo de confianza (basados en z)
#--------------------------------------

# asumiremos la sd de la muestra, como la de la población
sd_pop <- sd(data_tarea_3$ursdia, na.rm = TRUE)

# tabla de medias e intervalos de confianza calculados con z
library(dplyr)
data_tarea_3 %>%
group_by(comuna) %>%
summarize(
mean = mean(ursdia, na.rm = TRUE),
n  = n(),
sd_pop = sd_pop,
se = sd_pop/sqrt(n),
ll = c(mean - 1.96*se),
ul = c(mean + 1.96*se)
) %>%
knitr::kable(., digits = 2)

# Nota: asumiendo homocestacidad.

# -----------------------------------------------
# homocesdasticity
# -----------------------------------------------

car::leveneTest(
  ursdia ~ as.factor(comuna), 
  data = data_tarea_3, 
  center = 'mean')

# Nota: los resultados de la prueba de Levene, 
#       permiten indicar que asumir homodecadisticidad
#       es adecuado con este modelo.

#--------------------------------------
# medias con intervalo de confianza (basados en z)
#--------------------------------------

# tabla de medias e intervalos de confianza calculados con z
library(dplyr)
data_tarea_3 %>%
group_by(comuna) %>%
summarize(
mean = mean(ursdia, na.rm = TRUE),
n  = n(),
sd = sd(ursdia, na.rm = TRUE),
se = sd/sqrt(n),
ll = c(mean - 1.96*se),
ul = c(mean + 1.96*se)
) %>%
knitr::kable(., digits = 2)

# Nota: asumiendo heterocedasticidad.


#--------------------------------------
# prueba Z para medias
#--------------------------------------

x_vector <- data_tarea_3 %>%
            dplyr::filter(comuna == 'Comuna grande') %>%
            dplyr::select(ursdia) %>%
            dplyr::pull()

y_vector <- data_tarea_3 %>%
            dplyr::filter(comuna == 'Comuna pequeña') %>%
            dplyr::select(ursdia) %>%
            dplyr::pull()

BSDA::z.test(
	x = x_vector,
	sigma.x=sd_pop, 
	y = y_vector, 
	sigma.y=sd_pop,
	mu=0)


#--------------------------------------
# medias con intervalo de confianza (basados en t)
#--------------------------------------

library(dplyr)
library(srvyr)
data_srs <- data_tarea_3 %>% 
            as_survey_design(ids = 1)


data_srs %>%
group_by(comuna) %>%
summarize(
  mean = survey_mean(ursdia, 
  	     na.rm = TRUE, 
  	     vartype = c('ci', 'se')
  	     ),
  n = n()
) %>%
knitr::kable(., digits = 3)
