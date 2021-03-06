Contraste de hipótesis
================

## Resumen

En este clase revisamos dos ejemplos de comparaciones de medias. El
primero es empleando prueba Z de comparaciones de medias, y el segundo
es de prueba t para comparaciones de medias, para muestras dependientes.

En clases, el primer ejemplo se desarolla para ilustrar paso a paso, los
seis componentes más tradicionales que incluye el contraste de
hipótesis:

-   1.  Definir la hipótesis nula

-   2.  Establecer la hipótesis alternativa

-   3.  Seleccionar el nivel de significancia

-   4.  Recoger y resumir los datos de una muestra

-   5.  Definir el criterio para evaluar la evidencia

-   6.  Realizar una decisión respecto a rechazar o retener la hipótesis
        nula

El segundo ejemplo, fue mucho más resumido, donde se aplica directamente
una prueba t para muestras independientes, sobre datos diferentes.

En el presente documento se incluyen los códigos empleados, y ademas se
agrega un anexo final acerca de comparaciones de medias.

> Nota: Cada uno de los códigos incluidos en *chunks*, son redundantes
> entre sí, de modo que cada uno sea reproducible en sí mismo. Lo
> anterior quiere decir que, un usuario puede copiar y pegar todo el
> código de un solo *chunk*, y reproducirlo en su consola o syntax
> propio que quiera generar.

# Ejemplo 1

## Datos

Tomamos una muestra aleatoria, de la muestra representativa de
estudiantes del estudio “Estudio Internacional de Educación Cívica y
Formación Ciudadana“ (ICCS 2016)Ver:
<https://www.iea.nl/index.php/datatools/repository/iccs> Esta muestra
posee 501 estudiantes de octavo grado (14 años aprox), de Chile. Los
datos que emplearemos poseen puntajes de: - Tolerancia a la corrupcion
(corr, M=50, SD = 10) - Sofisticación Política (sof, 1=alta, 0 = media y
baja)

``` r
#------------------------------------------------------------------------------
# used data
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data
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
# variable table
# -----------------------------------------------

data_corr %>%
r4sda::variables_table() %>%
dplyr::select(variable, type, labels) %>%
knitr::kable(., digits = 2)
```

    ## Loading required package: purrr

    ## Loading required package: stringr

| variable | type | labels                                                                                           |
|:---------|:-----|:-------------------------------------------------------------------------------------------------|
| ctry     | chr  | país (CHL = Chile)                                                                               |
| corr     | dbl  | tolerancia a la corrupción (M = 50, SD = 10)                                                     |
| edu      | dbl  | educación de los padres (numérica) (1 = terciaria, 0 = no terciaria)                             |
| tert     | chr  | educación de los padres (text0) (tertiary, none-tertiary)                                        |
| sof      | dbl  | niveles de conocimiento cívico (numérico) (1 = alta sofisticación, 0 = menor sofisticación)      |
| sof\_l   | chr  | niveles de conocimiento cívico (text) (highest = alta sofisticación, else = menor sofisticación) |

## Estimados

``` r
#------------------------------------------------------------------------------
# statistics in tables
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------

url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_chl_16.rds'
data_corr <- readRDS(url(url_file))
library(dplyr)

# -----------------------------------------------
# generate descriptives tables
# -----------------------------------------------

# table for the total
table_null <- data_corr %>%
  summarize(
    mean = mean(corr, na.rm = TRUE),
    sd = sd(corr, na.rm = TRUE),
    n = n(),
    se = sd/sqrt(n),
    ll = mean - 1.96*se,
    ul = mean + 1.96*se
  )

# table for each group
table_groups <- data_corr %>%
  group_by(sof) %>%
  summarize(
    mean = mean(corr, na.rm = TRUE),
    sd = sd(corr, na.rm = TRUE),
    n = n(),
    se = sd/sqrt(n),
    ll = mean - 1.96*se,
    ul = mean + 1.96*se
  )

# joined table
table_desc <- dplyr::bind_rows(
              table_null, 
              table_groups
              ) %>%
              mutate(groups = c(
                'total',
                'menor',
                'mayor'
                ))

# -----------------------------------------------
# display table
# -----------------------------------------------

table_desc %>%
dplyr::select(groups, mean, sd, n, se, ll, ul) %>%
knitr::kable(., digits = 2)
```

| groups |  mean |    sd |   n |   se |    ll |    ul |
|:-------|------:|------:|----:|-----:|------:|------:|
| total  | 49.89 | 10.92 | 501 | 0.49 | 48.93 | 50.85 |
| menor  | 51.81 | 10.21 | 423 | 0.50 | 50.84 | 52.78 |
| mayor  | 39.49 |  8.52 |  78 | 0.96 | 37.59 | 41.38 |

> Nota: los intervalos de confianza incluidos en la última tabla son
> intervalos de confianza basados en la distribución z, y empleando la
> desviación estándar de cada grupo de la muestra de datos empleados.

Empleando los intervalos de confianza entre los grupos comparados, ya
tenemos evidencia de que las medias de cambos grupos son diferentes.
Esta conclusión se basa en que los intervalos de confianza de las medias
evaluadas no se solapan. Es decir, que el limite superior del grupo con
la media menor, no cruza los límites del limite inferior del grupo con
media mayor.

Podemos ilustrar este hecho, de que los intervalos de confianza no se
solapan, empleando el siguiente gráfico.

## Plot de medias e intervalo de confianza

``` r
#------------------------------------------------------------------------------
# statistics in tables
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------

url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_chl_16.rds'
data_corr <- readRDS(url(url_file))


# -----------------------------------------------
# summary statistics by group
# -----------------------------------------------

table_groups <- data_corr %>%
  group_by(sof) %>%
  summarize(
    mean = mean(corr, na.rm = TRUE),
    sd = sd(corr, na.rm = TRUE),
    n = n(),
    se = sd/sqrt(n),
    ll = mean - 1.96*se,
    ul = mean + 1.96*se
  )

# -----------------------------------------------
# plot comparing menas and confidence intervals
# -----------------------------------------------

library(ggplot2)
table_groups %>%
  mutate(sof_l = case_when(
    sof == 1 ~'alto',
    sof == 0 ~'bajo'
  )) %>%
ggplot(., aes(x=sof_l, y=mean, group=sof_l, color=sof_l)) + 
  geom_pointrange(aes(ymin=ll, ymax=ul)) +
  scale_colour_manual(values = c("bajo" = "red", "alto" = "black")) +
  ylim(30,70) +
  coord_flip() +
  labs(
    x = 'Sofisticación política',
    y = 'Tolerancia a la corrupción',
    color = 'Sofisticación política'
  ) +
  theme_bw()
```

![](clase_08_hipotesis_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

> Nota: la comparación de medias por medio de los intervalos de
> confianza coincide con las pruebas de comparaciones de medias en la
> mayoria de las veces. Sin embargo, esta regla visual tiende a ser *más
> robusta* o más exigente que una prueba estadística. De esta manera, es
> posible que uno llegara a la conclusión que no hay *diferencias
> significativas* entre las medias comparadas, empleando los intervalos
> de confianza. Sin embargo, una prueba de comparacion de medias, como
> una prueba t, o una prueba F, nos indicaría lo contrario: que si hay
> diferencias significativas.

## Prueba Z de comparación de medias

-   Esta prueba de comparacion de medias, es recomendable de utilizar
    cuando los tamaños de las muestras son muy grandes, y cuando tenemos
    disponible la medida de desviación estandar de la población, de la
    medida comparada.

-   Alternativamente, podemos emplear un estimado de la desviación
    estandar de la población. En el ejemplo presente seguimos esta ruta,
    y estimamos a partir de los datos de la muestra la desviación
    estandar de la población, segund los datos de cada grupo, empleando
    la corrección a la formula de desviación estándar.

``` r
#------------------------------------------------------------------------------
# z test for mean differences
#------------------------------------------------------------------------------

# -----------------------------------------------
# get data from tolerance of corruption
# -----------------------------------------------

url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_chl_16.rds'
data_corr <- readRDS(url(url_file))
library(dplyr)


corr_0 <- data_corr %>%
          dplyr::filter(sof == 0) %>%
          dplyr::select(corr) %>%
          na.omit() %>%
          pull()

corr_1 <- data_corr %>%
          dplyr::filter(sof == 1) %>%
          dplyr::select(corr) %>%
          na.omit() %>%
          pull()

# -----------------------------------------------
# standard deviation of the population estimate
# -----------------------------------------------

sd_pop <- function(x){
n <- length(na.omit(x))
sqrt((n-1)/n) * sd(x, na.rm = TRUE)
}

# -----------------------------------------------
# get stats
# -----------------------------------------------

m_0  <- mean(corr_0)
m_1  <- mean(corr_1)
sd_0 <- sd_pop(corr_0)
sd_1 <- sd_pop(corr_1)
n_0  <- length(corr_0)
n_1  <- length(corr_1)

# -----------------------------------------------
# create components for z equation
# -----------------------------------------------

mean_exp  <- 0
mean_diff <- m_1 - m_0
se <- sqrt((sd_0^2/n_0) + (sd_1^2/n_1))

# -----------------------------------------------
# compute z critical value
# -----------------------------------------------

z_critic <- qnorm(.975)
z_critic
```

    ## [1] 1.959964

``` r
# -----------------------------------------------
# compute z value
# -----------------------------------------------

z_value <- (mean_diff - mean_exp)/se
z_value
```

    ## [1] -11.41905

``` r
# -----------------------------------------------
# compute p value
# -----------------------------------------------

# options to see more decimals in console
options(scipen = 9999)
options(digits = 5)

# calculate p value
p_value <- 2*pnorm(-abs(z_value))
p_value
```

    ## [1] 0.0000000000000000000000000000033587

``` r
# -----------------------------------------------
# visualization of p value
# -----------------------------------------------

library(ggplot2)
ggplot(data.frame(x = c(-3, 3)), aes(x)) +
  stat_function(fun = dnorm, geom = "area") +
  scale_x_continuous(breaks=seq(-12, 12, 1)) + 
  geom_vline(xintercept = z_value, color = 'red') +
  geom_vline(xintercept = - z_value, color = 'red') +
  geom_vline(xintercept = z_critic, color = 'red', linetype = 'dotted') +
  geom_vline(xintercept = - z_critic, color = 'red', linetype = 'dotted') +
  labs(
    x = 'z scores', 
    y = 'density') +
  theme_minimal() +
  theme(
  panel.background = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank()
  )
```

![](clase_08_hipotesis_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
# -----------------------------------------------
# effect size
# -----------------------------------------------

psych::cohen.d(data_corr$corr, data_corr$sof,alpha=.05)
```

    ## Call: psych::cohen.d(x = data_corr$corr, group = data_corr$sof, alpha = 0.05)
    ## Cohen d statistic of difference between two means
    ##      lower effect upper
    ## [1,] -1.49  -1.24 -0.98
    ## 
    ## Multivariate (Mahalanobis) distance between groups
    ## [1] 1.2
    ## r equivalent of difference between two means
    ##  data 
    ## -0.41

``` r
# -----------------------------------------------
# compare z test with a pre-programmed routine
# -----------------------------------------------

BSDA::z.test(
  x=corr_0, 
  sigma.x=sd_0, 
  y=corr_1, 
  sigma.y=sd_1, 
  mu = 0,
  conf.level=0.95,
  alternative = 'two.sided'
  )
```

    ## 
    ##  Two-sample z-Test
    ## 
    ## data:  corr_0 and corr_1
    ## z = 11.4, p-value <0.0000000000000002
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  10.208 14.439
    ## sample estimates:
    ## mean of x mean of y 
    ##    51.809    39.485

``` r
# Note: install BSDA package first.
#       devtools::install_github('alanarnholt/BSDA')
```

# Ejemplo 2

## Datos

Tomamos una muestra aleatoria, de la muestra representativa de
estudiantes del estudio “Estudio Internacional de Educación Cívica y
Formación Ciudadana“ (ICCS 2016)Ver:
<https://www.iea.nl/index.php/datatools/repository/iccs> Esta muestra
posee 60 estudiantes de octavo grado (14 años aprox), de Chile, 30 casos
con alta sofisticación política, y 30 casos de baja sofisticación
política. Los datos que emplearemos poseen puntajes de: - Tolerancia a
la corrupcion (corr, M=50, SD = 10) - Sofisticación Política (sof,
1=alta, 0 = media y baja)

``` r
#------------------------------------------------------------------------------
# used data
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------

url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_n60.rds'
data_corr <- readRDS(url(url_file))
library(dplyr)

# -----------------------------------------------
# variable table
# -----------------------------------------------

data_corr %>%
r4sda::variables_table() %>%
dplyr::select(variable, type, labels) %>%
knitr::kable(., digits = 2)
```

| variable | type | labels                                                                                           |
|:---------|:-----|:-------------------------------------------------------------------------------------------------|
| ctry     | chr  | país (CHL = Chile)                                                                               |
| corr     | dbl  | tolerancia a la corrupción (M = 50, SD = 10)                                                     |
| edu      | dbl  | educación de los padres (numérica) (1 = terciaria, 0 = no terciaria)                             |
| tert     | chr  | educación de los padres (text0) (tertiary, none-tertiary)                                        |
| sof      | dbl  | niveles de conocimiento cívico (numérico) (1 = alta sofisticación, 0 = menor sofisticación)      |
| sof\_l   | chr  | niveles de conocimiento cívico (text) (highest = alta sofisticación, else = menor sofisticación) |

## Estimados

``` r
#------------------------------------------------------------------------------
# statistics in tables
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------

url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_n60.rds'
data_corr <- readRDS(url(url_file))
library(dplyr)


# -----------------------------------------------
# generate descriptives tables
# -----------------------------------------------

# table for the total
table_null <- data_corr %>%
  summarize(
    mean = mean(corr, na.rm = TRUE),
    sd = sd(corr, na.rm = TRUE),
    n = n(),
    se = sd/sqrt(n),
    ll = mean - 1.96*se,
    ul = mean + 1.96*se
  )

# table for each group
table_groups <- data_corr %>%
  group_by(sof) %>%
  summarize(
    mean = mean(corr, na.rm = TRUE),
    sd = sd(corr, na.rm = TRUE),
    n = n(),
    se = sd/sqrt(n),
    ll = mean - 1.96*se,
    ul = mean + 1.96*se
  )

# joined table
table_desc <- dplyr::bind_rows(
              table_null, 
              table_groups
              ) %>%
              mutate(groups = c(
                'total',
                'menor',
                'mayor'
                ))

# -----------------------------------------------
# display table
# -----------------------------------------------

table_desc %>%
dplyr::select(groups, mean, sd, n, se, ll, ul) %>%
knitr::kable(., digits = 2)
```

| groups |  mean |    sd |   n |   se |    ll |    ul |
|:-------|------:|------:|----:|-----:|------:|------:|
| total  | 45.80 | 12.17 |  60 | 1.57 | 42.72 | 48.88 |
| menor  | 48.99 | 13.09 |  30 | 2.39 | 44.31 | 53.68 |
| mayor  | 42.61 | 10.43 |  30 | 1.90 | 38.88 | 46.34 |

## Plot de medias e intervalo de confianza

``` r
#------------------------------------------------------------------------------
# statistics in tables
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------


url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_n60.rds'
data_corr <- readRDS(url(url_file))
library(dplyr)



# -----------------------------------------------
# summary statistics by group
# -----------------------------------------------

table_groups <- data_corr %>%
  group_by(sof) %>%
  summarize(
    mean = mean(corr, na.rm = TRUE),
    sd = sd(corr, na.rm = TRUE),
    n = n(),
    se = sd/sqrt(n),
    ll = mean - 1.96*se,
    ul = mean + 1.96*se
  )

# -----------------------------------------------
# plot comparing menas and confidence intervals
# -----------------------------------------------

library(ggplot2)
table_groups %>%
  mutate(sof_l = case_when(
    sof == 1 ~'alto',
    sof == 0 ~'bajo'
  )) %>%
ggplot(., aes(x=sof_l, y=mean, group=sof_l, color=sof_l)) + 
  geom_pointrange(aes(ymin=ll, ymax=ul)) +
  scale_colour_manual(values = c("bajo" = "red", "alto" = "black")) +
  ylim(30,70) +
  coord_flip() +
  labs(
    x = 'Sofisticación política',
    y = 'Tolerancia a la corrupción',
    color = 'Sofisticación política'
  ) +
  theme_bw()
```

![](clase_08_hipotesis_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

> Nota: la comparación de medias por medio de los intervalos de
> confianza coincide con las pruebas de comparaciones de medias en la
> mayoria de las veces. Sin embargo, esta regla visual tiende a ser *más
> robusta* o más exigente que una prueba estadística. De esta manera, es
> posible que uno llegara a la conclusión que no hay *diferencias
> significativas* entre las medias comparadas, empleando los intervalos
> de confianza. Este último gráfico, que emplea una muestra más pequeña
> de 60 casos, nos lleva a este escenario: los initervalos de confianza
> basados en la distribución Z, sugieren que no hay diferencias
> significativas. Antes de llegar a esta conclusión, revisemos los
> resultados de la prueba t, que se presenta a continuación.

## Prueba t de comparación de medias para muestras independientes

``` r
#------------------------------------------------------------------------------
# t test for mean differences
#------------------------------------------------------------------------------

# -----------------------------------------------
# get data from tolerance of corruption
# -----------------------------------------------

library(dplyr)
url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_n60.rds'
data_corr <- readRDS(url(url_file))

corr_0 <- data_corr %>%
          dplyr::filter(sof == 0) %>%
          dplyr::select(corr) %>%
          na.omit() %>%
          pull()

corr_1 <- data_corr %>%
          dplyr::filter(sof == 1) %>%
          dplyr::select(corr) %>%
          na.omit() %>%
          pull()

# -----------------------------------------------
# compute t critical value
# -----------------------------------------------

t_critic <- qt(.975, df = 60-2)
t_critic
```

    ## [1] 2.0017

``` r
# -----------------------------------------------
# t test for independent samples
# -----------------------------------------------

t.test(x = corr_0,
       y = corr_1,
       alternative = c("two.sided"),
       mu = 0, 
       paired = FALSE, 
       var.equal = FALSE,
       conf.level = 0.95)  
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  corr_0 and corr_1
    ## t = 2.09, df = 55.2, p-value = 0.041
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##   0.26101 12.50566
    ## sample estimates:
    ## mean of x mean of y 
    ##    48.994    42.610

``` r
# -----------------------------------------------
# visualization of p value
# -----------------------------------------------

library(ggplot2)
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
  stat_function(fun = dt, args = list(df = 60-2), geom = "area") +
  scale_x_continuous(breaks=seq(-3, 3, 1)) + 
  geom_vline(xintercept = 2.09, color = 'red') +
  geom_vline(xintercept = - 2.09, color = 'red') +
  geom_vline(xintercept = 2, color = 'red', linetype = 'dotted') +
  geom_vline(xintercept = - 2, color = 'red', linetype = 'dotted') +
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

![](clase_08_hipotesis_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
# -----------------------------------------------
# effect size
# -----------------------------------------------

psych::cohen.d(data_corr$corr, data_corr$sof,alpha=.05)
```

    ## Call: psych::cohen.d(x = data_corr$corr, group = data_corr$sof, alpha = 0.05)
    ## Cohen d statistic of difference between two means
    ##      lower effect upper
    ## [1,] -1.07  -0.55 -0.02
    ## 
    ## Multivariate (Mahalanobis) distance between groups
    ## [1] 0.55
    ## r equivalent of difference between two means
    ##  data 
    ## -0.26

> Nota: la prueba empleada no asume varianzas iguales entre los grupos,
> y aplica una corrección a los grados de libertad empleados por la
> prueba t convencional. Esta corrección es llamada
> “Welch-Satterthwaite”

# Anexos

En esta sección del documento, se agregan ejemplos de código que aluden
a diferentes preguntas planteadas en clases.

## Remover meta data

En clases, se comento un escenario en que los datos empleados, parecen
no ser reconocidos por la función empleada.

Diferentes librerias, manipulan objetos, los cuales son ciertos objetos
esperados, y no cualquier objeto. Estos objetos esperados pueden ser
vectores, tablas de datos, y algunos pueden admitir tablas de datos con
meta-data, entre otros objetos posibles. El detalle es que, cada
libreria define en su documentación que tipo de objeto espera.

Una manera de lidear con esta diferencia entre liberarías, es remover la
metada de los datos, antes de manipular los datos empleando una
libreria. En el siguiente código se incluye dos ejemplos de como aislar
los objetos de un conjunto de datos, antes de manipularlo con otro
paquete de funciones.

``` r
#------------------------------------------------------------------------------
# removing metadata 
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data from previous examples
# -----------------------------------------------

library(dplyr)
url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_chl_16.rds'
data_corr_n500 <- readRDS(url(url_file))


url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_n60.rds'
data_corr_n60 <- readRDS(url(url_file))


# -----------------------------------------------
# check if data has additional attirbutes
# -----------------------------------------------

attributes(data_corr_n60$corr)
```

    ## $label
    ## [1] "tolerancia a la corrupción (M = 50, SD = 10)"

``` r
# Los datos poseen attributis adicionales.

# -----------------------------------------------
# remove all labels
# -----------------------------------------------

data_no_labels <- data_corr_n60 %>%
                  dplyr::mutate(., across(everything(), as.vector))

attributes(data_no_labels$corr)
```

    ## NULL

## Aislar datos por grupos

Existen diferentes formas de aislar datos desde una base de datos. En
general, esto consite en “seleccionar” variables, y “filtrar” casos. En
clases hemos visto diferentes estrategias empleando `library(dplyr)`.
Varias de estas operaciones pueden ser realizadas en código base. A
continuación se agrega un ejemplo donde:

-   se emplea codigo base para aislar los vector de tolerancia a la
    corrupcion de cada grupo
-   se emplea la desviación estandar de la muestra para calcular z
-   se estima el intervalo de confianza de la diferencia de medias

``` r
#------------------------------------------------------------------------------
# statistics in tables
#------------------------------------------------------------------------------

library(dplyr)
url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_chl_16.rds'
data_corr_n500 <- readRDS(url(url_file))


url_file  <-'https://raw.github.com/dacarras/psi2301_examples/master/data/corr_n60.rds'
data_corr_n60 <- readRDS(url(url_file))


# -----------------------------------------------
# variable table
# -----------------------------------------------

corr_0 <- na.omit(data_corr_n60[data_corr_n60$sof==0,'corr'])$corr
corr_1 <- na.omit(data_corr_n60[data_corr_n60$sof==1,'corr'])$corr

# -----------------------------------------------
# get stats
# -----------------------------------------------

m_0  <- mean(corr_0)
m_1  <- mean(corr_1)
sd_0 <- sd(corr_0)
sd_1 <- sd(corr_1)
n_0  <- length(corr_0)
n_1  <- length(corr_1)

# -----------------------------------------------
# create components for z equation
# -----------------------------------------------

mean_exp  <- 0
mean_diff <- m_1 - m_0
se <- sqrt((sd_0^2/n_0) + (sd_1^2/n_1))

# -----------------------------------------------
# compute z critical value
# -----------------------------------------------

z_critic <- qnorm(.975)
z_critic
```

    ## [1] 1.96

``` r
# -----------------------------------------------
# compute z value
# -----------------------------------------------

z_value <- (mean_diff - mean_exp)/se
z_value
```

    ## [1] -2.0893

``` r
# -----------------------------------------------
# confidence interval of the mean difference
# -----------------------------------------------

ll <- abs(mean_diff) - 1.96*se
ul <- abs(mean_diff) + 1.96*se

c(ll, ul)
```

    ## [1]  0.39495 12.37171

``` r
# -----------------------------------------------
# compare z test with a pre-programmed routine
# -----------------------------------------------

BSDA::z.test(
  x=corr_0, 
  sigma.x=sd_0, 
  y=corr_1, 
  sigma.y=sd_1, 
  mu = 0,
  conf.level=0.95,
  alternative = 'two.sided'
  )
```

    ## 
    ##  Two-sample z-Test
    ## 
    ## data:  corr_0 and corr_1
    ## z = 2.09, p-value = 0.037
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##   0.39506 12.37160
    ## sample estimates:
    ## mean of x mean of y 
    ##    48.994    42.610
