Preguntas foro 20210419
================

# Pregunta 20210419

> Hola, espero que todxs estén bien. Vengo a preguntar la duda que salió
> en la ayudantía, sobre las tablas de cruce de las variables,
> incluyendo sus MTC y de dispersión. Al parecer, hay varios grupos que
> tuvimos problemas al hacer/entender la tabla y/o encontrar el código
> que permitiera hacer una tabla buena (visiblemente hablando) con los
> datos que se piden. Se agradecería mucho si nos pudieran aclarar y
> ayudar, por favor.

# Respuesta

Hola Paula, con los siguientes codigos vamos a generar tablas de
descriptivos empleando los datos de “desarollo\_psicomotor”. Hemos
incluido ahora las bases de datos de los trabajos, al interiord de la
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
    -   alternativa 1: empleando `psych::describeBy()`
    -   alternativa 2: empleando `summarize()`, y generando tablas de n,
        medias y sd.
    -   alternativa 3: empleando `summarize()`, pero creando tablas de
        una sola medida, para diferentes variables
    -   alternativa 4: empleando `r4sda::get_desc()`, pero creando
        tablas de varias medidas por grupo de forma separada
    -   alternativa 5: empleando `r4sda::get_desc()`, y aprovechando la
        función `split`

> Nota: la **alternativa 1**, debiera ser la forma más intuitiva de
> seguir.

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
    ## $ nse        [3m[38;5;246m<dbl>[39m[23m 3, 3, 1, 3, 1, 3, 3, 2, 3, 1, 2, 3, 1, 2, 3, 2, 3, 1, 2, 2,…
    ## $ sex        [3m[38;5;246m<dbl>[39m[23m 2, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1,…
    ## $ edad_gest  [3m[38;5;246m<dbl>[39m[23m 37, 38, 40, NA, 42, 39, 34, 38, 35, 31, 39, 28, 38, 42, 38,…
    ## $ peso_nac   [3m[38;5;246m<dbl>[39m[23m 3195, 3470, 4360, NA, 3696, 3000, 1916, 2325, 2800, 1990, 3…
    ## $ edad_emb_n [3m[38;5;246m<dbl>[39m[23m 30, 31, 24, NA, 23, 31, 31, 41, 16, 28, 21, 29, 19, 22, 30,…
    ## $ pad_alim   [3m[38;5;246m<dbl>[39m[23m 3, 4, 1, 2, 4, 1, 2, 3, 3, 3, 5, 1, 3, 5, 2, 5, 2, 4, 2, 3,…
    ## $ pad_jugar  [3m[38;5;246m<dbl>[39m[23m 5, 4, 2, 5, 5, 3, 2, 4, 5, 5, 5, 5, 5, 5, 5, 5, 2, 4, 4, 5,…
    ## $ pad_dormir [3m[38;5;246m<dbl>[39m[23m 5, 5, 1, 3, 4, 2, 2, 3, 4, 5, 4, 5, 1, 4, 4, 3, 2, 4, 5, 5,…
    ## $ pad_mudar  [3m[38;5;246m<dbl>[39m[23m 5, 1, 4, 2, 4, 4, 4, 5, 2, 5, 2, 3, 1, 3, 3, 5, 4, 3, 5, 5,…
    ## $ pad_med    [3m[38;5;246m<dbl>[39m[23m 4, 3, 1, 1, 3, 1, 4, 5, 1, 1, 4, 4, 1, 5, 1, 2, 2, 4, 2, 3,…
    ## $ a8com1     [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8com2     [3m[38;5;246m<dbl>[39m[23m 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, …
    ## $ a8com3     [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 5, 5, 5, 5, 5, 5, 10, 10, 10, 10, 10, 0…
    ## $ a8com4     [3m[38;5;246m<dbl>[39m[23m 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, 1…
    ## $ a8com5     [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 0, 5, 10, 0, 10, 10, 5, 10, 5, …
    ## $ a8com6     [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 1…
    ## $ a8mamp1    [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, 0…
    ## $ a8mamp2    [3m[38;5;246m<dbl>[39m[23m 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, …
    ## $ a8mamp3    [3m[38;5;246m<dbl>[39m[23m 10, 5, 10, 0, 10, 0, 0, 10, 0, 0, 10, 10, 0, 10, 10, 0, 10,…
    ## $ a8mamp4    [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 5, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 10…
    ## $ a8mamp5    [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, …
    ## $ a8mamp6    [3m[38;5;246m<dbl>[39m[23m 5, 10, 10, 0, 5, 0, 10, 0, 0, 10, 10, 10, 0, 10, 10, 0, 10,…
    ## $ a8mfin1    [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, …
    ## $ a8mfin2    [3m[38;5;246m<dbl>[39m[23m 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ a8mfin3    [3m[38;5;246m<dbl>[39m[23m 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8mfin4    [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,…
    ## $ a8mfin5    [3m[38;5;246m<dbl>[39m[23m 5, 10, 0, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 10,…
    ## $ a8mfin6    [3m[38;5;246m<dbl>[39m[23m 5, 10, 5, 10, 10, 10, 10, 10, 5, 5, 10, 10, 5, 10, 5, 10, 5…
    ## $ a8rp1      [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8rp2      [3m[38;5;246m<dbl>[39m[23m 5, 10, 5, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 10, 10…
    ## $ a8rp3      [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10, 10, 10, 10, 5, 1…
    ## $ a8rp4      [3m[38;5;246m<dbl>[39m[23m 5, 10, 10, 10, 10, 10, 10, 5, 0, 5, 10, 10, 10, 5, 10, 5, 1…
    ## $ a8rp5      [3m[38;5;246m<dbl>[39m[23m 10, 5, 0, 10, 5, 10, 5, 5, 10, 10, 10, 10, 5, 10, 10, 5, 0,…
    ## $ a8rp6      [3m[38;5;246m<dbl>[39m[23m 10, 10, 5, 10, 10, 10, 0, 0, 0, 10, 10, 10, 10, 5, 5, 10, 0…
    ## $ a8si1      [3m[38;5;246m<dbl>[39m[23m 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 10, …
    ## $ a8si2      [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 10, 0, 5, 5, 10, 5, 10, NA, 10,…
    ## $ a8si3      [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 10, 10, 10, 10, 5, 5, 10, 10, 10, 10, 10, 10, 1…
    ## $ a8si4      [3m[38;5;246m<dbl>[39m[23m 10, 5, 10, 10, 10, 10, 10, 10, 10, 10, 5, 10, 10, 10, 10, 1…
    ## $ a8si5      [3m[38;5;246m<dbl>[39m[23m 5, 10, 10, 0, 10, 10, 5, 0, 10, 10, 10, 10, 10, 10, 5, 10, …
    ## $ a8si6      [3m[38;5;246m<dbl>[39m[23m 10, 10, 10, 0, 10, 0, 10, 0, 10, 10, 10, 10, 5, 10, NA, 10,…

``` r
# -----------------------------------------------
# descriptivo de 
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
                   mutate(soc = psi2301::mean_score(soc_items)) %>%
                   dplyr::glimpse()
```

    ## Rows: 250
    ## Columns: 47
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

# Tablas de descriptivos

-   La alternativa 1 debiera ser la más intuitiva de todas las opciones.
-   Las alternativas 3 a 5, son variantes que podrian ser utiles cuando
    las exigencias del problema a resolver, requiere de más opciones; y
    donde quieren más control sobre la tabla generada, y el objeto que
    con esta se genera. Estas alternativas se incluyen como
    ilustraciones.

## Tabla de Medias y SD con `summarize()`

``` r
# -----------------------------------------------------------------------------
# alternativa 1
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear tabla de descriptivos (medias y sd)
# -----------------------------------------------

psych::describeBy(amp + com ~ nse, data = datos_desarollo )
```

    ## 
    ##  Descriptive statistics by group 
    ## nse: 1
    ##     vars  n mean   sd median trimmed  mad  min max range  skew kurtosis   se
    ## amp    1 50 7.50 2.28   8.33    7.79 2.47 1.67  10  8.33 -0.82    -0.24 0.32
    ## com    2 50 9.27 1.10  10.00    9.48 0.00 5.83  10  4.17 -1.37     0.87 0.16
    ## ------------------------------------------------------------ 
    ## nse: 2
    ##     vars   n mean   sd median trimmed  mad min max range  skew kurtosis   se
    ## amp    1 100 7.03 2.65   7.50    7.35 2.47 0.0  10  10.0 -0.88     0.00 0.27
    ## com    2 100 8.69 1.69   9.17    9.03 1.24 2.5  10   7.5 -1.79     3.05 0.17
    ## ------------------------------------------------------------ 
    ## nse: 3
    ##     vars   n mean   sd median trimmed  mad  min max range  skew kurtosis   se
    ## amp    1 100 7.39 2.20   7.50    7.60 2.47 0.83  10  9.17 -0.74     0.13 0.22
    ## com    2 100 8.88 1.18   9.17    9.05 1.24 5.83  10  4.17 -0.98     0.18 0.12

## Tabla de Medias y SD con `summarize()`

``` r
# -----------------------------------------------------------------------------
# alternativa 2
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear tabla de descriptivos (medias y sd)
# -----------------------------------------------

# tabla de comunicación
table_com <- datos_desarollo %>%
               group_by(nse) %>%
               summarize(
                 n = n(),
                 media = mean(com, na.rm = TRUE),
                 desviacion = sd(com, na.rm = TRUE)
                 ) %>%
               mutate(variable = 'comunicación') %>%
               dplyr::select(nse, variable, n, media, desviacion)

# tabla de motricidad gruesa
table_amp <- datos_desarollo %>%
               group_by(nse) %>%
               summarize(
                 n = n(),
                 media = mean(amp, na.rm = TRUE),
                 desviacion = sd(amp, na.rm = TRUE)
                 ) %>%
               mutate(variable = 'movimientos amplios') %>%
               dplyr::select(nse, variable, n, media, desviacion)

# tabla con medias y sd
table_descriptives <- dplyr::bind_rows(table_com, table_amp)


# mostrar tabla
table_descriptives %>%
knitr::kable(., digits = 2)
```

| nse | variable            |   n | media | desviacion |
|----:|:--------------------|----:|------:|-----------:|
|   1 | comunicación        |  50 |  9.27 |       1.10 |
|   2 | comunicación        | 100 |  8.69 |       1.69 |
|   3 | comunicación        | 100 |  8.88 |       1.18 |
|   1 | movimientos amplios |  50 |  7.50 |       2.28 |
|   2 | movimientos amplios | 100 |  7.03 |       2.65 |
|   3 | movimientos amplios | 100 |  7.39 |       2.20 |

``` r
# guardar a excel
openxlsx::write.xlsx(table_descriptives, 'tabla_descriptivos_ejemplo.xlsx')
```

## Tabla de Medias y SD con `summarize()`

``` r
# -----------------------------------------------------------------------------
# alternativa 3
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear tabla de descriptivos (medias y sd)
# -----------------------------------------------

# tabla de medias
table_means <- datos_desarollo %>%
               group_by(nse) %>%
               summarize(
                 com = mean(com, na.rm = TRUE),
                 amp = mean(amp, na.rm = TRUE)
                 ) %>%
               tidyr::gather('variable','mean', -nse)

# tabla de sd
table_sd <- datos_desarollo %>%
               group_by(nse) %>%
               summarize(
                 com = sd(com, na.rm = TRUE),
                 amp = sd(amp, na.rm = TRUE)
                 ) %>%
               tidyr::gather('variable','sd', -nse)

# tabla con medias y sd
table_mean_sd <- dplyr::left_join(table_means,
                 table_sd, by = c('nse','variable'))


# mostrar tabla
table_mean_sd %>%
knitr::kable(., digits = 2)
```

| nse | variable | mean |   sd |
|----:|:---------|-----:|-----:|
|   1 | com      | 9.27 | 1.10 |
|   2 | com      | 8.69 | 1.69 |
|   3 | com      | 8.88 | 1.18 |
|   1 | amp      | 7.50 | 2.28 |
|   2 | amp      | 7.03 | 2.65 |
|   3 | amp      | 7.39 | 2.20 |

## Tabla de descriptivos con `r4sda::get_desc()`

``` r
# -----------------------------------------------------------------------------
# alternativa 4
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear tabla de descriptivos (medias y sd)
# -----------------------------------------------

# crear tablas por grupo primero
tabla_nse_1 <- datos_desarollo %>%
               dplyr::filter(nse == 1) %>%
               dplyr::select(com, amp) %>%
               r4sda::get_desc() %>%
               mutate(nse = 'alto') %>%
               dplyr::select(nse, var:hist)

tabla_nse_2 <- datos_desarollo %>%
               dplyr::filter(nse == 2) %>%
               dplyr::select(com, amp) %>%
               r4sda::get_desc() %>%
               mutate(nse = 'medio') %>%
               dplyr::select(nse, var:hist)

tabla_nse_3 <- datos_desarollo %>%
               dplyr::filter(nse == 3) %>%
               dplyr::select(com, amp) %>%
               r4sda::get_desc() %>%
               mutate(nse = 'bajo') %>%
               dplyr::select(nse, var:hist)

# unir y ordenar tablas
table_mean_sd <- dplyr::bind_rows(
                 tabla_nse_1,
                 tabla_nse_2,
                 tabla_nse_3) %>%
                 arrange(var)
                 

# mostrar tabla
table_mean_sd %>%
knitr::kable(., digits = 2)
```

| nse   | var | missing | complete |   n | mean |   sd |  min |  p25 | median |   p75 | max |  skew | kurt | hist     |
|:------|:----|--------:|---------:|----:|-----:|-----:|-----:|-----:|-------:|------:|----:|------:|-----:|:---------|
| alto  | amp |       0 |        1 |  50 | 7.50 | 2.28 | 1.67 | 6.04 |   8.33 |  9.17 |  10 | -0.84 | 2.87 | ▂▁▁▃▂▂▅▇ |
| medio | amp |       0 |        1 | 100 | 7.03 | 2.65 | 0.00 | 5.00 |   7.50 |  9.17 |  10 | -0.89 | 3.06 | ▁▂▁▃▂▅▅▇ |
| bajo  | amp |       0 |        1 | 100 | 7.39 | 2.20 | 0.83 | 5.83 |   7.50 |  9.17 |  10 | -0.75 | 3.20 | ▁▁▂▂▂▅▃▇ |
| alto  | com |       0 |        1 |  50 | 9.27 | 1.10 | 5.83 | 8.54 |  10.00 | 10.00 |  10 | -1.41 | 4.03 | ▁▁▁▁▂▁▂▇ |
| medio | com |       0 |        1 | 100 | 8.69 | 1.69 | 2.50 | 8.33 |   9.17 | 10.00 |  10 | -1.81 | 6.17 | ▁▁▁▁▁▁▂▇ |
| bajo  | com |       0 |        1 | 100 | 8.88 | 1.18 | 5.83 | 8.33 |   9.17 | 10.00 |  10 | -0.99 | 3.25 | ▁▁▁▂▅▁▆▇ |

## Tabla de descriptivos con `r4sda::get_desc()` y `split`

``` r
# -----------------------------------------------------------------------------
# alternativa 5
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear tabla de descriptivos (medias y sd)
# -----------------------------------------------

datos_desarollo %>%
dplyr::select(nse, com, amp) %>%
split(.$nse) %>%
purrr::map(~ r4sda::get_desc(.)) %>%
dplyr::bind_rows(., .id = 'nse') %>%
dplyr::filter(var != 'nse') %>%
arrange(var) %>%
knitr::kable(., digits = 2)
```

| nse | var | missing | complete |   n | mean |   sd |  min |  p25 | median |   p75 | max |  skew | kurt | hist     |
|:----|:----|--------:|---------:|----:|-----:|-----:|-----:|-----:|-------:|------:|----:|------:|-----:|:---------|
| 1   | amp |       0 |        1 |  50 | 7.50 | 2.28 | 1.67 | 6.04 |   8.33 |  9.17 |  10 | -0.84 | 2.87 | ▂▁▁▃▂▂▅▇ |
| 2   | amp |       0 |        1 | 100 | 7.03 | 2.65 | 0.00 | 5.00 |   7.50 |  9.17 |  10 | -0.89 | 3.06 | ▁▂▁▃▂▅▅▇ |
| 3   | amp |       0 |        1 | 100 | 7.39 | 2.20 | 0.83 | 5.83 |   7.50 |  9.17 |  10 | -0.75 | 3.20 | ▁▁▂▂▂▅▃▇ |
| 1   | com |       0 |        1 |  50 | 9.27 | 1.10 | 5.83 | 8.54 |  10.00 | 10.00 |  10 | -1.41 | 4.03 | ▁▁▁▁▂▁▂▇ |
| 2   | com |       0 |        1 | 100 | 8.69 | 1.69 | 2.50 | 8.33 |   9.17 | 10.00 |  10 | -1.81 | 6.17 | ▁▁▁▁▁▁▂▇ |
| 3   | com |       0 |        1 | 100 | 8.88 | 1.18 | 5.83 | 8.33 |   9.17 | 10.00 |  10 | -0.99 | 3.25 | ▁▁▁▂▅▁▆▇ |
