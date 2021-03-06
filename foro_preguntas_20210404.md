Preguntas foro 20210404
================

# Pregunta 20210404\_1

> Hola! tratando de hacer el ejercicio 2 de la ayudantía 2, al ejecutar
> el código en la consola me sale “Error: se intenta usar un nombre de
> varible de longitud cero”. Limpié la consola, instalé todas las
> librerías de nuevo y el problema persiste. ¿Qué puedo hacer? :c

El código que no está funcionando es el siguiente:

``` r
dem_16 %>%
group_by(ctry) %>%
sumarize(
mean = mean (civ, na.rm = TRUE)) %>%
knitr::kable(.,digits = 2)
```

Si el código anterior es ejecutado, sin incluir nada más el resultado es
el siguiente:

``` text
dem_16 %>%
group_by(ctry) %>%
sumarize(
mean = mean (civ, na.rm = TRUE)) %>%
knitr::kable(.,digits = 2)
#> Error in dem_16 %>% group_by(ctry) %>% sumarize(mean = mean(civ, na.rm = TRUE)) %>% : could not find function "%>%"
```

Ahora, vamos a tratar de arreglarlo:

``` r
# abrir datos
dem_16 <- psi2301::dem_16

# cargar dplyr
library(dplyr)

dem_16 %>%
group_by(ctry) %>%
sumarize(
mean = mean (civ, na.rm = TRUE)) %>%
knitr::kable(.,digits = 2)
```

Al ejecutar el código como está, aun no funciona porque la función
`sumarize` esta mal escrita:

``` text
# abrir datos
dem_16 <- psi2301::dem_16

# cargar dplyr
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

dem_16 %>%
group_by(ctry) %>%
sumarize(
mean = mean (civ, na.rm = TRUE)) %>%
knitr::kable(.,digits = 2)
#> Error in sumarize(., mean = mean(civ, na.rm = TRUE)): could not find function "sumarize"
```

Este es nuestro segundo intento para arreglar el código inicial:

``` r
# abrir datos
dem_16 <- psi2301::dem_16

# cargar dplyr
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
dem_16 %>%
group_by(ctry) %>%
summarize(
mean = mean (civ, na.rm = TRUE)) %>%
knitr::kable(.,digits = 2)
```

| ctry               |   mean |
|:-------------------|-------:|
| Chile              | 481.76 |
| Colombia           | 480.35 |
| Dominican Republic | 381.90 |
| Mexico             | 474.20 |
| Peru               | 434.71 |

Ahora si funciona! En la versión original `sumarize` estaba con una sola
“m”, y requiere ser escrito con dos “m”, es decir como `summarize`.
