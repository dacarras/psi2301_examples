tabla de descriptivos por grupo
================

# Pregunta: como generar una tabla de descriptivos por grupo

> Hola, espero que todxs estén bien. Vengo a preguntar la duda que salió
> en la ayudantía, sobre las tablas de cruce de las variables,
> incluyendo sus MTC y de dispersión. Al parecer, hay varios grupos que
> tuvimos problemas al hacer/entender la tabla y/o encontrar el código
> que permitiera hacer una tabla buena (visiblemente hablando) con los
> datos que se piden. Se agradecería mucho si nos pudieran aclarar y
> ayudar, por favor.

# Respuesta

Hola Paula, con los siguientes códigos vamos a generar tablas de
descriptivos empleando los datos de “desarollo\_psicomotor”. Hemos
incluido ahora las bases de datos de los trabajos, al interior de la
libreria `psi2301` de modo que sea más fácil producir ejemplos. En este
ejemplo, primer vamos a:

-   abrir los datos
-   inspeccionar los datos
-   preparar los datos
    -   emplear nombres en minuscula para facilitar la escritura de
        codigo
    -   invertir los items que se encuentran en reverso
        -   revisar la inversion de items
    -   crear puntajes de promedios de variables
-   crear tablas de descriptivos
    -   empleando `summarize()`, y generando tablas de n, medias y sd.

## Preparar datos

``` r
# -----------------------------------------------------------------------------
# abrir dplyr y los datos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# actualizar psi2301
# -----------------------------------------------

# credentials::set_github_pat()
# devtools::install_github("dacarras/psi2301", force = TRUE)

# -----------------------------------------------
# abrir datos
# -----------------------------------------------

library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
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
# descriptivo de 
# -----------------------------------------------

datos_desarollo %>%
  dplyr::select(a8com1:a8si6) %>%
  r4sda::wide_resp() %>%
  knitr::kable(., digits = 2)
```

    ## Loading required package: haven

    ## Loading required package: labelled

    ## Loading required package: sjlabelled

    ## 
    ## Attaching package: 'sjlabelled'

    ## The following objects are masked from 'package:labelled':
    ## 
    ##     copy_labels, remove_labels, to_character, to_factor, val_labels

    ## The following objects are masked from 'package:haven':
    ## 
    ##     as_factor, read_sas, read_spss, read_stata, write_sas, zap_labels

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     as_label

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

    ## # A tibble: 4 x 3
    ##   a8mfin2_raw a8mfin2     n
    ##         <dbl>   <dbl> <int>
    ## 1           0      10   234
    ## 2           5       5    13
    ## 3          10       0     2
    ## 4          NA      NA     1

``` r
dplyr::count(datos_desarollo, a8si1_raw, a8si1)
```

    ## # A tibble: 3 x 3
    ##   a8si1_raw a8si1     n
    ##       <dbl> <dbl> <int>
    ## 1         0    10   227
    ## 2         5     5    13
    ## 3        10     0    10

``` r
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
# inspeccionar base de datos creada
# -----------------------------------------------

datos_desarollo %>%
r4sda::variables_table() %>%
knitr::kable()
```

    ## Loading required package: purrr

    ## Loading required package: stringr

| variable     | type | values                        | labels                    |
|:-------------|:-----|:------------------------------|:--------------------------|
| nse          | dbl  | 2, 3, 1, 2, 3, 2, 3, 1, 2, 2… | === no variable label === |
| sex          | dbl  | 1, 2, 1, 1, 1, 1, 1, 1, 2, 1… | === no variable label === |
| edad\_gest   | dbl  | , 35, 31, 39, 28, 38, 42, 38… | === no variable label === |
| peso\_nac    | dbl  | 00, 1916, 2325, 2800, 1990, … | === no variable label === |
| edad\_emb\_n | dbl  | , 16, 28, 21, 29, 19, 22, 30… | === no variable label === |
| pad\_alim    | dbl  | 5, 1, 3, 5, 2, 5, 2, 4, 2, 3… | === no variable label === |
| pad\_jugar   | dbl  | 5, 5, 5, 5, 5, 5, 2, 4, 4, 5… | === no variable label === |
| pad\_dormir  | dbl  | 4, 5, 1, 4, 4, 3, 2, 4, 5, 5… | === no variable label === |
| pad\_mudar   | dbl  | 2, 3, 1, 3, 3, 5, 4, 3, 5, 5… | === no variable label === |
| pad\_med     | dbl  | 4, 4, 1, 5, 1, 2, 2, 4, 2, 3… | === no variable label === |
| a8com1       | dbl  | , 10, 10, 10, 10, 10, 10, 10… | === no variable label === |
| a8com2       | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8com3       | dbl  | , 5, 5, 10, 10, 10, 10, 10, … | === no variable label === |
| a8com4       | dbl  | 10, 10, 5, 10, 10, 10, 10, …  | === no variable label === |
| a8com5       | dbl  | 5, 10, 0, 10, 10, 5, 10, 5,…  | === no variable label === |
| a8com6       | dbl  | , 10, 5, 5, 10, 10, 10, 10, … | === no variable label === |
| a8mamp1      | dbl  | 0, 10, 10, 10, 10, 10, 10, …  | === no variable label === |
| a8mamp2      | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8mamp3      | dbl  | 0, 10, 10, 0, 10, 10, 0, 10…  | === no variable label === |
| a8mamp4      | dbl  | 10, 10, 10, 10, 10, 10, 5, 1… | === no variable label === |
| a8mamp5      | dbl  | , 10, 10, 10, 10, 5, 10, 10,… | === no variable label === |
| a8mamp6      | dbl  | 10, 10, 10, 0, 10, 10, 0, 10… | === no variable label === |
| a8mfin1      | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8mfin2      | dbl  | , 10, 10, 10, 10, 10, 10, 10… | === no variable label === |
| a8mfin3      | dbl  | 0, 10, 10, 10, 10, 10, 10, 1… | === no variable label === |
| a8mfin4      | dbl  | , 10, 10, 10, 10, 10, 10, 10… | === no variable label === |
| a8mfin5      | dbl  | 0, 10, 10, 10, 10, 10, 5, 10… | === no variable label === |
| a8mfin6      | dbl  | 5, 5, 10, 10, 5, 10, 5, 10, … | === no variable label === |
| a8rp1        | dbl  | 5, 10, 10, 10, 10, 10, 10, …  | === no variable label === |
| a8rp2        | dbl  | 0, 10, 10, 10, 10, 10, 10, 1… | === no variable label === |
| a8rp3        | dbl  | 10, 10, 10, 10, 10, 10, 5, …  | === no variable label === |
| a8rp4        | dbl  | 0, 5, 10, 10, 10, 5, 10, 5, … | === no variable label === |
| a8rp5        | dbl  | 10, 10, 10, 5, 10, 10, 5, 0…  | === no variable label === |
| a8rp6        | dbl  | , 10, 10, 10, 10, 5, 5, 10, … | === no variable label === |
| a8si1        | dbl  | 10, 10, 10, 10, 10, 10, 10,…  | === no variable label === |
| a8si2        | dbl  | , 0, 5, 5, 10, 5, 10, NA, 10… | === no variable label === |
| a8si3        | dbl  | 5, 10, 10, 10, 10, 10, 10, …  | === no variable label === |
| a8si4        | dbl  | 10, 10, 5, 10, 10, 10, 10, …  | === no variable label === |
| a8si5        | dbl  | , 10, 10, 10, 10, 10, 5, 10,… | === no variable label === |
| a8si6        | dbl  | 0, 10, 10, 10, 5, 10, NA, 10… | === no variable label === |
| a8mfin2\_raw | dbl  | 0, 0, 0, 0, 0, 0, 0, 0, 0, 0… | === no variable label === |
| a8si1\_raw   | dbl  | 0, 0, 0, 0, 0, 0, 10, 0, 10,… | === no variable label === |
| com          | dbl  | , 10.000000, 10.000000, 9.16… | === no variable label === |
| amp          | dbl  | 5.833333, 9.166667, 6.66666…  | === no variable label === |
| fin          | dbl  | 10.000000, 10.000000, 10.00…  | === no variable label === |
| pro          | dbl  | 10.000000, 9.166667, 10.0000… | === no variable label === |
| soc          | dbl  | 6.666667, 10.000000, 8.3333…  | === no variable label === |

## Producir tabla de descriptivos

``` r
# -----------------------------------------------------------------------------
# alternativa 3
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear tabla de descriptivos (medias y sd)
# -----------------------------------------------

# crear nse con valores interpretable para tabla
datos_desarollo <- datos_desarollo %>%
                   mutate(nse_group = case_when(
                     nse == 1 ~ 'alto',
                     nse == 2 ~ 'medio',
                     nse == 3 ~ 'bajo'
                   ))


# tabla de comunicación
table_com <- datos_desarollo %>%
               group_by(nse_group) %>%
               summarize(
                 n = n(),
                 media = mean(com, na.rm = TRUE),
                 desviacion = sd(com, na.rm = TRUE)
                 ) %>%
               mutate(variable = 'comunicación') %>%
               dplyr::select(nse_group, variable, n, media, desviacion)

# tabla de motricidad gruesa
table_amp <- datos_desarollo %>%
               group_by(nse_group) %>%
               summarize(
                 n = n(),
                 media = mean(amp, na.rm = TRUE),
                 desviacion = sd(amp, na.rm = TRUE)
                 ) %>%
               mutate(variable = 'movimientos amplios') %>%
               dplyr::select(nse_group, variable, n, media, desviacion)

# tabla con medias y sd
table_descriptives <- dplyr::bind_rows(table_com, table_amp)

# guardar a excel
openxlsx::write.xlsx(table_descriptives, 'tabla_descriptivos_1.xlsx')
```

## Tabla de descriptivos

-   Tabla de descriptivos:
    -   n = cantidad de casos
    -   media = promedio de variables
    -   desviacion = desviación estandar de variables
-   Cada uno de los descriptivos se produce para los diferentes grupos
    socioeconómicos (nse) presentes en el estudio.

| nse\_group | variable            |   n | media | desviacion |
|:-----------|:--------------------|----:|------:|-----------:|
| alto       | comunicación        |  50 |  9.27 |       1.10 |
| bajo       | comunicación        | 100 |  8.88 |       1.18 |
| medio      | comunicación        | 100 |  8.69 |       1.69 |
| alto       | movimientos amplios |  50 |  7.50 |       2.28 |
| bajo       | movimientos amplios | 100 |  7.39 |       2.20 |
| medio      | movimientos amplios | 100 |  7.03 |       2.65 |

Tabla 1: Descriptivos de comunicación y movimientos amplios por cada
grupo socioeconómico (nse\_group)
