Prueba t
================

## Resumen

En este clase revisamos cuatro ejemplos de comparaciones de medias.
Todos estos ejemplos son realizados empleando la prueba t. Los dos
primeros cubren ejemplos de comparaciones de medias de una muestra, en
contraste a una media poblacional. Los siguientes ejemplos corresponden
a una prueba t de muestras independientes, y luego una prueba t para
comparación de muestras dependientes.

> Nota: Cada uno de los códigos incluidos en *chunks*, son redundantes
> entre sí, de modo que cada uno sea reproducible en sí mismo. Lo
> anterior quiere decir que, un usuario puede copiar y pegar todo el
> código de un solo *chunk*, y reproducirlo en su consola o syntax
> propio que quiera generar.

# Supuestos de una prueba t

-   La distribución muestral conforma a la distribución normal
    -   La distribución de diferencia de medias conforma a la normal; no
        lo puntajes observados.
-   Los puntajes sometidos al análisis, tienen que al menos estar en una
    escala intervalar.
-   Para la prueba de muestras independientes, los puntajes deben
    provenir de tratamientos independientes
-   Equivalencia de las varianzas
    -   Existen correcciones para escenarios de varianzas no similares
        entre grupos.

> Nota: supuestos enlistados en Field, Miles & Field (2012, p 372).

# Pruebas t de una sola muestra

## Datos

Los datos empleados, provienen del estudio de International Civic and
Citizenship Education Study’
(<https://www.iea.nl/data-tools/repository/iccs>) de 2016 (ver Carrasco,
et al. 2020, para más detalles conceptuales).

-   corr = puntajes de tolerancia a la corrupcion, donde mayor puntaje
    indica mayor tolerancia a la corrupción (M = 50, SD = 10).
-   sof\_l = dictomización de puntajes conocimiento cívivo, entre el
    nivel mayor, y el resto de los niveles (1 = alta sofisticación
    política, 0 = baja sofisticación política).

## Prueba t para una muestra (n423)

``` r
#------------------------------------------------------------------------------
# t test for a single sample
#------------------------------------------------------------------------------

# -----------------------------------------------
# get data from tolerance of corruption
# -----------------------------------------------

url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_chl_16.rds'
data_corr <- readRDS(url(url_file))
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
# -----------------------------------------------
# get data from target group
# -----------------------------------------------

corr_0 <- data_corr %>%
          dplyr::filter(sof == 0) %>%
          dplyr::select(corr) %>%
          na.omit() %>%
          pull()


# -----------------------------------------------
# get number of observations
# -----------------------------------------------

n <- length(corr_0)

# -----------------------------------------------
# get degrees of freedom
# -----------------------------------------------

t_df <- n-1

# -----------------------------------------------
# compute t critical value
# -----------------------------------------------

t_critic <- qt(.975, df = t_df)
t_critic
```

    ## [1] 1.965601

``` r
# -----------------------------------------------
# compute t test
# -----------------------------------------------

t.test(x = corr_0,
       alternative = c("two.sided"),
       mu = 50, 
       paired = FALSE, 
       var.equal = FALSE,
       conf.level = 0.95)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  corr_0
    ## t = 3.6426, df = 422, p-value = 0.0003035
    ## alternative hypothesis: true mean is not equal to 50
    ## 95 percent confidence interval:
    ##  50.83271 52.78474
    ## sample estimates:
    ## mean of x 
    ##  51.80872

``` r
# -----------------------------------------------
# compute t test
# -----------------------------------------------

t_value <- t.test(x = corr_0,
           alternative = c("two.sided"),
           mu = 50, 
           paired = FALSE, 
           var.equal = FALSE,
           conf.level = 0.95) %>%
           broom::tidy() %>%
           dplyr::select(statistic) %>%
           pull() %>%
           abs() %>%
           as.numeric()

# -----------------------------------------------
# visualization of p value
# -----------------------------------------------

library(ggplot2)
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
  stat_function(fun = dt, args = list(df = t_df), geom = "area") +
  scale_x_continuous(breaks=seq(-3, 3, 1)) + 
  geom_vline(xintercept = t_value, color = 'red') +
  geom_vline(xintercept = - t_value, color = 'red') +
  geom_vline(xintercept = t_critic, color = 'red', linetype = 'dotted') +
  geom_vline(xintercept = - t_critic, color = 'red', linetype = 'dotted') +
  labs(
    x = 't scores', 
    y = 'density') +
  theme_minimal() +
  theme(
  panel.background = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank()
  )
```

![](clase_09_t_test_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
# -----------------------------------------------
# effect size as r coefficient
# -----------------------------------------------

sqrt(t_value^2/(t_value^2+t_df))
```

    ## [1] 0.1745947

## Prueba t para una muestra (n30)

``` r
#------------------------------------------------------------------------------
# t test for a single sample
#------------------------------------------------------------------------------

# -----------------------------------------------
# get data from tolerance of corruption
# -----------------------------------------------

url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_n60.rds'
data_corr_n60 <- readRDS(url(url_file))
library(dplyr)

# -----------------------------------------------
# get data from target group
# -----------------------------------------------

corr_0 <- na.omit(data_corr_n60[data_corr_n60$sof==0,'corr'])$corr %>%
          as.numeric()

# -----------------------------------------------
# get number of observations
# -----------------------------------------------

n <- length(corr_0)

# -----------------------------------------------
# get degrees of freedom
# -----------------------------------------------

t_df <- n-1

# -----------------------------------------------
# compute t critical value
# -----------------------------------------------

t_critic <- qt(.975, df = t_df)
t_critic
```

    ## [1] 2.04523

``` r
# -----------------------------------------------
# compute t test
# -----------------------------------------------

t.test(x = corr_0,
       alternative = c("two.sided"),
       mu = 50, 
       paired = FALSE, 
       var.equal = FALSE,
       conf.level = 0.95)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  corr_0
    ## t = -0.42118, df = 29, p-value = 0.6767
    ## alternative hypothesis: true mean is not equal to 50
    ## 95 percent confidence interval:
    ##  44.10700 53.88033
    ## sample estimates:
    ## mean of x 
    ##  48.99367

``` r
# -----------------------------------------------
# compute t test
# -----------------------------------------------

t_value <- t.test(x = corr_0,
           alternative = c("two.sided"),
           mu = 50, 
           paired = FALSE, 
           var.equal = FALSE,
           conf.level = 0.95) %>%
           broom::tidy() %>%
           dplyr::select(statistic) %>%
           pull() %>%
           abs() %>%
           as.numeric()

# -----------------------------------------------
# visualization of p value
# -----------------------------------------------

library(ggplot2)
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
  stat_function(fun = dt, args = list(df = t_df), geom = "area") +
  scale_x_continuous(breaks=seq(-3, 3, 1)) + 
  geom_vline(xintercept = t_value, color = 'red') +
  geom_vline(xintercept = - t_value, color = 'red') +
  geom_vline(xintercept = t_critic, color = 'red', linetype = 'dotted') +
  geom_vline(xintercept = - t_critic, color = 'red', linetype = 'dotted') +
  labs(
    x = 't scores', 
    y = 'density') +
  theme_minimal() +
  theme(
  panel.background = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank()
  )
```

![](clase_09_t_test_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
# -----------------------------------------------
# effect size as r coefficient
# -----------------------------------------------

sqrt(t_value^2/(t_value^2+t_df))
```

    ## [1] 0.07797364

# Pruebas t para dos muestras

# Datos

Los datos que analizaremos en este ejemplo provienen de Curran et al
(1997). Este estudio tiene medidas de consumo de alcohol, y de
antecedentes de alcoholismo de los entornos familiares de jovenes de 14
años. Los datos que analizaremos, son 82 casos que entregan respuestas a
los 14, 15 y 16 años. En particular, emplearemos los datos empleados por
Singer & Willet (2003), en el capitulo 4 de su libro (ver
<https://stats.idre.ucla.edu/other/examples/alda/>).

Las variables presentes en la base de datos que emplearemos son:

-   alcuse = escala de 8 puntos, de uso de alcohol (0 = nada, 7 = todos
    los días)
-   coa = antecentes de alcohol en los padres (1 = hijo de padre o
    padres alcoholicos, 0 = sin antecedentes de alcoholismo familiar).

## Pruebas t para dos muestras independientes

``` r
#------------------------------------------------------------------------------
# t test for a single sample
#------------------------------------------------------------------------------

# -----------------------------------------------
# get data from tolerance of corruption
# -----------------------------------------------

data_alcohol <- read.table("https://stats.idre.ucla.edu/stat/r/examples/alda/data/alcohol1_pp.txt", 
                header=TRUE, sep=",")
library(dplyr)

# ----------------------------------------------- 
# separate data per wave
# -----------------------------------------------

library(dplyr)
data_alc1 <- data_alcohol %>%
             dplyr::filter(age_14 == 0)

data_alc2 <- data_alcohol %>%
             dplyr::filter(age_14 == 1)

data_alc3 <- data_alcohol %>%
             dplyr::filter(age_14 == 2)

# -----------------------------------------------
# get number of observations
# -----------------------------------------------

n <- nrow(data_alc1)

# -----------------------------------------------
# get degrees of freedom
# -----------------------------------------------

t_df <- n-2

# -----------------------------------------------
# compute t critical value
# -----------------------------------------------

t_critic <- qt(.975, df = t_df)
t_critic
```

    ## [1] 1.990063

``` r
# ----------------------------------------------- 
# t test
# -----------------------------------------------

# t_test con formula
# variable_dependiente "condicionado por" variable_independiente

t.test(formula = alcuse ~ coa,
       data = data_alc1,
       alternative = c("two.sided"),
       mu = 0, 
       paired = FALSE, 
       var.equal = TRUE,
       conf.level = 0.95)
```

    ## 
    ##  Two Sample t-test
    ## 
    ## data:  alcuse by coa
    ## t = -3.9267, df = 80, p-value = 0.0001815
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -1.1358802 -0.3717854
    ## sample estimates:
    ## mean in group 0 mean in group 1 
    ##       0.2903221       1.0441549

``` r
# t_test con vectores por grupo
t.test(x = data_alc1[data_alc1$coa==0,'alcuse'], # sin alcoholismo familiar
       y = data_alc1[data_alc1$coa==1,'alcuse'], # con alcoholismo familiar
       data = data_alc1,
       alternative = c("two.sided"),
       mu = 0, 
       paired = FALSE, 
       var.equal = TRUE,
       conf.level = 0.95)
```

    ## 
    ##  Two Sample t-test
    ## 
    ## data:  data_alc1[data_alc1$coa == 0, "alcuse"] and data_alc1[data_alc1$coa == 1, "alcuse"]
    ## t = -3.9267, df = 80, p-value = 0.0001815
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -1.1358802 -0.3717854
    ## sample estimates:
    ## mean of x mean of y 
    ## 0.2903221 1.0441549

``` r
# t_test asumiendo otro valor de diferencia a la población
t.test(x = data_alc2[data_alc2$coa==0,'alcuse'], # sin alcoholismo familiar
       y = data_alc2[data_alc2$coa==1,'alcuse'], # con alcoholismo familiar
       data = data_alc2,
       alternative = c("two.sided"),
       mu = 1, 
       paired = FALSE, 
       var.equal = TRUE,
       conf.level = 0.95)
```

    ## 
    ##  Two Sample t-test
    ## 
    ## data:  data_alc2[data_alc2$coa == 0, "alcuse"] and data_alc2[data_alc2$coa == 1, "alcuse"]
    ## t = -7.5521, df = 80, p-value = 6.063e-11
    ## alternative hypothesis: true difference in means is not equal to 1
    ## 95 percent confidence interval:
    ##  -1.113273 -0.231808
    ## sample estimates:
    ## mean of x mean of y 
    ## 0.6601661 1.3327066

``` r
# -----------------------------------------------
# compute t test
# -----------------------------------------------

t_value <- t.test(formula = alcuse ~ coa,
           data = data_alc1,
           alternative = c("two.sided"),
           mu = 0, 
           paired = FALSE, 
           var.equal = TRUE,
           conf.level = 0.95) %>%
           broom::tidy() %>%
           dplyr::select(statistic) %>%
           pull() %>%
           abs() %>%
           as.numeric()

# -----------------------------------------------
# visualization of p value
# -----------------------------------------------

library(ggplot2)
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
  stat_function(fun = dt, args = list(df = t_df), geom = "area") +
  scale_x_continuous(breaks=seq(-3, 3, 1)) + 
  geom_vline(xintercept = t_value, color = 'red') +
  geom_vline(xintercept = - t_value, color = 'red') +
  geom_vline(xintercept = t_critic, color = 'red', linetype = 'dotted') +
  geom_vline(xintercept = - t_critic, color = 'red', linetype = 'dotted') +
  labs(
    x = 't scores', 
    y = 'density') +
  theme_minimal() +
  theme(
  panel.background = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank()
  )
```

![](clase_09_t_test_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
# -----------------------------------------------
# effect size as r coefficient
# -----------------------------------------------

sqrt(t_value^2/(t_value^2+t_df))
```

    ## [1] 0.4019831

# Pruebas t para dos muestras dependientes

## Sobre la estructura de datos en estudios longitudinales

Existen dos formas de construir bases de datos para estudios
longitudinales. Estos formatos reciben diversos nombres, uno de ellos es
el formato “stacked” y el otro es el formato “wide” (Hofman, 2015). En
el primer caso, se incluye una fila por cada ocasión de medición. De tal
manera, que si un estudio posee tres ocasiones, entonces un mismo caso
posee tres filas en la base de datos. Esto se vería de la siguiente
forma:

``` text
# datos en formato stacked

    id time  alcuse   
1    1    1  1.73
2    1    2  2.00
3    1    3  2.00
```

En contraste, los datos en forma “wide”, incluyen una sola fila por cada
sujeto. Además, este tipo de datos suprimen la información del tiempo, y
emplean tantas columnas como sea necesario para registrar los valores de
las medidas repetidas. Los datos anteriores, en formato “wide” se ven de
la siguiente forma.

``` text
# datos en formato wide

    id alc1  alc2  alc3
1    1 1.73  2.00  2.00

```

En las siguientes lineas de código se ilustra como aplicar una prueba t
para muestras dependientes, primero en formato **stacked**, y luego en
format **wide**.

## Pruebas t para dos muestras dependientes (datos en **stacked**)

``` r
#------------------------------------------------------------------------------
# t test for a single sample
#------------------------------------------------------------------------------

# -----------------------------------------------
# get data from tolerance of corruption
# -----------------------------------------------

data_alcohol <- read.table("https://stats.idre.ucla.edu/stat/r/examples/alda/data/alcohol1_pp.txt", 
                header=TRUE, sep=",")
library(dplyr)

# ----------------------------------------------- 
# separate data per wave
# -----------------------------------------------

library(dplyr)
data_alc1 <- data_alcohol %>%
             dplyr::filter(age_14 == 0)

data_alc2 <- data_alcohol %>%
             dplyr::filter(age_14 == 1)

data_alc3 <- data_alcohol %>%
             dplyr::filter(age_14 == 2)

data_paired <- dplyr::bind_rows(data_alc1, data_alc2)

# -----------------------------------------------
# get number of observations
# -----------------------------------------------

n <- nrow(data_paired)

# -----------------------------------------------
# get degrees of freedom
# -----------------------------------------------

t_df <- (n/2)-1

# -----------------------------------------------
# compute t critical value
# -----------------------------------------------

t_critic <- qt(.975, df = t_df)
t_critic
```

    ## [1] 1.989686

``` r
# ----------------------------------------------- 
# t test
# -----------------------------------------------

# t_test asumiendo varianzas equivalentes (homocedasticidad de varianzas)
t.test(formula = alcuse ~ age_14,
       data = data_paired,
       alternative = c("two.sided"),
       paired = TRUE, 
       var.equal = TRUE,
       conf.level = 0.95)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  alcuse by age_14
    ## t = -3.5468, df = 81, p-value = 0.0006517
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.5200632 -0.1462634
    ## sample estimates:
    ## mean of the differences 
    ##              -0.3331633

``` r
# t_test empleando vectores
t.test(x = data_paired[data_paired$age_14==0,'alcuse'], # sin alcoholismo familiar
       y = data_paired[data_paired$age_14==1,'alcuse'], # con alcoholismo familiar
       alternative = c("two.sided"),
       paired = TRUE, 
       var.equal = TRUE,
       conf.level = 0.95)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  data_paired[data_paired$age_14 == 0, "alcuse"] and data_paired[data_paired$age_14 == 1, "alcuse"]
    ## t = -3.5468, df = 81, p-value = 0.0006517
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.5200632 -0.1462634
    ## sample estimates:
    ## mean of the differences 
    ##              -0.3331633

``` r
# t_test asumiendo varianzas no equivalentes (heterocedasticidad de varianzas)
t.test(formula = alcuse ~ age_14,
       data = data_paired,
       alternative = c("two.sided"),
       paired = TRUE, 
       var.equal = FALSE,
       conf.level = 0.95)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  alcuse by age_14
    ## t = -3.5468, df = 81, p-value = 0.0006517
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.5200632 -0.1462634
    ## sample estimates:
    ## mean of the differences 
    ##              -0.3331633

``` r
# t_test "by default" asume varianzas no equivalentes, y 
#        prueba t de Welch
t.test(formula = alcuse ~ age_14,
       data = data_paired,
       alternative = c("two.sided"),
       paired = TRUE, 
#       var.equal = FALSE,
       conf.level = 0.95)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  alcuse by age_14
    ## t = -3.5468, df = 81, p-value = 0.0006517
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.5200632 -0.1462634
    ## sample estimates:
    ## mean of the differences 
    ##              -0.3331633

``` r
# -----------------------------------------------
# compared to a regression
# -----------------------------------------------

lm(alcuse ~ age_14, data = data_paired) %>%
broom::tidy() %>%
knitr::kable(., digits = 2)
```

| term        | estimate | std.error | statistic | p.value |
|:------------|---------:|----------:|----------:|--------:|
| (Intercept) |     0.63 |      0.11 |      5.74 |    0.00 |
| age\_14     |     0.33 |      0.16 |      2.14 |    0.03 |

``` r
# -----------------------------------------------
# compute t test
# -----------------------------------------------

data_paired %>%
group_by(age_14) %>%
summarize(
  mean = mean(alcuse, na.rm=TRUE),
  sd   = sd(alcuse, na.rm=TRUE),
  n    = n()
  ) %>%
knitr::kable(., digits = 2)
```

| age\_14 | mean |   sd |   n |
|--------:|-----:|-----:|----:|
|       0 | 0.63 | 0.94 |  82 |
|       1 | 0.96 | 1.05 |  82 |

``` r
# -----------------------------------------------
# compute t test
# -----------------------------------------------

t_value <- t.test(formula = alcuse ~ age_14,
           data = data_paired,
           alternative = c("two.sided"),
           paired = TRUE, 
           var.equal = TRUE,
           conf.level = 0.95) %>%
           broom::tidy() %>%
           dplyr::select(statistic) %>%
           pull() %>%
           abs() %>%
           as.numeric()

# -----------------------------------------------
# visualization of p value
# -----------------------------------------------

library(ggplot2)
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
  stat_function(fun = dt, args = list(df = t_df), geom = "area") +
  scale_x_continuous(breaks=seq(-3, 3, 1)) + 
  geom_vline(xintercept = t_value, color = 'red') +
  geom_vline(xintercept = - t_value, color = 'red') +
  geom_vline(xintercept = t_critic, color = 'red', linetype = 'dotted') +
  geom_vline(xintercept = - t_critic, color = 'red', linetype = 'dotted') +
  labs(
    x = 't scores', 
    y = 'density') +
  theme_minimal() +
  theme(
  panel.background = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank()
  )
```

![](clase_09_t_test_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
# -----------------------------------------------
# effect size as r coefficient
# -----------------------------------------------

sqrt(t_value^2/(t_value^2+t_df))
```

    ## [1] 0.366642

## Pruebas t para dos muestras dependientes (datos en **wide**)

``` r
#------------------------------------------------------------------------------
# t test for a single sample
#------------------------------------------------------------------------------

# -----------------------------------------------
# get data from tolerance of corruption
# -----------------------------------------------

data_alcohol <- read.table("https://stats.idre.ucla.edu/stat/r/examples/alda/data/alcohol1_pp.txt", 
                header=TRUE, sep=",")
library(dplyr)

# ----------------------------------------------- 
# separate data per wave
# -----------------------------------------------

library(dplyr)
data_w1 <- data_alcohol %>%
           dplyr::filter(age_14 == 0) %>%
           mutate(alcuse_1 = alcuse) %>%
           dplyr::select(id, alcuse_1)

data_w2 <- data_alcohol %>%
           dplyr::filter(age_14 == 1) %>%
           mutate(alcuse_2 = alcuse) %>%
           dplyr::select(id, alcuse_2)


data_wide <- dplyr::left_join(data_w1, data_w2, by = 'id')

# ----------------------------------------------- 
# t test
# -----------------------------------------------

# t_test asumiendo varianzas equivalentes (homocedasticidad de varianzas)
t.test(x = data_wide$alcuse_1,
       y = data_wide$alcuse_2,
       alternative = c("two.sided"),
       paired = TRUE, 
       var.equal = TRUE,
       conf.level = 0.95)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  data_wide$alcuse_1 and data_wide$alcuse_2
    ## t = -3.5468, df = 81, p-value = 0.0006517
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.5200632 -0.1462634
    ## sample estimates:
    ## mean of the differences 
    ##              -0.3331633

``` r
# t_test asumiendo varianzas no equivalentes (heterocedasticidad de varianzas)
t.test(x = data_wide$alcuse_1,
       y = data_wide$alcuse_2,
       alternative = c("two.sided"),
       paired = TRUE, 
       var.equal = FALSE,
       conf.level = 0.95)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  data_wide$alcuse_1 and data_wide$alcuse_2
    ## t = -3.5468, df = 81, p-value = 0.0006517
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.5200632 -0.1462634
    ## sample estimates:
    ## mean of the differences 
    ##              -0.3331633

## Comparación de resultados de las prueba t para datos en **stacked** y datos **wide**

A continuación se pegan los datos de consola sobre el texto, y se
muestra que se obtienen los mismos resultados para los datos en cada
formato empleado. Tanto los datos analizados en formato **stacked**, y
los datos en formato **wide**, producen los mismos resultados.

``` text
# ----------------------------------------------- 
# t test formato stacked
# -----------------------------------------------

> t.test(formula = alcuse ~ age_14,
+        data = data_paired,
+        alternative = c("two.sided"),
+        paired = TRUE, 
+        var.equal = TRUE,
+        conf.level = 0.95)

    Paired t-test

data:  alcuse by age_14
t = -3.5468, df = 81, p-value = 0.0006517
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.5200632 -0.1462634
sample estimates:
mean of the differences 
             -0.3331633 

# ----------------------------------------------- 
# t test formato wide
# -----------------------------------------------

> # t_test asumiendo varianzas equivalentes (homocedasticidad de varianzas)
> t.test(x = data_wide$alcuse_1,
+        y = data_wide$alcuse_2,
+        alternative = c("two.sided"),
+        paired = TRUE, 
+        var.equal = TRUE,
+        conf.level = 0.95)

    Paired t-test

data:  data_wide$alcuse_1 and data_wide$alcuse_2
t = -3.5468, df = 81, p-value = 0.0006517
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.5200632 -0.1462634
sample estimates:
mean of the differences 
             -0.3331633 
             
```

> Nota: cuando los datos se encuentran en **stacked** para que puedar
> ser analizados por la funcion t.test() asume que la longitud del
> vector de la primera y la segunda ocasión de medición tiene el mismo
> largo. Es decir, que si en el tiempo 1 hubo 40 casos, se espera que en
> el tiempo 2 tambien hayan 40 casos. En caso de que se observen datos
> perdidos entre las ocasiones de medición del estudio, la funcion
> t.test() requiere que ingresemos al análisis solo los casos que se
> encuentran en ambas ocasiones. Esto comúnmente se le llama “listwise”.
> En contraste, cuando los datos se encuentran en formato **wide**, la
> función t.test() aplica un “listwise”, y solo analiza a los datos que
> poseen observaciones tanto en el tiempo 1 como en el tiempo 2.

# Referencias

Carrasco, D., Banerjee, R., Treviño, E., & Villalobos, C. (2020). Civic
knowledge and open classroom discussion: explaining tolerance of
corruption among 8th-grade students in Latin America. Educational
Psychology, 40(2), 186–206.
<https://doi.org/10.1080/01443410.2019.1699907>

Curran, P. J., Stice, E., & Chassin, L. (1997). The relation between
adolescent alcohol use and peer alcohol use: A longitudinal random
coefficients model. Journal of Consulting and Clinical Psychology,
65(1), 130–140. <https://doi.org/10.1037/0022-006X.65.1.130>

Field, A., Miles, J., & Field, Z. (2012). Discovering Statistics using
R. SAGE Publications Ltd.

Hoffman, L. (2015). Longitudinal Analysis: Modeling Within-Person
Fluctuation and Change. Psychology Press.
<http://www.pilesofvariance.com/>

Singer, J. D., & Willett, J. B. (2003). Applied longitudinal data
analysis: modeling change and event occurrence. Oxford University Press.
