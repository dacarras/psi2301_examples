Regresión con datos de psicomotor
================

# Pregunta: como evalar la influencia relativa de varios factores

Estimado profesor, le escribo porque como grupo nos surgió una duda con
respecto al trabajo semestral. Nosotros elegimos la base de datos de
psicomotor y planteamos la siguiente pregunta de investigación;

**¿Cómo influye la participación y estimulación del padre en el
desarrollo psicomotor del bebé?**

Con la información de la base de datos construimos 2 variables, una
combinando los item de la escala de participación paterna y otro tomando
uno de los item del cuestionario Ages and Stages (el item de desarrollo
socio individual) y utilizamos además la variable sexo del niño y edad
gestacional del niño al nacer.

Para la entrega pasada se nos pedía cruzar una variable continua y una
categórica y reportar los resultados de estos cruces, nosotros lo
hicimos y nos evaluaron bien, sin embargo, nos dimos cuenta de que no
respondemos a la pregunta de investigación que planteamos en un
principio, porque para poder hacer esto tendríamos que cruzar las
variables construidas y ambas son continuas.

**¿Existe algún código para poder hacer esto? ¿O no se podría hacer?**

# Preparar datos

## Abrir datos

``` r
# -----------------------------------------------------------------------------
# abrir dplyr y los datos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# actualizar psi2301
# -----------------------------------------------

# credentials::set_github_pat()
# devtools::install_github("dacarras/psi2301", force = TRUE)


# -----------------------------------------------------------------------------
# funciones para crear puntajes
# -----------------------------------------------------------------------------

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
# abrir datos
# -----------------------------------------------

library(dplyr)
datos_desarollo <- psi2301::desarollo_psicomotor

# -----------------------------------------------
# preparar los datos
# -----------------------------------------------

datos_desarollo <- datos_desarollo %>%
                   rename_all(tolower) %>%
                   dplyr::glimpse()
```

    ## Rows: 250
    ## Columns: 40
    ## $ nse        <dbl> 3, 3, 1, 3, 1, 3, 3, 2, 3, 1, 2, 3, 1, 2, 3, 2, 3, 1, 2, 2,…
    ## $ sex        <dbl> 2, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1,…
    ## $ edad_gest  <dbl> 37, 38, 40, NA, 42, 39, 34, 38, 35, 31, 39, 28, 38, 42, 38,…
    ## $ peso_nac   <dbl> 3195, 3470, 4360, NA, 3696, 3000, 1916, 2325, 2800, 1990, 3…
    ## $ edad_emb_n <dbl> 30, 31, 24, NA, 23, 31, 31, 41, 16, 28, 21, 29, 19, 22, 30,…
    ## $ pad_alim   <dbl> 3, 4, 1, 2, 4, 1, 2, 3, 3, 3, 5, 1, 3, 5, 2, 5, 2, 4, 2, 3,…
    ## $ pad_jugar  <dbl> 5, 4, 2, 5, 5, 3, 2, 4, 5, 5, 5, 5, 5, 5, 5, 5, 2, 4, 4, 5,…
    ## $ pad_dormir <dbl> 5, 5, 1, 3, 4, 2, 2, 3, 4, 5, 4, 5, 1, 4, 4, 3, 2, 4, 5, 5,…
    ## $ pad_mudar  <dbl> 5, 1, 4, 2, 4, 4, 4, 5, 2, 5, 2, 3, 1, 3, 3, 5, 4, 3, 5, 5,…
    ## $ pad_med    <dbl> 4, 3, 1, 1, 3, 1, 4, 5, 1, 1, 4, 4, 1, 5, 1, 2, 2, 4, 2, 3,…
    ## $ a8com1     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8com2     <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, …
    ## $ a8com3     <dbl> 10, 10, 10, 10, 10, 5, 5, 5, 5, 5, 5, 10, 10, 10, 10, 10, 0…
    ## $ a8com4     <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, 1…
    ## $ a8com5     <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 5, 10, 0, 10, 10, 5, 10, 5, …
    ## $ a8com6     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 1…
    ## $ a8mamp1    <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, 0…
    ## $ a8mamp2    <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, …
    ## $ a8mamp3    <dbl> 10, 5, 10, 0, 10, 0, 0, 10, 0, 0, 10, 10, 0, 10, 10, 0, 10,…
    ## $ a8mamp4    <dbl> 10, 10, 10, 5, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 10…
    ## $ a8mamp5    <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, …
    ## $ a8mamp6    <dbl> 5, 10, 10, 0, 5, 0, 10, 0, 0, 10, 10, 10, 0, 10, 10, 0, 10,…
    ## $ a8mfin1    <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, …
    ## $ a8mfin2    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ a8mfin3    <dbl> 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8mfin4    <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8mfin5    <dbl> 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 10,…
    ## $ a8mfin6    <dbl> 5, 10, 5, 10, 10, 10, 10, 10, 5, 5, 10, 10, 5, 10, 5, 10, 5…
    ## $ a8rp1      <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8rp2      <dbl> 5, 10, 5, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8rp3      <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 1…
    ## $ a8rp4      <dbl> 5, 10, 10, 10, 10, 10, 10, 5, 0, 5, 10, 10, 10, 5, 10, 5, 1…
    ## $ a8rp5      <dbl> 10, 5, 0, 10, 5, 10, 5, 5, 10, 10, 10, 10, 5, 10, 10, 5, 0,…
    ## $ a8rp6      <dbl> 10, 10, 5, 10, 10, 10, 0, 0, 0, 10, 10, 10, 10, 5, 5, 10, 0…
    ## $ a8si1      <dbl> 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 10, …
    ## $ a8si2      <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 0, 5, 5, 10, 5, 10, NA, 10,…
    ## $ a8si3      <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8si4      <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, 1…
    ## $ a8si5      <dbl> 5, 10, 10, 0, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, 5, 10, …
    ## $ a8si6      <dbl> 10, 10, 10, 0, 10, 0, 10, 0, 10, 10, 10, 10, 5, 10, NA, 10,…

``` r
# -----------------------------------------------
# descriptivo de frecuencias
# -----------------------------------------------

datos_desarollo %>%
  dplyr::select(a8com1:a8si6) %>%
  r4sda::wide_resp() %>%
  knitr::kable(., digits = 2)
```

| variable |   00 |   05 |   10 |   NA | hist     |
|:---------|-----:|-----:|-----:|-----:|:---------|
| a8com1   |   NA | 0.06 | 0.94 |   NA | ▁▁▁▁▁▁▁▇ |
| a8com2   |   NA | 0.09 | 0.90 | 0.00 | ▁▁▁▁▁▁▁▇ |
| a8com3   | 0.06 | 0.30 | 0.64 | 0.00 | ▁▁▁▃▁▁▁▇ |
| a8com4   | 0.07 | 0.09 | 0.84 |   NA | ▁▁▁▁▁▁▁▇ |
| a8com5   | 0.06 | 0.20 | 0.74 | 0.00 | ▁▁▁▂▁▁▁▇ |
| a8com6   | 0.07 | 0.08 | 0.84 | 0.00 | ▁▁▁▁▁▁▁▇ |
| a8mamp1  | 0.09 | 0.10 | 0.82 |   NA | ▁▁▁▁▁▁▁▇ |
| a8mamp2  | 0.12 | 0.12 | 0.76 | 0.01 | ▁▁▁▁▁▁▁▇ |
| a8mamp3  | 0.50 | 0.14 | 0.36 | 0.00 | ▇▁▁▂▁▁▁▆ |
| a8mamp4  | 0.10 | 0.11 | 0.79 |   NA | ▁▁▁▁▁▁▁▇ |
| a8mamp5  | 0.09 | 0.12 | 0.79 |   NA | ▁▁▁▁▁▁▁▇ |
| a8mamp6  | 0.36 | 0.19 | 0.45 | 0.00 | ▆▁▁▃▁▁▁▇ |
| a8mfin1  | 0.02 | 0.05 | 0.93 |   NA | ▁▁▁▁▁▁▁▇ |
| a8mfin2  | 0.94 | 0.05 | 0.01 | 0.00 | ▇▁▁▁▁▁▁▁ |
| a8mfin3  | 0.07 | 0.10 | 0.84 |   NA | ▁▁▁▁▁▁▁▇ |
| a8mfin4  | 0.01 | 0.05 | 0.94 |   NA | ▁▁▁▁▁▁▁▇ |
| a8mfin5  | 0.08 | 0.15 | 0.77 | 0.00 | ▁▁▁▂▁▁▁▇ |
| a8mfin6  | 0.11 | 0.20 | 0.69 |   NA | ▁▁▁▂▁▁▁▇ |
| a8rp1    | 0.00 | 0.04 | 0.96 |   NA | ▁▁▁▁▁▁▁▇ |
| a8rp2    | 0.04 | 0.09 | 0.86 | 0.01 | ▁▁▁▁▁▁▁▇ |
| a8rp3    | 0.04 | 0.05 | 0.92 |   NA | ▁▁▁▁▁▁▁▇ |
| a8rp4    | 0.05 | 0.10 | 0.85 |   NA | ▁▁▁▁▁▁▁▇ |
| a8rp5    | 0.10 | 0.22 | 0.68 |   NA | ▁▁▁▂▁▁▁▇ |
| a8rp6    | 0.14 | 0.18 | 0.68 | 0.00 | ▂▁▁▂▁▁▁▇ |
| a8si1    | 0.91 | 0.05 | 0.04 |   NA | ▇▁▁▁▁▁▁▁ |
| a8si2    | 0.06 | 0.07 | 0.87 | 0.00 | ▁▁▁▁▁▁▁▇ |
| a8si3    | 0.06 | 0.07 | 0.88 |   NA | ▁▁▁▁▁▁▁▇ |
| a8si4    | 0.08 | 0.12 | 0.80 | 0.00 | ▁▁▁▁▁▁▁▇ |
| a8si5    | 0.15 | 0.08 | 0.75 | 0.02 | ▂▁▁▁▁▁▁▇ |
| a8si6    | 0.21 | 0.06 | 0.71 | 0.02 | ▂▁▁▁▁▁▁▇ |

``` r
# Nota: items invertidos `a8mfin2` y `a8si1`
```

## Items invertidos

``` r
# -----------------------------------------------------------------------------
# items invertidos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# invertir items
# -----------------------------------------------

datos_desarollo <- datos_desarollo %>%
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
                      
# -----------------------------------------------
# revisar items invertidos
# -----------------------------------------------

dplyr::count(datos_desarollo, a8mfin2_raw, a8mfin2)
```

    ## # A tibble: 4 × 3
    ##   a8mfin2_raw a8mfin2     n
    ##         <dbl>   <dbl> <int>
    ## 1           0      10   234
    ## 2           5       5    13
    ## 3          10       0     2
    ## 4          NA      NA     1

``` r
dplyr::count(datos_desarollo, a8si1_raw, a8si1)
```

    ## # A tibble: 3 × 3
    ##   a8si1_raw a8si1     n
    ##       <dbl> <dbl> <int>
    ## 1         0    10   227
    ## 2         5     5    13
    ## 3        10     0    10

## Variables dependientes

``` r
# -----------------------------------------------------------------------------
# indices de desarollo
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear puntajes promedios
# -----------------------------------------------

com_items <- dplyr::select(datos_desarollo, a8com1:a8com6)
amp_items <- dplyr::select(datos_desarollo, a8mamp1:a8mamp6)
fin_items <- dplyr::select(datos_desarollo, a8mfin1:a8mfin6)
pro_items <- dplyr::select(datos_desarollo, a8rp1:a8rp6)
soc_items <- dplyr::select(datos_desarollo, a8si1:a8si6)

datos_desarollo <- datos_desarollo %>%
                   mutate(com = psi2301::mean_score(com_items)) %>%
                   mutate(amp = psi2301::mean_score(amp_items)) %>%
                   mutate(fin = psi2301::mean_score(fin_items)) %>%
                   mutate(pro = psi2301::mean_score(pro_items)) %>%
                   mutate(soc = psi2301::mean_score(soc_items))

# -----------------------------------------------
# listado de putajes generados
# -----------------------------------------------

# com = comunicación
# amp = motricidad gruesa
# fin = motricidad fina
# pro = resolucion de problemas
# soc = socio individual (relaciones interpersonales)
```

## Covariables

``` r
# -----------------------------------------------------------------------------
# covariables
# -----------------------------------------------------------------------------

# -----------------------------------------------
# nivel socioeconómico
# -----------------------------------------------

# crear nse con valores texto
datos_desarollo <- datos_desarollo %>%
                   mutate(nse_group = case_when(
                     nse == 1 ~ 'alto',
                     nse == 2 ~ 'medio',
                     nse == 3 ~ 'bajo'
                   )) %>%
                   mutate(nse_1 = dplyr::if_else(nse == 3, 1, 0)) %>% # bajo
                   mutate(nse_2 = dplyr::if_else(nse == 2, 1, 0)) %>% # medio
                   mutate(nse_3 = dplyr::if_else(nse == 1, 1, 0)) %>% # alto
                   dplyr::glimpse()
```

    ## Rows: 250
    ## Columns: 51
    ## $ nse         <dbl> 3, 3, 1, 3, 1, 3, 3, 2, 3, 1, 2, 3, 1, 2, 3, 2, 3, 1, 2, 2…
    ## $ sex         <dbl> 2, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1…
    ## $ edad_gest   <dbl> 37, 38, 40, NA, 42, 39, 34, 38, 35, 31, 39, 28, 38, 42, 38…
    ## $ peso_nac    <dbl> 3195, 3470, 4360, NA, 3696, 3000, 1916, 2325, 2800, 1990, …
    ## $ edad_emb_n  <dbl> 30, 31, 24, NA, 23, 31, 31, 41, 16, 28, 21, 29, 19, 22, 30…
    ## $ pad_alim    <dbl> 3, 4, 1, 2, 4, 1, 2, 3, 3, 3, 5, 1, 3, 5, 2, 5, 2, 4, 2, 3…
    ## $ pad_jugar   <dbl> 5, 4, 2, 5, 5, 3, 2, 4, 5, 5, 5, 5, 5, 5, 5, 5, 2, 4, 4, 5…
    ## $ pad_dormir  <dbl> 5, 5, 1, 3, 4, 2, 2, 3, 4, 5, 4, 5, 1, 4, 4, 3, 2, 4, 5, 5…
    ## $ pad_mudar   <dbl> 5, 1, 4, 2, 4, 4, 4, 5, 2, 5, 2, 3, 1, 3, 3, 5, 4, 3, 5, 5…
    ## $ pad_med     <dbl> 4, 3, 1, 1, 3, 1, 4, 5, 1, 1, 4, 4, 1, 5, 1, 2, 2, 4, 2, 3…
    ## $ a8com1      <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8com2      <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8com3      <dbl> 10, 10, 10, 10, 10, 5, 5, 5, 5, 5, 5, 10, 10, 10, 10, 10, …
    ## $ a8com4      <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, …
    ## $ a8com5      <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 5, 10, 0, 10, 10, 5, 10, 5,…
    ## $ a8com6      <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, …
    ## $ a8mamp1     <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, …
    ## $ a8mamp2     <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8mamp3     <dbl> 10, 5, 10, 0, 10, 0, 0, 10, 0, 0, 10, 10, 0, 10, 10, 0, 10…
    ## $ a8mamp4     <dbl> 10, 10, 10, 5, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 1…
    ## $ a8mamp5     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10,…
    ## $ a8mamp6     <dbl> 5, 10, 10, 0, 5, 0, 10, 0, 0, 10, 10, 10, 0, 10, 10, 0, 10…
    ## $ a8mfin1     <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8mfin2     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8mfin3     <dbl> 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8mfin4     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8mfin5     <dbl> 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 10…
    ## $ a8mfin6     <dbl> 5, 10, 5, 10, 10, 10, 10, 10, 5, 5, 10, 10, 5, 10, 5, 10, …
    ## $ a8rp1       <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, …
    ## $ a8rp2       <dbl> 5, 10, 5, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8rp3       <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, …
    ## $ a8rp4       <dbl> 5, 10, 10, 10, 10, 10, 10, 5, 0, 5, 10, 10, 10, 5, 10, 5, …
    ## $ a8rp5       <dbl> 10, 5, 0, 10, 5, 10, 5, 5, 10, 10, 10, 10, 5, 10, 10, 5, 0…
    ## $ a8rp6       <dbl> 10, 10, 5, 10, 10, 10, 0, 0, 0, 10, 10, 10, 10, 5, 5, 10, …
    ## $ a8si1       <dbl> 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8si2       <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 0, 5, 5, 10, 5, 10, NA, 10…
    ## $ a8si3       <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, …
    ## $ a8si4       <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, …
    ## $ a8si5       <dbl> 5, 10, 10, 0, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, 5, 10,…
    ## $ a8si6       <dbl> 10, 10, 10, 0, 10, 0, 10, 0, 10, 10, 10, 10, 5, 10, NA, 10…
    ## $ a8mfin2_raw <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ a8si1_raw   <dbl> 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 10,…
    ## $ com         <dbl> 10.000000, 8.333333, 10.000000, 10.000000, 10.000000, 9.16…
    ## $ amp         <dbl> 9.166667, 8.333333, 10.000000, 5.833333, 9.166667, 6.66666…
    ## $ fin         <dbl> 7.500000, 10.000000, 5.833333, 10.000000, 10.000000, 10.00…
    ## $ pro         <dbl> 8.333333, 9.166667, 6.666667, 10.000000, 9.166667, 10.0000…
    ## $ soc         <dbl> 8.333333, 9.166667, 10.000000, 6.666667, 10.000000, 8.3333…
    ## $ nse_group   <chr> "bajo", "bajo", "alto", "bajo", "alto", "bajo", "bajo", "m…
    ## $ nse_1       <dbl> 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0…
    ## $ nse_2       <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1…
    ## $ nse_3       <dbl> 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0…

``` r
# -----------------------------------------------------------------------------
# involucramiento parental
# -----------------------------------------------------------------------------

# -----------------------------------------------
# participación paterna
# -----------------------------------------------

datos_desarollo <- datos_desarollo %>%
                   mutate(pad_mudar_r = reverse(pad_mudar)) %>%
                   mutate(parinv = mean_score(pad_mudar_r, pad_jugar, pad_dormir,pad_alim, pad_med)) %>%
                   mutate(par_z  = z_score(parinv))
                    

# -----------------------------------------------
# reliability analysis
# -----------------------------------------------

datos_desarollo %>%
dplyr::select(pad_mudar,pad_mudar_r, pad_jugar, pad_dormir,pad_alim, pad_med) %>%
psych::alpha()
```

    ## Some items ( pad_mudar ) were negatively correlated with the total scale and 
    ## probably should be reversed.  
    ## To do this, run the function again with the 'check.keys=TRUE' option

    ## In smc, smcs < 0 were set to .0
    ## In smc, smcs < 0 were set to .0
    ## In smc, smcs < 0 were set to .0
    ## In smc, smcs < 0 were set to .0
    ## In smc, smcs < 0 were set to .0
    ## In smc, smcs < 0 were set to .0

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r  S/N   ase mean   sd median_r
    ##       0.48      0.49    0.57      0.14 0.94 0.037  3.1 0.75     0.43
    ## 
    ##     95% confidence boundaries 
    ##          lower alpha upper
    ## Feldt     0.38  0.48  0.58
    ## Duhachek  0.41  0.48  0.55
    ## 
    ##  Reliability if an item is dropped:
    ##             raw_alpha std.alpha G6(smc) average_r  S/N alpha se  var.r med.r
    ## pad_mudar        0.83      0.83    0.80     0.496 4.91    0.017 0.0063  0.49
    ## pad_mudar_r      0.38      0.39    0.59     0.112 0.63    0.051 0.2653  0.42
    ## pad_jugar        0.21      0.19    0.35     0.046 0.24    0.057 0.3494  0.41
    ## pad_dormir       0.16      0.17    0.32     0.040 0.21    0.062 0.3269  0.41
    ## pad_alim         0.20      0.19    0.34     0.045 0.24    0.058 0.3358  0.41
    ## pad_med          0.27      0.29    0.45     0.077 0.42    0.051 0.3923  0.49
    ## 
    ##  Item statistics 
    ##               n raw.r std.r r.cor r.drop mean  sd
    ## pad_mudar   241 -0.60 -0.60 -1.22  -0.76  3.4 1.4
    ## pad_mudar_r 241  0.60  0.60  0.38   0.34  2.6 1.4
    ## pad_jugar   241  0.80  0.81  0.84   0.65  3.8 1.3
    ## pad_dormir  241  0.83  0.83  0.90   0.67  3.1 1.5
    ## pad_alim    241  0.81  0.81  0.86   0.65  2.9 1.3
    ## pad_med     241  0.73  0.71  0.64   0.50  2.9 1.5
    ## 
    ## Non missing response frequency for each item
    ##                1    2    3    4    5 miss
    ## pad_mudar   0.14 0.16 0.22 0.18 0.31 0.04
    ## pad_mudar_r 0.31 0.18 0.22 0.16 0.14 0.04
    ## pad_jugar   0.10 0.09 0.15 0.24 0.42 0.04
    ## pad_dormir  0.21 0.13 0.19 0.22 0.24 0.04
    ## pad_alim    0.20 0.22 0.26 0.17 0.16 0.04
    ## pad_med     0.30 0.15 0.16 0.18 0.22 0.04

``` r
datos_desarollo %>%
dplyr::select(pad_mudar_r, pad_jugar, pad_dormir,pad_alim, pad_med) %>%
psych::alpha()
```

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r S/N   ase mean  sd median_r
    ##       0.83      0.83     0.8       0.5 4.9 0.017  3.1 1.1     0.49
    ## 
    ##     95% confidence boundaries 
    ##          lower alpha upper
    ## Feldt     0.79  0.83  0.86
    ## Duhachek  0.79  0.83  0.86
    ## 
    ##  Reliability if an item is dropped:
    ##             raw_alpha std.alpha G6(smc) average_r S/N alpha se  var.r med.r
    ## pad_mudar_r      0.80      0.80    0.76      0.51 4.1    0.021 0.0088  0.49
    ## pad_jugar        0.79      0.79    0.75      0.49 3.8    0.022 0.0072  0.47
    ## pad_dormir       0.77      0.78    0.73      0.46 3.5    0.024 0.0035  0.45
    ## pad_alim         0.78      0.78    0.74      0.47 3.6    0.023 0.0064  0.45
    ## pad_med          0.83      0.83    0.79      0.55 4.8    0.018 0.0031  0.54
    ## 
    ##  Item statistics 
    ##               n raw.r std.r r.cor r.drop mean  sd
    ## pad_mudar_r 241  0.76  0.76  0.66   0.60  2.6 1.4
    ## pad_jugar   241  0.78  0.79  0.72   0.65  3.8 1.3
    ## pad_dormir  241  0.82  0.82  0.78   0.70  3.1 1.5
    ## pad_alim    241  0.80  0.81  0.75   0.68  2.9 1.3
    ## pad_med     241  0.71  0.69  0.56   0.51  2.9 1.5
    ## 
    ## Non missing response frequency for each item
    ##                1    2    3    4    5 miss
    ## pad_mudar_r 0.31 0.18 0.22 0.16 0.14 0.04
    ## pad_jugar   0.10 0.09 0.15 0.24 0.42 0.04
    ## pad_dormir  0.21 0.13 0.19 0.22 0.24 0.04
    ## pad_alim    0.20 0.22 0.26 0.17 0.16 0.04
    ## pad_med     0.30 0.15 0.16 0.18 0.22 0.04

``` r
# -----------------------------------------------------------------------------
# edad gestacional
# -----------------------------------------------------------------------------

# -----------------------------------------------
# edad gestacional
# -----------------------------------------------

datos_desarollo <- datos_desarollo %>%
                   mutate(ges_1= case_when(  
                   between(edad_gest, 24, 32) ~ 'muy prematuro', 
                   between(edad_gest, 33, 37) ~ 'prematuro',
                   between(edad_gest, 38, 42) ~ 'normal'
                   )) %>%
                   mutate(ges_2= case_when(  
                   between(edad_gest, 24, 32) ~ 'muy prematuro', 
                   between(edad_gest, 33, 37) ~ 'prematuro',
                   between(edad_gest, 38, 42) ~ 'normal'
                   )) %>%
                   mutate(ges_3= case_when(  
                   ges_2 == "muy prematuro" ~ 1  , 
                   ges_2 == "prematuro" ~ 2 ,
                   ges_2 == "normal" ~ 3
                   )) %>%
                   mutate(risk_2 = dplyr::if_else(ges_3 == 1, 1, 0)) %>% # muy prematuro
                   mutate(risk_1 = dplyr::if_else(ges_3 == 2, 1, 0)) %>% # prematuro
                   mutate(risk_0 = dplyr::if_else(ges_3 == 3, 1, 0)) %>% # normal
                   dplyr::glimpse()
```

    ## Rows: 250
    ## Columns: 60
    ## $ nse         <dbl> 3, 3, 1, 3, 1, 3, 3, 2, 3, 1, 2, 3, 1, 2, 3, 2, 3, 1, 2, 2…
    ## $ sex         <dbl> 2, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1…
    ## $ edad_gest   <dbl> 37, 38, 40, NA, 42, 39, 34, 38, 35, 31, 39, 28, 38, 42, 38…
    ## $ peso_nac    <dbl> 3195, 3470, 4360, NA, 3696, 3000, 1916, 2325, 2800, 1990, …
    ## $ edad_emb_n  <dbl> 30, 31, 24, NA, 23, 31, 31, 41, 16, 28, 21, 29, 19, 22, 30…
    ## $ pad_alim    <dbl> 3, 4, 1, 2, 4, 1, 2, 3, 3, 3, 5, 1, 3, 5, 2, 5, 2, 4, 2, 3…
    ## $ pad_jugar   <dbl> 5, 4, 2, 5, 5, 3, 2, 4, 5, 5, 5, 5, 5, 5, 5, 5, 2, 4, 4, 5…
    ## $ pad_dormir  <dbl> 5, 5, 1, 3, 4, 2, 2, 3, 4, 5, 4, 5, 1, 4, 4, 3, 2, 4, 5, 5…
    ## $ pad_mudar   <dbl> 5, 1, 4, 2, 4, 4, 4, 5, 2, 5, 2, 3, 1, 3, 3, 5, 4, 3, 5, 5…
    ## $ pad_med     <dbl> 4, 3, 1, 1, 3, 1, 4, 5, 1, 1, 4, 4, 1, 5, 1, 2, 2, 4, 2, 3…
    ## $ a8com1      <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8com2      <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8com3      <dbl> 10, 10, 10, 10, 10, 5, 5, 5, 5, 5, 5, 10, 10, 10, 10, 10, …
    ## $ a8com4      <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, …
    ## $ a8com5      <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 5, 10, 0, 10, 10, 5, 10, 5,…
    ## $ a8com6      <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, …
    ## $ a8mamp1     <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, …
    ## $ a8mamp2     <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8mamp3     <dbl> 10, 5, 10, 0, 10, 0, 0, 10, 0, 0, 10, 10, 0, 10, 10, 0, 10…
    ## $ a8mamp4     <dbl> 10, 10, 10, 5, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 1…
    ## $ a8mamp5     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10,…
    ## $ a8mamp6     <dbl> 5, 10, 10, 0, 5, 0, 10, 0, 0, 10, 10, 10, 0, 10, 10, 0, 10…
    ## $ a8mfin1     <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8mfin2     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8mfin3     <dbl> 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8mfin4     <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8mfin5     <dbl> 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 10…
    ## $ a8mfin6     <dbl> 5, 10, 5, 10, 10, 10, 10, 10, 5, 5, 10, 10, 5, 10, 5, 10, …
    ## $ a8rp1       <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, …
    ## $ a8rp2       <dbl> 5, 10, 5, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8rp3       <dbl> 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, …
    ## $ a8rp4       <dbl> 5, 10, 10, 10, 10, 10, 10, 5, 0, 5, 10, 10, 10, 5, 10, 5, …
    ## $ a8rp5       <dbl> 10, 5, 0, 10, 5, 10, 5, 5, 10, 10, 10, 10, 5, 10, 10, 5, 0…
    ## $ a8rp6       <dbl> 10, 10, 5, 10, 10, 10, 0, 0, 0, 10, 10, 10, 10, 5, 5, 10, …
    ## $ a8si1       <dbl> 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8si2       <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 0, 5, 5, 10, 5, 10, NA, 10…
    ## $ a8si3       <dbl> 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, …
    ## $ a8si4       <dbl> 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, …
    ## $ a8si5       <dbl> 5, 10, 10, 0, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, 5, 10,…
    ## $ a8si6       <dbl> 10, 10, 10, 0, 10, 0, 10, 0, 10, 10, 10, 10, 5, 10, NA, 10…
    ## $ a8mfin2_raw <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ a8si1_raw   <dbl> 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 10,…
    ## $ com         <dbl> 10.000000, 8.333333, 10.000000, 10.000000, 10.000000, 9.16…
    ## $ amp         <dbl> 9.166667, 8.333333, 10.000000, 5.833333, 9.166667, 6.66666…
    ## $ fin         <dbl> 7.500000, 10.000000, 5.833333, 10.000000, 10.000000, 10.00…
    ## $ pro         <dbl> 8.333333, 9.166667, 6.666667, 10.000000, 9.166667, 10.0000…
    ## $ soc         <dbl> 8.333333, 9.166667, 10.000000, 6.666667, 10.000000, 8.3333…
    ## $ nse_group   <chr> "bajo", "bajo", "alto", "bajo", "alto", "bajo", "bajo", "m…
    ## $ nse_1       <dbl> 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0…
    ## $ nse_2       <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1…
    ## $ nse_3       <dbl> 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0…
    ## $ pad_mudar_r <dbl> 1, 5, 2, 4, 2, 2, 2, 1, 4, 1, 4, 3, 5, 3, 3, 1, 2, 3, 1, 1…
    ## $ parinv      <dbl> 3.6, 4.2, 1.4, 3.0, 3.6, 1.8, 2.4, 3.2, 3.4, 3.0, 4.4, 3.6…
    ## $ par_z       <dbl> 0.48863127, 1.03805648, -1.52592783, -0.06079394, 0.488631…
    ## $ ges_1       <chr> "prematuro", "normal", "normal", NA, "normal", "normal", "…
    ## $ ges_2       <chr> "prematuro", "normal", "normal", NA, "normal", "normal", "…
    ## $ ges_3       <dbl> 2, 3, 3, NA, 3, 3, 2, 3, 2, 1, 3, 1, 3, 3, 3, 3, 3, NA, 3,…
    ## $ risk_2      <dbl> 0, 0, 0, NA, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, NA, 0,…
    ## $ risk_1      <dbl> 1, 0, 0, NA, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, NA, 0,…
    ## $ risk_0      <dbl> 0, 1, 1, NA, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, NA, 1,…

``` r
# -----------------------------------------------
# sexo del niño
# -----------------------------------------------

datos_desarollo <- datos_desarollo %>%
                   mutate(male = case_when(  
                   sex == 1 ~ 1, # male
                   sex == 2 ~ 0  # female
                   )) %>%
                   mutate(female = case_when(  
                   sex == 1 ~ 0, # male
                   sex == 2 ~ 1  # female
                   ))


# -----------------------------------------------------------------------------
# revision de datos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# inspeccionar base de datos creada
# -----------------------------------------------

datos_desarollo %>%
r4sda::variables_table() %>%
knitr::kable()
```

| variable    | type | values                        | labels                    |
|:------------|:-----|:------------------------------|:--------------------------|
| nse         | dbl  | 2, 3, 1, 2, 3, 2, 3, 1, 2, 2… | === no variable label === |
| sex         | dbl  | 1, 2, 1, 1, 1, 1, 1, 1, 2, 1… | === no variable label === |
| edad_gest   | dbl  | , 35, 31, 39, 28, 38, 42, 38… | === no variable label === |
| peso_nac    | dbl  | 00, 1916, 2325, 2800, 1990, … | === no variable label === |
| edad_emb_n  | dbl  | , 16, 28, 21, 29, 19, 22, 30… | === no variable label === |
| pad_alim    | dbl  | 5, 1, 3, 5, 2, 5, 2, 4, 2, 3… | === no variable label === |
| pad_jugar   | dbl  | 5, 5, 5, 5, 5, 5, 2, 4, 4, 5… | === no variable label === |
| pad_dormir  | dbl  | 4, 5, 1, 4, 4, 3, 2, 4, 5, 5… | === no variable label === |
| pad_mudar   | dbl  | 2, 3, 1, 3, 3, 5, 4, 3, 5, 5… | === no variable label === |
| pad_med     | dbl  | 4, 4, 1, 5, 1, 2, 2, 4, 2, 3… | === no variable label === |
| a8com1      | dbl  | , 10, 10, 10, 10, 10, 10, 10… | === no variable label === |
| a8com2      | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8com3      | dbl  | , 5, 5, 10, 10, 10, 10, 10, … | === no variable label === |
| a8com4      | dbl  | 10, 10, 5, 10, 10, 10, 10, …  | === no variable label === |
| a8com5      | dbl  | 5, 10, 0, 10, 10, 5, 10, 5,…  | === no variable label === |
| a8com6      | dbl  | , 10, 5, 5, 10, 10, 10, 10, … | === no variable label === |
| a8mamp1     | dbl  | 0, 10, 10, 10, 10, 10, 10, …  | === no variable label === |
| a8mamp2     | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8mamp3     | dbl  | 0, 10, 10, 0, 10, 10, 0, 10…  | === no variable label === |
| a8mamp4     | dbl  | 10, 10, 10, 10, 10, 10, 5, 1… | === no variable label === |
| a8mamp5     | dbl  | , 10, 10, 10, 10, 5, 10, 10,… | === no variable label === |
| a8mamp6     | dbl  | 10, 10, 10, 0, 10, 10, 0, 10… | === no variable label === |
| a8mfin1     | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8mfin2     | dbl  | , 10, 10, 10, 10, 10, 10, 10… | === no variable label === |
| a8mfin3     | dbl  | 0, 10, 10, 10, 10, 10, 10, 1… | === no variable label === |
| a8mfin4     | dbl  | , 10, 10, 10, 10, 10, 10, 10… | === no variable label === |
| a8mfin5     | dbl  | 0, 10, 10, 10, 10, 10, 5, 10… | === no variable label === |
| a8mfin6     | dbl  | 5, 5, 10, 10, 5, 10, 5, 10, … | === no variable label === |
| a8rp1       | dbl  | 5, 10, 10, 10, 10, 10, 10, …  | === no variable label === |
| a8rp2       | dbl  | 0, 10, 10, 10, 10, 10, 10, 1… | === no variable label === |
| a8rp3       | dbl  | 10, 10, 10, 10, 10, 10, 5, …  | === no variable label === |
| a8rp4       | dbl  | 0, 5, 10, 10, 10, 5, 10, 5, … | === no variable label === |
| a8rp5       | dbl  | 10, 10, 10, 5, 10, 10, 5, 0…  | === no variable label === |
| a8rp6       | dbl  | , 10, 10, 10, 10, 5, 5, 10, … | === no variable label === |
| a8si1       | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8si2       | dbl  | , 0, 5, 5, 10, 5, 10, NA, 10… | === no variable label === |
| a8si3       | dbl  | 5, 10, 10, 10, 10, 10, 10, …  | === no variable label === |
| a8si4       | dbl  | 10, 10, 5, 10, 10, 10, 10, …  | === no variable label === |
| a8si5       | dbl  | , 10, 10, 10, 10, 10, 5, 10,… | === no variable label === |
| a8si6       | dbl  | 0, 10, 10, 10, 5, 10, NA, 10… | === no variable label === |
| a8mfin2_raw | dbl  | 0, 0, 0, 0, 0, 0, 0, 0, 0, 0… | === no variable label === |
| a8si1_raw   | dbl  | 0, 0, 0, 0, 0, 0, 10, 0, 10,… | === no variable label === |
| com         | dbl  | , 10.000000, 10.000000, 9.16… | === no variable label === |
| amp         | dbl  | 5.833333, 9.166667, 6.66666…  | === no variable label === |
| fin         | dbl  | 10.000000, 10.000000, 10.00…  | === no variable label === |
| pro         | dbl  | 10.000000, 9.166667, 10.0000… | === no variable label === |
| soc         | dbl  | 6.666667, 10.000000, 8.3333…  | === no variable label === |
| nse_group   | chr  | , “alto”, “bajo”, “bajo”, “m… | === no variable label === |
| nse_1       | dbl  | 0, 1, 0, 0, 1, 0, 1, 0, 0, 0… | === no variable label === |
| nse_2       | dbl  | 1, 0, 0, 1, 0, 1, 0, 0, 1, 1… | === no variable label === |
| nse_3       | dbl  | 0, 0, 1, 0, 0, 0, 0, 1, 0, 0… | === no variable label === |
| pad_mudar_r | dbl  | 4, 3, 5, 3, 3, 1, 2, 3, 1, 1… | === no variable label === |
| parinv      | dbl  | 2.4, 3.2, 3.4, 3.0, 4.4, 3.6… | === no variable label === |
| par_z       | dbl  | 92783, -0.06079394, 0.488631… | === no variable label === |
| ges_1       | chr  | “, NA,”normal”, “normal”, “…  | === no variable label === |
| ges_2       | chr  | “, NA,”normal”, “normal”, “…  | === no variable label === |
| ges_3       | dbl  | 3, 1, 3, 3, 3, 3, 3, NA, 3,…  | === no variable label === |
| risk_2      | dbl  | 0, 1, 0, 0, 0, 0, 0, NA, 0,…  | === no variable label === |
| risk_1      | dbl  | 0, 0, 0, 0, 0, 0, 0, NA, 0,…  | === no variable label === |
| risk_0      | dbl  | 1, 0, 1, 1, 1, 1, 1, NA, 1,…  | === no variable label === |
| male        | dbl  | 1, 0, 1, 1, 1, 1, 1, 1, 0, 1… | === no variable label === |
| female      | dbl  | 0, 1, 0, 0, 0, 0, 0, 0, 1, 0… | === no variable label === |

``` r
# -----------------------------------------------------------------------------
# correlaciones
# -----------------------------------------------------------------------------

# -----------------------------------------------
# correlation matrix
# -----------------------------------------------

datos_desarollo %>%
dplyr::select(parinv,
com, #  = comunicación
amp, #  = motricidad gruesa
fin, #  = motricidad fina
pro, #  = resolucion de problemas
soc  #  = socio individual (relaciones interpersonales)
) %>%
corrr::correlate() %>%
corrr::shave() %>%
knitr::kable(., digits = 2)
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

| term   | parinv |  com |  amp |  fin |  pro | soc |
|:-------|-------:|-----:|-----:|-----:|-----:|----:|
| parinv |     NA |   NA |   NA |   NA |   NA |  NA |
| com    |   0.02 |   NA |   NA |   NA |   NA |  NA |
| amp    |   0.00 | 0.30 |   NA |   NA |   NA |  NA |
| fin    |   0.06 | 0.29 | 0.40 |   NA |   NA |  NA |
| pro    |   0.12 | 0.42 | 0.43 | 0.56 |   NA |  NA |
| soc    |   0.02 | 0.45 | 0.50 | 0.43 | 0.59 |  NA |

``` r
# -----------------------------------------------
# correlation matrix
# -----------------------------------------------


datos_desarollo %>%
dplyr::select(parinv, par_z,
com, #  = comunicación
amp, #  = motricidad gruesa
fin, #  = motricidad fina
pro, #  = resolucion de problemas
soc  #  = socio individual (relaciones interpersonales)
) %>%
corrr::correlate() %>%
corrr::focus(parinv, par_z) %>%
knitr::kable(., digits = 2)
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

| term | parinv | par_z |
|:-----|-------:|------:|
| com  |   0.02 |  0.02 |
| amp  |   0.00 |  0.00 |
| fin  |   0.06 |  0.06 |
| pro  |   0.12 |  0.12 |
| soc  |   0.02 |  0.02 |

``` r
# |term | parinv| involucramiento parental
# |:----|------:|
# |com  |   0.02| comunicación
# |amp  |   0.00| motricidad gruesa
# |fin  |   0.06| motricidad fina
# |pro  |   0.12| resolución de problemas
# |soc  |   0.02| relaciones interpersonales

# -----------------------------------------------
# missing data
# -----------------------------------------------


library(VIM)
```

    ## Loading required package: colorspace

    ## Loading required package: grid

    ## VIM is ready to use.

    ## Suggestions and bug-reports can be submitted at: https://github.com/statistikat/VIM/issues

    ## 
    ## Attaching package: 'VIM'

    ## The following object is masked from 'package:datasets':
    ## 
    ##     sleep

``` r
datos_desarollo %>%
dplyr::select(parinv, par_z,
com, #  = comunicación
amp, #  = motricidad gruesa
fin, #  = motricidad fina
pro, #  = resolucion de problemas
soc, #  = socio individual (relaciones interpersonales)
nse_group, # SES
ges_1      # edad gestacional  
) %>%
VIM::aggr(., 
  combine=TRUE, 
  cex.lab=.8, 
  cex.axis=.6,
  col = c("white", "black"),
  ylabs="Pattern of omissions"
  )
```

![](c14_2022_regression_psicomotor_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

# Pregunta

**¿Cómo influye la participación y estimulación del padre en el
desarrollo psicomotor del bebé?**

## Estudio 1: involucramiento parental y desarollo socio individiual

``` r
#----------------------------------------------------------
# regresion
#----------------------------------------------------------

data_model <- datos_desarollo

#--------------------------------------
# formulas
#--------------------------------------

f01 <- as.formula(soc  ~ + 1)
f02 <- as.formula(soc  ~ + 1 + parinv)
f03 <- as.formula(soc  ~ + 1 + parinv + as.factor(ges_1))
f04 <- as.formula(soc  ~ + 1 + parinv + as.factor(ges_1) + male)
f05 <- as.formula(soc  ~ + 1 + parinv + as.factor(ges_1) + male + as.factor(nse_group))

#--------------------------------------
# ajustar modelos
#--------------------------------------

m01 <- lm(f01, data = data_model)
m02 <- lm(f02, data = data_model)
m03 <- lm(f03, data = data_model)
m04 <- lm(f04, data = data_model)
m05 <- lm(f05, data = data_model)

#--------------------------------------
# tabla de modelos
#--------------------------------------

texreg::screenreg(
    list(m01, m02, m03, m04, m05),
    star.symbol = "*", 
    center = TRUE, 
    doctype = FALSE,
    dcolumn = TRUE, 
    booktabs = TRUE,
    single.row = FALSE
    )
```

    ## 
    ## =====================================================================================
    ##                            Model 1     Model 2     Model 3     Model 4     Model 5   
    ## -------------------------------------------------------------------------------------
    ## (Intercept)                  8.62 ***    8.62 ***    8.64 ***    8.94 ***    9.47 ***
    ##                             (0.11)      (0.32)      (0.43)      (0.45)      (0.46)   
    ## parinv                                   0.03        0.01        0.01        0.07    
    ##                                         (0.10)      (0.10)      (0.10)      (0.10)   
    ## as.factor(ges_1)normal                               0.12        0.03       -0.11    
    ##                                                     (0.30)      (0.30)      (0.29)   
    ## as.factor(ges_1)prematuro                           -0.17       -0.25       -0.19    
    ##                                                     (0.38)      (0.38)      (0.36)   
    ## male                                                            -0.50 *     -0.56 ** 
    ##                                                                 (0.22)      (0.21)   
    ## as.factor(nse_group)bajo                                                    -1.18 ***
    ##                                                                             (0.30)   
    ## as.factor(nse_group)medio                                                   -0.28    
    ##                                                                             (0.30)   
    ## -------------------------------------------------------------------------------------
    ## R^2                          0.00        0.00        0.00        0.03        0.11    
    ## Adj. R^2                     0.00       -0.00       -0.01        0.01        0.09    
    ## Num. obs.                  250         241         234         234         234       
    ## =====================================================================================
    ## *** p < 0.001; ** p < 0.01; * p < 0.05

## Estudio 2: involucramiento parental y desarollo de resolución de problemas

``` r
#----------------------------------------------------------
# regresion
#----------------------------------------------------------

data_model <- datos_desarollo

#--------------------------------------
# formulas
#--------------------------------------

f01 <- as.formula(pro  ~ + 1)
f02 <- as.formula(pro  ~ + 1 + parinv)
f03 <- as.formula(pro  ~ + 1 + parinv + as.factor(ges_1))
f04 <- as.formula(pro  ~ + 1 + parinv + as.factor(ges_1) + male)
f05 <- as.formula(pro  ~ + 1 + parinv + as.factor(ges_1) + male + as.factor(nse_group))

#--------------------------------------
# ajustar modelos
#--------------------------------------

m01 <- lm(f01, data = data_model)
m02 <- lm(f02, data = data_model)
m03 <- lm(f03, data = data_model)
m04 <- lm(f04, data = data_model)
m05 <- lm(f05, data = data_model)

#--------------------------------------
# tabla de modelos
#--------------------------------------

texreg::screenreg(
    list(m01, m02, m03, m04, m05),
    star.symbol = "*", 
    center = TRUE, 
    doctype = FALSE,
    dcolumn = TRUE, 
    booktabs = TRUE,
    single.row = FALSE
    )
```

    ## 
    ## =====================================================================================
    ##                            Model 1     Model 2     Model 3     Model 4     Model 5   
    ## -------------------------------------------------------------------------------------
    ## (Intercept)                  8.84 ***    8.48 ***    8.45 ***    8.53 ***    8.90 ***
    ##                             (0.10)      (0.27)      (0.37)      (0.38)      (0.40)   
    ## parinv                                   0.15        0.14        0.14        0.19 *  
    ##                                         (0.08)      (0.09)      (0.09)      (0.09)   
    ## as.factor(ges_1)normal                               0.15        0.13        0.08    
    ##                                                     (0.26)      (0.26)      (0.26)   
    ## as.factor(ges_1)prematuro                           -0.32       -0.34       -0.29    
    ##                                                     (0.32)      (0.32)      (0.32)   
    ## male                                                            -0.12       -0.14    
    ##                                                                 (0.19)      (0.19)   
    ## as.factor(nse_group)bajo                                                    -0.71 ** 
    ##                                                                             (0.26)   
    ## as.factor(nse_group)medio                                                   -0.50    
    ##                                                                             (0.26)   
    ## -------------------------------------------------------------------------------------
    ## R^2                          0.00        0.01        0.03        0.03        0.06    
    ## Adj. R^2                     0.00        0.01        0.02        0.01        0.04    
    ## Num. obs.                  250         241         234         234         234       
    ## =====================================================================================
    ## *** p < 0.001; ** p < 0.01; * p < 0.05

## Estudio 3: involucramiento parental y desarollo (efectos fijos)

``` r
#----------------------------------------------------------
# regresion
#----------------------------------------------------------

data_model <- datos_desarollo

#--------------------------------------
# regresion
#--------------------------------------

f01 <- as.formula(com  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2)
f02 <- as.formula(amp  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2)
f03 <- as.formula(fin  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2) 
f04 <- as.formula(pro  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2)
f05 <- as.formula(soc  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2)

#--------------------------------------
# ajustar modelos
#--------------------------------------

m01 <- lm(f01, data = data_model)
m02 <- lm(f02, data = data_model)
m03 <- lm(f03, data = data_model)
m04 <- lm(f04, data = data_model)
m05 <- lm(f05, data = data_model)

#--------------------------------------
# tabla de modelos
#--------------------------------------

texreg::screenreg(
    list(m01, m02, m03, m04, m05),
    star.symbol = "*", 
    center = TRUE, 
    doctype = FALSE,
    dcolumn = TRUE, 
    booktabs = TRUE,
    single.row = FALSE,
    custom.model.names = c('com', 'amp', 'fin','pro','soc')
    )
```

    ## 
    ## =======================================================================
    ##              com         amp         fin         pro         soc       
    ## -----------------------------------------------------------------------
    ## (Intercept)    8.92 ***    7.36 ***    8.86 ***    9.01 ***    9.03 ***
    ##               (0.13)      (0.26)      (0.16)      (0.16)      (0.18)   
    ## par_z          0.05        0.01        0.08        0.21 *      0.08    
    ##               (0.08)      (0.16)      (0.10)      (0.10)      (0.11)   
    ## nse_1         -0.11        0.17        0.40       -0.20       -0.85 ***
    ##               (0.17)      (0.34)      (0.21)      (0.21)      (0.24)   
    ## nse_3          0.43        0.08        0.51        0.51        0.31    
    ##               (0.22)      (0.43)      (0.26)      (0.26)      (0.30)   
    ## risk_1        -0.08       -0.73       -0.28       -0.37       -0.09    
    ##               (0.21)      (0.41)      (0.25)      (0.25)      (0.29)   
    ## risk_2         0.33        0.10        0.08       -0.11        0.01    
    ##               (0.22)      (0.42)      (0.25)      (0.25)      (0.29)   
    ## -----------------------------------------------------------------------
    ## R^2            0.04        0.02        0.03        0.06        0.08    
    ## Adj. R^2       0.02       -0.01        0.01        0.04        0.06    
    ## Num. obs.    234         234         234         234         234       
    ## =======================================================================
    ## *** p < 0.001; ** p < 0.01; * p < 0.05

## Estudio 4: involucramiento parental y desarollo (interacciones)

``` r
#----------------------------------------------------------
# regresion
#----------------------------------------------------------

data_model <- datos_desarollo

#--------------------------------------
# regresion
#--------------------------------------

f01 <- as.formula(com  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2 + par_z*nse_1 + par_z*nse_3)
f02 <- as.formula(amp  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2 + par_z*nse_1 + par_z*nse_3)
f03 <- as.formula(fin  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2 + par_z*nse_1 + par_z*nse_3) 
f04 <- as.formula(pro  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2 + par_z*nse_1 + par_z*nse_3)
f05 <- as.formula(soc  ~ + 1 + par_z + nse_1 + nse_3 + risk_1 + risk_2 + par_z*nse_1 + par_z*nse_3)

#--------------------------------------
# ajustar modelos
#--------------------------------------

m01 <- lm(f01, data = data_model)
m02 <- lm(f02, data = data_model)
m03 <- lm(f03, data = data_model)
m04 <- lm(f04, data = data_model)
m05 <- lm(f05, data = data_model)

#--------------------------------------
# tabla de modelos
#--------------------------------------

texreg::screenreg(
    list(m01, m02, m03, m04, m05),
    star.symbol = "*", 
    center = TRUE, 
    doctype = FALSE,
    dcolumn = TRUE, 
    booktabs = TRUE,
    single.row = FALSE,
    custom.model.names = c('com', 'amp', 'fin','pro','soc')
    )
```

    ## 
    ## =======================================================================
    ##              com         amp         fin         pro         soc       
    ## -----------------------------------------------------------------------
    ## (Intercept)    8.93 ***    7.36 ***    8.86 ***    9.03 ***    9.04 ***
    ##               (0.13)      (0.26)      (0.16)      (0.16)      (0.18)   
    ## par_z         -0.01        0.07        0.08        0.08        0.08    
    ##               (0.12)      (0.23)      (0.14)      (0.14)      (0.16)   
    ## nse_1         -0.12        0.15        0.39       -0.26       -0.88 ***
    ##               (0.18)      (0.34)      (0.21)      (0.21)      (0.24)   
    ## nse_3          0.46 *     -0.04        0.49        0.45        0.21    
    ##               (0.23)      (0.44)      (0.27)      (0.27)      (0.31)   
    ## risk_1        -0.09       -0.71       -0.28       -0.38       -0.08    
    ##               (0.21)      (0.41)      (0.25)      (0.25)      (0.29)   
    ## risk_2         0.32        0.07        0.07       -0.17       -0.03    
    ##               (0.22)      (0.42)      (0.26)      (0.25)      (0.30)   
    ## par_z:nse_1    0.08        0.10        0.05        0.47 *      0.22    
    ##               (0.19)      (0.38)      (0.23)      (0.23)      (0.27)   
    ## par_z:nse_3    0.14       -0.36       -0.05        0.02       -0.22    
    ##               (0.20)      (0.39)      (0.23)      (0.23)      (0.27)   
    ## -----------------------------------------------------------------------
    ## R^2            0.04        0.02        0.03        0.08        0.09    
    ## Adj. R^2       0.01       -0.01        0.00        0.05        0.06    
    ## Num. obs.    234         234         234         234         234       
    ## =======================================================================
    ## *** p < 0.001; ** p < 0.01; * p < 0.05
