ANOVA y pruebas post hot
================

# Pregunta: problemas con Tukey despues de un ANOVA con correcciones

Hola Profe!! Aquí están los problemas:

1.  ¿Cómo hacemos una Post-Hoc a un ANOVA con corrección de Welch?
    Cuando tratamos de ejecutar TukeyHSD, R arroja: Error in
    UseMethod(“TukeyHSD”) : no applicable method for ‘TukeyHSD’ applied
    to an object of class “htest”

``` r
anova2 = oneway.test(RES_PROB ~ factor(NSE), data=d1, var.equal =FALSE)
anova2

#RES_PROB
TukeyHSD(anova2)
```

En internet dice que es por no usar la función aov, pero resulta que no
podemos usarla si no se cumple la homocedasticidad, como es el caso :c

2.  ¿Qué hacemos si no se cumple la normalidad? En dos variables hicimos
    un test de Shapiro que nos dice que no se cumple, y no sabemos qué
    hacer porque tenemos entendido que en estos casos ANOVA deja de ser
    una prueba adecuada, y en internet aparece que podemos hacer
    correcciones logarítmicas y cosas así que suenan terribles y que no
    hemos aprendido.

Le adjunto el rmd resumido para poder ver el problema y la base de
datos. Si quieres revisar el rmd tienes que ejecutar todos los códigos
que dejamos. Avísame cuando nos podemos juntar entre hoy y mañana;
nosotros tenemos toda la disponibilidad.

# Respuesta

Hay tres cosas que se pueden considerar, para evaluar este problema:

-   Evaluar si ANOVA es un modelo para trabajar sobre estos datos
-   Si ANOVA no es la mejor solución, identificar que otras alternativas
    hay
-   Finalmente, cómo responder al ejercicio del trabajo.

El primero consiste en evaluar si la prueba F es aplicable a los datos.
Si los datos empleados, no tienen grupos balanceados (mismo tamaño), no
tienen varianzas similares, y tienen una distribución asimétrico
(i.e. no-normal), a tal punto que los residuos del modelo no son
normales, entonces, mi conclusión seria que la prueba F no es una buena
solución para analizar ese tipo de datos.

Respecto a lo segundo, existen comparaciones, por ejemplo Games-Howell,
múltiples que son aplicables cuando los tamaños de los grupos, y los
tamaños de las varianzas son dispares, pero ciertos autores tienen dudas
de si esto aplica, cuando ademas las distribuciones son asimétricos
(i.e. *highly skewed*). Otra alternativa, es emplear pruebas no
paramétricas para abordar el problema (e.g., Kruskal-Wallis).

Como les indicara el ayudante, para el trabajo, basta con aplicar uno de
los procedimientos elegidos, y señalar las limitaciones que estos
resultados poseen debido a el escenario que presentan los datos
empleados. Esto implica indicar la presencia de varianzas no similares
entre grupos, tamaños diferentes, y residuales no-normales.

En el siguiente código se inluyen ejemplos de: - aplicar ANOVA
tradicional - aplicar ANOVA con corrección de Welch - y luego
Games-Howell post hoc - un ejemplo de una aplicación de Kruskal-Walli.

# Código

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
# listado de putajes generados
# -----------------------------------------------

# com = comunicación
# amp = motricidad gruesa
# fin = motricidad fina
# pro = resolucion de problemas
# soc = socio individual (relaciones interpersonales)

# -----------------------------------------------
# crear tabla grupos nse como texto
# -----------------------------------------------

# crear nse con valores texto
datos_desarollo <- datos_desarollo %>%
                   mutate(nse_group = case_when(
                     nse == 1 ~ 'alto',
                     nse == 2 ~ 'medio',
                     nse == 3 ~ 'bajo'
                   ))

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
| nse\_group   | chr  | , “alto”, “bajo”, “bajo”, "m… | === no variable label === |

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
                 n = sum(!is.na(com)),
                 media = mean(com, na.rm = TRUE),
                 desviacion = sd(com, na.rm = TRUE)
                 ) %>%
               mutate(variable = 'comunicación') %>%
               dplyr::select(nse_group, variable, n, media, desviacion)

# tabla de motricidad gruesa
table_amp <- datos_desarollo %>%
               group_by(nse_group) %>%
               summarize(
                 n = sum(!is.na(com)),
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
    -   n = cantidad de casos con observaciones validas en la variable
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

# ANOVA

## Caso 1: Residuales no normales, y varianzas no equivalentes

``` r
# -----------------------------------------------------------------------------
# traditional anova
# -----------------------------------------------------------------------------

# -----------------------------------------------
# crear tabla de descriptivos (medias y sd)
# -----------------------------------------------

aov(pro ~ as.factor(nse), data = datos_desarollo)
```

    ## Call:
    ##    aov(formula = pro ~ as.factor(nse), data = datos_desarollo)
    ## 
    ## Terms:
    ##                 as.factor(nse) Residuals
    ## Sum of Squares         15.8071  624.7753
    ## Deg. of Freedom              2       247
    ## 
    ## Residual standard error: 1.590426
    ## Estimated effects may be unbalanced

``` r
# -----------------------------------------------
# normality
# -----------------------------------------------

anova_model <- lm(pro ~ as.factor(nse), data = datos_desarollo)
shapiro.test(residuals(anova_model))
```

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  residuals(anova_model)
    ## W = 0.78224, p-value < 2.2e-16

``` r
# -----------------------------------------------
# homocesdasticity
# -----------------------------------------------

# test 1
car::leveneTest(
  pro ~ as.factor(nse), 
  data = datos_desarollo, 
  center = 'mean')
```

    ## Levene's Test for Homogeneity of Variance (center = "mean")
    ##        Df F value   Pr(>F)   
    ## group   2  6.9444 0.001164 **
    ##       247                    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
# test 2
bartlett.test(pro ~ as.factor(nse), data = datos_desarollo)
```

    ## 
    ##  Bartlett test of homogeneity of variances
    ## 
    ## data:  pro by as.factor(nse)
    ## Bartlett's K-squared = 29.046, df = 2, p-value = 4.928e-07

``` r
# -----------------------------------------------
# n balance
# -----------------------------------------------

dplyr::count(datos_desarollo, nse)
```

    ## # A tibble: 3 x 2
    ##     nse     n
    ##   <dbl> <int>
    ## 1     1    50
    ## 2     2   100
    ## 3     3   100

``` r
# -----------------------------------------------
# multiple comparison ignoring assumptions
# -----------------------------------------------

anova_example <- aov(pro ~ as.factor(nse), data = datos_desarollo)
TukeyHSD(anova_example)
```

    ##   Tukey multiple comparisons of means
    ##     95% family-wise confidence level
    ## 
    ## Fit: aov(formula = pro ~ as.factor(nse), data = datos_desarollo)
    ## 
    ## $`as.factor(nse)`
    ##            diff        lwr         upr     p adj
    ## 2-1 -0.66166667 -1.3112054 -0.01212791 0.0447748
    ## 3-1 -0.58333333 -1.2328721  0.06620542 0.0883509
    ## 3-2  0.07833333 -0.4520128  0.60867951 0.9353476

## Alternativas: Games-Howell Post Hoc Test

``` r
# -----------------------------------------------------------------------------
# Welch Anova
# -----------------------------------------------------------------------------

oneway.test(pro ~ as.factor(nse), data = datos_desarollo, var.equal = FALSE)
```

    ## 
    ##  One-way analysis of means (not assuming equal variances)
    ## 
    ## data:  pro and as.factor(nse)
    ## F = 5.3054, num df = 2.00, denom df = 147.31, p-value = 0.005958

``` r
# -----------------------------------------------
# bonferroni
# -----------------------------------------------

with(datos_desarollo, 
  pairwise.t.test(
    x = pro,
    g = as.factor(nse), 
    p.adjust.method="bonferroni")
  )
```

    ## 
    ##  Pairwise comparisons using t tests with pooled SD 
    ## 
    ## data:  pro and as.factor(nse) 
    ## 
    ##   1     2    
    ## 2 0.051 -    
    ## 3 0.106 1.000
    ## 
    ## P value adjustment method: bonferroni

``` r
# -----------------------------------------------
# Games-Howell Post Hoc Test via "userfriendlyscience"
# -----------------------------------------------

# devtools::install_github("matherion/userfriendlyscience", dependencies=TRUE)

with(datos_desarollo,
userfriendlyscience::posthocTGH(
  y=pro,
  x=as.factor(nse))
)
```

    ## Registered S3 method overwritten by 'GGally':
    ##   method from   
    ##   +.gg   ggplot2

    ## Registered S3 methods overwritten by 'lme4':
    ##   method                          from
    ##   cooks.distance.influence.merMod car 
    ##   influence.merMod                car 
    ##   dfbeta.influence.merMod         car 
    ##   dfbetas.influence.merMod        car

    ##     n means variances
    ## 1  50   9.3       1.1
    ## 2 100   8.7       4.0
    ## 3 100   8.8       1.8

    ## Registered S3 methods overwritten by 'ufs':
    ##   method                     from               
    ##   grid.draw.ggProportionPlot userfriendlyscience
    ##   pander.associationMatrix   userfriendlyscience
    ##   pander.dataShape           userfriendlyscience
    ##   pander.descr               userfriendlyscience
    ##   pander.normalityAssessment userfriendlyscience
    ##   print.CramersV             userfriendlyscience
    ##   print.associationMatrix    userfriendlyscience
    ##   print.confIntOmegaSq       userfriendlyscience
    ##   print.confIntV             userfriendlyscience
    ##   print.dataShape            userfriendlyscience
    ##   print.descr                userfriendlyscience
    ##   print.ggProportionPlot     userfriendlyscience
    ##   print.meanConfInt          userfriendlyscience
    ##   print.multiVarFreq         userfriendlyscience
    ##   print.normalityAssessment  userfriendlyscience
    ##   print.regrInfluential      userfriendlyscience
    ##   print.scaleDiagnosis       userfriendlyscience
    ##   print.scaleStructure       userfriendlyscience
    ##   print.scatterMatrix        userfriendlyscience

    ##       diff ci.lo  ci.hi    t  df   p
    ## 2-1 -0.662 -1.25 -0.071 2.65 147 .02
    ## 3-1 -0.583 -1.06 -0.105 2.90 120 .01
    ## 3-2  0.078 -0.49  0.645 0.33 173 .94

``` r
# -----------------------------------------------
# Games-Howell Post Hoc Test via "rstatix"
# -----------------------------------------------

# install.packages("rstatix")

rstatix::games_howell_test(
  data = datos_desarollo, 
  formula = pro ~ nse_group, 
  conf.level = 0.95, detailed = TRUE)
```

    ## # A tibble: 3 x 14
    ##   .y.   group1 group2    n1    n2 estimate conf.low conf.high    se statistic
    ## * <chr> <chr>  <chr>  <int> <int>    <dbl>    <dbl>     <dbl> <dbl>     <dbl>
    ## 1 pro   alto   bajo      50   100  -0.583    -1.06    -0.105  0.142     2.90 
    ## 2 pro   alto   medio     50   100  -0.662    -1.25    -0.0708 0.176     2.65 
    ## 3 pro   bajo   medio    100   100  -0.0783   -0.645    0.489  0.170     0.327
    ## # … with 4 more variables: df <dbl>, p.adj <dbl>, p.adj.signif <chr>,
    ## #   method <chr>

## Alternativas: Kruskal Wallis

``` r
# -----------------------------------------------------------------------------
# non parametric anova
# -----------------------------------------------------------------------------

# -----------------------------------------------
# kruskal wallis test
# -----------------------------------------------

kruskal.test(pro ~ nse_group,data = datos_desarollo)
```

    ## 
    ##  Kruskal-Wallis rank sum test
    ## 
    ## data:  pro by nse_group
    ## Kruskal-Wallis chi-squared = 8.7933, df = 2, p-value = 0.01232

``` r
# -----------------------------------------------
# post hoc
# -----------------------------------------------

FSA::dunnTest(pro ~ nse_group,data = datos_desarollo, method = 'bh')
```

    ## Registered S3 methods overwritten by 'FSA':
    ##   method       from
    ##   confint.boot car 
    ##   hist.boot    car

    ## Dunn (1964) Kruskal-Wallis multiple comparison

    ##   p-values adjusted with the Benjamini-Hochberg method.

    ##     Comparison         Z     P.unadj       P.adj
    ## 1  alto - bajo  2.960892 0.003067495 0.009202486
    ## 2 alto - medio  1.852672 0.063929329 0.095893994
    ## 3 bajo - medio -1.357286 0.174690284 0.174690284

# Anexos

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
