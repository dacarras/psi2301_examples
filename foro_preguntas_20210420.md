Preguntas foro 20210420
================

# Códigos de R

## Ejemplos empleados en las slides

``` r
# -----------------------------------------------------------------------------
# object examples
# -----------------------------------------------------------------------------

# -----------------------------------------------
# lists
# -----------------------------------------------

# listas
lista_de_numeros <- c(1,2,3,4,5)
lista_de_numeros
```

    ## [1] 1 2 3 4 5

``` r
class(lista_de_numeros)
```

    ## [1] "numeric"

``` r
lista_de_letras <- c('a','b','c')
lista_de_letras
```

    ## [1] "a" "b" "c"

``` r
class(lista_de_letras)
```

    ## [1] "character"

``` r
lista_mixta <- c(1,'b',3,'d')
lista_mixta
```

    ## [1] "1" "b" "3" "d"

``` r
class(lista_mixta)
```

    ## [1] "character"

``` r
# -----------------------------------------------
# vector
# -----------------------------------------------

# vectores
vector_numerico <- c(1,2,3,4,5)
vector_numerico
```

    ## [1] 1 2 3 4 5

``` r
class(vector_numerico)
```

    ## [1] "numeric"

``` r
sequencia_numerica <- 1:5
sequencia_numerica
```

    ## [1] 1 2 3 4 5

``` r
class(sequencia_numerica)
```

    ## [1] "integer"

``` r
# -----------------------------------------------
# data
# -----------------------------------------------

# tabla de datos
tabla_de_datos <- read.table(text = "
index name
1     laura
2     raul
3     jimena
4     rodrigo
5     liliana
", header = TRUE
)

tabla_de_datos
```

    ##   index    name
    ## 1     1   laura
    ## 2     2    raul
    ## 3     3  jimena
    ## 4     4 rodrigo
    ## 5     5 liliana

``` r
class(tabla_de_datos)
```

    ## [1] "data.frame"

``` r
# -----------------------------------------------
# funcion y resultado
# -----------------------------------------------

# funcion y resultado
mean(c(1,2,3,4,5))
```

    ## [1] 3

``` r
# -----------------------------------------------
# funcion asignada
# -----------------------------------------------

# funcion asignada
media_de_vector <- mean(c(1,2,3,4,5))

# -----------------------------------------------
# funcion en una tabla
# -----------------------------------------------

# función que despliega una tabla
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
data.frame(
  n = length(c(1,2,3,4,5)),
  media = mean(c(1,2,3,4,5), na.rm = TRUE),
  desviacion = sd(c(1,2,3,4,5), na.rm = TRUE)
) %>%
knitr::kable(., digits = 2)
```

|   n | media | desviacion |
|----:|------:|-----------:|
|   5 |     3 |       1.58 |

``` r
# -----------------------------------------------
# exportar a excel
# -----------------------------------------------

# crear tabla y exportar a excel
tabla_descriptivos <- data.frame(
  n = length(c(1,2,3,4,5)),
  media = mean(c(1,2,3,4,5), na.rm = TRUE),
  desviacion = sd(c(1,2,3,4,5), na.rm = TRUE)
)
openxlsx::write.xlsx(tabla_descriptivos,'descriptivos.xlsx')


# -----------------------------------------------
# ejemplo de función aplicada
# -----------------------------------------------

# abrir datos
data_amistad <- psi2301::amistad_intergrupal

# crear una media
data_amistad$affo_score = with(data_amistad,
                          rowMeans(
                             cbind(affo1,affo2,affo3),
                             na.rm=TRUE)
                             )
# revisar media creada
data_amistad[1,c('affo1','affo2','affo3','affo_score')]
```

    ## # A tibble: 1 x 4
    ##   affo1 affo2 affo3 affo_score
    ##   <dbl> <dbl> <dbl>      <dbl>
    ## 1     7     3     7       5.67

``` r
# prueba de media
mean(c(7,3,7))
```

    ## [1] 5.666667

``` r
# -----------------------------------------------
# ejemplo de función con error
# -----------------------------------------------

# abrir datos
data_amistad <- psi2301::amistad_intergrupal

# crear media
data_amistad$affo_score=with(data_amistad,rowMeans(cbind(affo1,affo2,affo3,na.rm=TRUE)))

# revisar media creada
data_amistad[1,c('affo1','affo2','affo3','affo_score')]
```

    ## # A tibble: 1 x 4
    ##   affo1 affo2 affo3 affo_score
    ##   <dbl> <dbl> <dbl>      <dbl>
    ## 1     7     3     7        4.5

``` r
# prueba de media
mean(c(7,3,7))
```

    ## [1] 5.666667

``` r
# -----------------------------------------------
# ejemplo de función con error
# -----------------------------------------------

# abrir datos
data_amistad <- psi2301::amistad_intergrupal

# código que no se puede ejecutar
# data_amistad$affo_score=with(data_amistad,rowMeans(cbind(affo1,affo2,affo3,na.rm=true)))
data_amistad$affo_score=with(data_amistad,rowMeans(cbind(affo1,affo2,affo3,na.rm=TRUE)))

# revisar media creada
data_amistad[1,c('affo1','affo2','affo3','affo_score')]
```

    ## # A tibble: 1 x 4
    ##   affo1 affo2 affo3 affo_score
    ##   <dbl> <dbl> <dbl>      <dbl>
    ## 1     7     3     7        4.5

``` r
# prueba de media
mean(c(7,3,7))
```

    ## [1] 5.666667
