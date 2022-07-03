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
# inversion de items
# -----------------------------------------------

# ----------------------
# funcion
# ----------------------

recode_likert_4 <- function(x){
dplyr::case_when(
    x == 1 ~ 4, # Muy de Acuerdo
    x == 2 ~ 3, # De Acuerdo
    x == 3 ~ 2, # En Desacuerdo
    x == 4 ~ 1  # Muy en Desacuerdo
    )
}


mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}

# ----------------------
# recodificacion
# ----------------------

data_model <- data_tarea_5 %>%
              # recodifcar items (mayor valor, mayor acuerdo)
              mutate(i1 = recode_likert_4(ge1)) %>%
              mutate(i2 = recode_likert_4(ge2)) %>%
              mutate(i3 = recode_likert_4(ge3)) %>%
              mutate(i4 = recode_likert_4(ge4)) %>%
              mutate(i5 = recode_likert_4(ge5)) %>%
              mutate(i6 = recode_likert_4(ge6)) %>%
              # recodificar items de machismo
              mutate(i4r = recode_likert_4(i4)) %>%
              mutate(i5r = recode_likert_4(i5)) %>%
              mutate(i6r = recode_likert_4(i6)) %>%
              # crear puntaje promedio
              mutate(gen = mean_score(i1, i2, i3, i4r, i5r, i6r)) %>%
              dplyr::glimpse()

# -----------------------------------------------
# corelacion
# -----------------------------------------------

with(data_model, cor.test(gen, ses))

