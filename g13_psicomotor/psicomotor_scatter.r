

# -----------------------------------------------
# abrir datos
# -----------------------------------------------

datos_psicomotor <- read.csv(
	url('https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/desarollo_psicomotor.csv'
		))

# -----------------------------------------------
# preparar datos
# -----------------------------------------------


library(dplyr)
datos_psicomotor <- datos_psicomotor %>%
                    rename_all(tolower) 


# -----------------------------------------------
# reverse
# -----------------------------------------------

reverse <- function (var)  {
    var <- labelled::remove_labels(var)
    var <- haven::zap_labels(var)
    max <- max(var, na.rm = TRUE)
    min <- min(var, na.rm = TRUE)
    return(max + min - var)
}

# -----------------------------------------------
# mean_score
# -----------------------------------------------

mean_score <- function (..., na.rm = TRUE)  {
    rowMeans(cbind(...), na.rm = na.rm)
}

# -----------------------------------------------
# z score
# -----------------------------------------------

z_score <- function (x)  {
    return(as.numeric(scale(x, center = TRUE, scale = TRUE)))
}


# -----------------------------------------------
# invertir items
# -----------------------------------------------

datos_psicomotor <- datos_psicomotor %>%
                   mutate(a8mfin2_raw = a8mfin2) %>%
                   mutate(a8mfin2 = case_when(
                     a8mfin2 ==  0 ~ 10,
                     a8mfin2 ==  5 ~ 5,
                     a8mfin2 == 10 ~ 0
                   )) %>% 
                   mutate(a8si1_raw = a8si1) %>%
                   mutate(a8si1 = case_when(
                     a8si1 ==  0 ~ 10,
                     a8si1 ==  5 ~ 5,
                     a8si1 == 10 ~ 0
                   ))


## Items invertidos

# - A8MFIN2: ¿Puede tomar un juguete pequeño y tenerlo en la palma de la mano, sujetándolo con los dedos?
# - A8SI2: Al estar delante de un espejo, ¿intenta tocar el espejo con las manos?

# -----------------------------------------------
# crear puntajes promedios
# -----------------------------------------------

com_items <- dplyr::select(datos_psicomotor, a8com1:a8com6)
amp_items <- dplyr::select(datos_psicomotor, a8mamp1:a8mamp6)
fin_items <- dplyr::select(datos_psicomotor, a8mfin1:a8mfin6)
pro_items <- dplyr::select(datos_psicomotor, a8rp1:a8rp6)
soc_items <- dplyr::select(datos_psicomotor, a8si1:a8si6)

datos_psicomotor <- datos_psicomotor %>%
                   mutate(com = mean_score(com_items)) %>%
                   mutate(amp = mean_score(amp_items)) %>%
                   mutate(fin = mean_score(fin_items)) %>%
                   mutate(pro = mean_score(pro_items)) %>%
                   mutate(soc = mean_score(soc_items))

# -----------------------------------------------
# listado de putajes generados
# -----------------------------------------------

# com = comunicación
# amp = motricidad gruesa
# fin = motricidad fina
# pro = resolucion de problemas
# soc = socio individual (relaciones interpersonales)

# -----------------------------------------------
# participación paterna
# -----------------------------------------------

datos_psicomotor <- datos_psicomotor %>%
                   mutate(pad_mudar_r = reverse(pad_mudar)) %>%
                   mutate(parinv = mean_score(pad_mudar_r, pad_jugar, pad_dormir,pad_alim, pad_med)) %>%
                   mutate(par_z  = z_score(parinv))


# -----------------------------------------------
# scatter
# -----------------------------------------------

library(ggpubr)
ggscatter(datos_psicomotor, 
	      x = "par_z", 
	      y = "soc",
          # add = "reg.line",                       # Add regression line
          fullrange = TRUE,                         # Extending the regression line
          #rug = TRUE                               # Add marginal rug
          )


