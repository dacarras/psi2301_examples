Preguntas foro 20210418
================

# Abrir datos

``` r
#------------------------------------------------------------------------------
# load data
#------------------------------------------------------------------------------

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
data_desarollo <- psi2301::desarollo_psicomotor %>%
                  rename_all(tolower)
```

# Tabla de frecuencia

``` r
#------------------------------------------------------------------------------
# wide response table
#------------------------------------------------------------------------------

data_desarollo %>%
dplyr::select(a8com1:a8si6) %>%
r4sda::wide_resp(.) %>%
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

# Correlación item-test

``` r
#------------------------------------------------------------------------------
# comunicación
#------------------------------------------------------------------------------

data_desarollo %>%
dplyr::select(a8com1:a8com6) %>%
as.data.frame() %>%
CTT::itemAnalysis(.) %>%
purrr::pluck('itemReport') %>%
knitr::kable(., digits = 2)
```

| itemName | itemMean | pBis |  bis | alphaIfDeleted |
|:---------|---------:|-----:|-----:|---------------:|
| a8com1   |     9.72 | 0.37 | 0.74 |           0.55 |
| a8com2   |     9.55 | 0.16 | 0.29 |           0.59 |
| a8com3   |     7.87 | 0.36 | 0.44 |           0.52 |
| a8com4   |     8.88 | 0.43 | 0.64 |           0.49 |
| a8com5   |     8.41 | 0.22 | 0.29 |           0.59 |
| a8com6   |     8.88 | 0.47 | 0.72 |           0.46 |

``` r
#------------------------------------------------------------------------------
# motricidad gruesa
#------------------------------------------------------------------------------

data_desarollo %>%
dplyr::select(a8mamp1:a8mamp6) %>%
as.data.frame() %>%
CTT::itemAnalysis(.) %>%
purrr::pluck('itemReport') %>%
knitr::kable(., digits = 2)
```

| itemName | itemMean | pBis |  bis | alphaIfDeleted |
|:---------|---------:|-----:|-----:|---------------:|
| a8mamp1  |     8.66 | 0.50 | 0.71 |           0.68 |
| a8mamp2  |     8.24 | 0.44 | 0.60 |           0.69 |
| a8mamp3  |     4.31 | 0.44 | 0.52 |           0.70 |
| a8mamp4  |     8.48 | 0.43 | 0.61 |           0.69 |
| a8mamp5  |     8.52 | 0.45 | 0.62 |           0.69 |
| a8mamp6  |     5.45 | 0.53 | 0.62 |           0.66 |

``` r
#------------------------------------------------------------------------------
# motricidad fina
#------------------------------------------------------------------------------

data_desarollo %>%
dplyr::select(a8mfin1:a8mfin6) %>%
as.data.frame() %>%
CTT::itemAnalysis(.) %>%
purrr::pluck('itemReport') %>%
knitr::kable(., digits = 2)
```

| itemName | itemMean |  pBis |   bis | alphaIfDeleted |
|:---------|---------:|------:|------:|---------------:|
| a8mfin1  |     9.52 |  0.48 |  0.90 |           0.58 |
| a8mfin2  |     0.34 | -0.19 | -0.38 |           0.73 |
| a8mfin3  |     8.85 |  0.60 |  0.90 |           0.51 |
| a8mfin4  |     9.66 |  0.32 |  0.64 |           0.63 |
| a8mfin5  |     8.49 |  0.68 |  0.92 |           0.46 |
| a8mfin6  |     7.90 |  0.39 |  0.49 |           0.62 |

``` r
#------------------------------------------------------------------------------
# motricidad resolucion de problemas
#------------------------------------------------------------------------------

data_desarollo %>%
dplyr::select(a8rp1:a8rp6) %>%
as.data.frame() %>%
CTT::itemAnalysis(.) %>%
purrr::pluck('itemReport') %>%
knitr::kable(., digits = 2)
```

| itemName | itemMean | pBis |  bis | alphaIfDeleted |
|:---------|---------:|-----:|-----:|---------------:|
| a8rp1    |     9.78 | 0.28 | 0.64 |           0.66 |
| a8rp2    |     9.17 | 0.41 | 0.64 |           0.62 |
| a8rp3    |     9.43 | 0.52 | 0.95 |           0.59 |
| a8rp4    |     9.01 | 0.37 | 0.55 |           0.63 |
| a8rp5    |     7.89 | 0.44 | 0.56 |           0.61 |
| a8rp6    |     7.69 | 0.46 | 0.58 |           0.61 |

``` r
#------------------------------------------------------------------------------
# relaciones interpersonales
#------------------------------------------------------------------------------

data_desarollo %>%
dplyr::select(a8si1:a8si6) %>%
as.data.frame() %>%
CTT::itemAnalysis(.) %>%
purrr::pluck('itemReport') %>%
knitr::kable(., digits = 2)
```

| itemName | itemMean |  pBis |   bis | alphaIfDeleted |
|:---------|---------:|------:|------:|---------------:|
| a8si1    |     0.62 | -0.39 | -0.70 |           0.50 |
| a8si2    |     9.09 |  0.11 |  0.18 |           0.27 |
| a8si3    |     9.17 |  0.27 |  0.44 |           0.18 |
| a8si4    |     8.72 |  0.07 |  0.11 |           0.30 |
| a8si5    |     8.10 |  0.33 |  0.45 |           0.06 |
| a8si6    |     7.58 |  0.35 |  0.46 |           0.01 |

# Items Invertidos identificados

## Valores de digitación

``` text
- 10 puntos = Sí
-  5 puntos = A veces
-  0 puntos = No aún
```

## Nota sobre items invertidos

> NOTA IMPORTANTE: Para efectos de este taller, algunos ítems de las
> dimensiones del Ages and Stages fueron invertidos, esto es, se
> codificó Sí con 0 puntos, A veces con 5 y No aún con 0. Cuando se
> trabaje con los datos debería identificarse cuál es el ítem invertido
> y recodificarlo en forma correcta.

## Tabla de frecuencia con item invertidos

``` text
|variable |   00|   05|   10|   NA|hist     |
|:--------|----:|----:|----:|----:|:--------|
|a8com1   |   NA| 0.06| 0.94|   NA|▁▁▁▁▁▁▁▇ |
|a8com2   |   NA| 0.09| 0.90| 0.00|▁▁▁▁▁▁▁▇ |
|a8com3   | 0.06| 0.30| 0.64| 0.00|▁▁▁▃▁▁▁▇ |
|a8com4   | 0.07| 0.09| 0.84|   NA|▁▁▁▁▁▁▁▇ |
|a8com5   | 0.06| 0.20| 0.74| 0.00|▁▁▁▂▁▁▁▇ |
|a8com6   | 0.07| 0.08| 0.84| 0.00|▁▁▁▁▁▁▁▇ |
|a8mamp1  | 0.09| 0.10| 0.82|   NA|▁▁▁▁▁▁▁▇ |
|a8mamp2  | 0.12| 0.12| 0.76| 0.01|▁▁▁▁▁▁▁▇ |
|a8mamp3  | 0.50| 0.14| 0.36| 0.00|▇▁▁▂▁▁▁▆ |
|a8mamp4  | 0.10| 0.11| 0.79|   NA|▁▁▁▁▁▁▁▇ |
|a8mamp5  | 0.09| 0.12| 0.79|   NA|▁▁▁▁▁▁▁▇ |
|a8mamp6  | 0.36| 0.19| 0.45| 0.00|▆▁▁▃▁▁▁▇ |
|a8mfin1  | 0.02| 0.05| 0.93|   NA|▁▁▁▁▁▁▁▇ |
|a8mfin2  | 0.94| 0.05| 0.01| 0.00|▇▁▁▁▁▁▁▁ | * item invertido
|a8mfin3  | 0.07| 0.10| 0.84|   NA|▁▁▁▁▁▁▁▇ |
|a8mfin4  | 0.01| 0.05| 0.94|   NA|▁▁▁▁▁▁▁▇ |
|a8mfin5  | 0.08| 0.15| 0.77| 0.00|▁▁▁▂▁▁▁▇ |
|a8mfin6  | 0.11| 0.20| 0.69|   NA|▁▁▁▂▁▁▁▇ |
|a8rp1    | 0.00| 0.04| 0.96|   NA|▁▁▁▁▁▁▁▇ |
|a8rp2    | 0.04| 0.09| 0.86| 0.01|▁▁▁▁▁▁▁▇ |
|a8rp3    | 0.04| 0.05| 0.92|   NA|▁▁▁▁▁▁▁▇ |
|a8rp4    | 0.05| 0.10| 0.85|   NA|▁▁▁▁▁▁▁▇ |
|a8rp5    | 0.10| 0.22| 0.68|   NA|▁▁▁▂▁▁▁▇ |
|a8rp6    | 0.14| 0.18| 0.68| 0.00|▂▁▁▂▁▁▁▇ |
|a8si1    | 0.91| 0.05| 0.04|   NA|▇▁▁▁▁▁▁▁ | * item invertido
|a8si2    | 0.06| 0.07| 0.87| 0.00|▁▁▁▁▁▁▁▇ |
|a8si3    | 0.06| 0.07| 0.88|   NA|▁▁▁▁▁▁▁▇ |
|a8si4    | 0.08| 0.12| 0.80| 0.00|▁▁▁▁▁▁▁▇ |
|a8si5    | 0.15| 0.08| 0.75| 0.02|▂▁▁▁▁▁▁▇ |
|a8si6    | 0.21| 0.06| 0.71| 0.02|▂▁▁▁▁▁▁▇ |
```

## Items invertidos

-   A8MFIN2: ¿Puede tomar un juguete pequeño y tenerlo en la palma de la
    mano, sujetándolo con los dedos?
-   A8SI2: Al estar delante de un espejo, ¿intenta tocar el espejo con
    las manos?

# Recodificación

``` r
#------------------------------------------------------------------------------
# load data
#------------------------------------------------------------------------------


library(dplyr)
data_recoded <- # abrir los datos
                psi2301::desarollo_psicomotor %>%
                # cambiar todos los nombres a minusculas
                # para facilitar la escritura de codigo
                rename_all(tolower) %>%
                # inversion de las respuestas de los items
                mutate(a8mfin2r = case_when(
                    a8mfin2 == 10 ~  0,
                    a8mfin2 ==  5 ~  5,
                    a8mfin2 ==  0 ~ 10
                    )) %>%
                mutate(a8si1r = case_when(
                    a8si1 == 10 ~  0,
                    a8si1 ==  5 ~  5,
                    a8si1 ==  0 ~ 10
                    )) %>%
                  dplyr::glimpse()
```

    ## Rows: 250
    ## Columns: 43
    ## $ x1         <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, …
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
    ## $ a8mfin2r   <dbl> 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8si1r     <dbl> 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, …
