# -------------------------------------------------------------------
# abrir datos originales
# -------------------------------------------------------------------

civ_data <- read.csv(
url('https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/civ_data.csv')
)

# reemplazar este valor con su rut
set.seed(123456) 

library(dplyr)
data_tarea_5 <- civ_data %>%
                group_by(cty) %>%
                sample_n(500 , replace = FALSE) %>%
                ungroup() %>%
                dplyr::glimpse()

# Nota: Seleccionaremos el 500 casos por país
# Verificamos que nuestra nueva submuestra tiene 2500 casos

nrow(data_tarea_5)

# -----------------------------------------------
# tabla de contigencia (enfocado en columnas)
# -----------------------------------------------

data_tarea_5 %>%
xtabs(~ edu + civ_level, data = .) %>%
proportions(., 2)

# Nota: columnas suman 1

# -----------------------------------------------
# tabla de contigencia (enfocado en filas)
# -----------------------------------------------

data_tarea_5 %>%
xtabs(~ civ_level + edu, data = .) %>%
proportions(., 1)

# Nota: filas suman 1

# -------------------------------------------------------------------
# evaluar chi cuadrado
# -------------------------------------------------------------------


data_tarea_5 %>%
xtabs(~ civ_level + edu, data = .) %>%
chisq.test()

data_tarea_5 %>%
xtabs(~ edu + civ_level, data = .) %>%
chisq.test()

# Nota: la aplicación de chi cuadrado, es simétrica.
#       esta debe ser aplicada sobre las frecuencias,
#       no sobre las proporciones.