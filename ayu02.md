Ayudantía 2
================

# Ejercicios Ayudantía 1:

A continuación, se incluye los códigos de ejercicios empleados en la
ayudantía anterior.

``` r
# ---------------------------------------------------------
# ejercicio 1
# ---------------------------------------------------------

# excelente instancia para recordar que no es buena idea usar mayúsculas
# u otros nombres complejos

carlos <- 56
camila <- 54
fernanda <- 62
roberto <- 52
jacinta <- 60

# podemos ocupar códigos como a1, a2. Pero es importante que tengan
# algo para acordarse de quién es quien

# ---------------------------------------------------------
# ejercicio 2
# ---------------------------------------------------------

# para esto requiero utilizar la función c()

c("carlos", "camila", "fernanda", "roberto", "jacinta")
```

    ## [1] "carlos"   "camila"   "fernanda" "roberto"  "jacinta"

``` r
# esto genera un vector que contiene todos los valores pero
# falta la asignación de valores


est <- c("carlos", "camila", "fernanda", "roberto", "jacinta")

# ---------------------------------------------------------
# ejercicio 3
# ---------------------------------------------------------

notas <- c("56", "54", "62", "52", "60")

# ---------------------------------------------------------
# ejercicio 4
# ---------------------------------------------------------

# ¿Cómo podemos integrar ambos valores?
# En lo que determinamos como una base de datos
# donde cada fila corresponderá a una persona 
# y cada columna será una característica

psi <- cbind(est, notas)
psi
```

    ##      est        notas
    ## [1,] "carlos"   "56" 
    ## [2,] "camila"   "54" 
    ## [3,] "fernanda" "62" 
    ## [4,] "roberto"  "52" 
    ## [5,] "jacinta"  "60"

# Ayudantía 2: Introducción a estadística descriptiva

En la ayudantía anterior tuvimos nuestro primer acercamiento a R. Antes
de comenzar asegurate de tener los siguientes pasos listos:

1.  instalación de programa `R` y `Rstudio`
2.  instalación de librerías `tidyverse`, `remotes` y `psi2301`
3.  carpeta del curso para guardar tus archivos

Hoy en la ayudantía comenzaremos a ver Estadística Descriptiva. Para
aquello revisaremos y ejercitaremos la presentación de tablas y gráfica
de datos. Además, consideraremos contenidos relacionados a la teoría de
las escalas de medición de S.S. Stevens y los tipos de variables y
escalas de medición que se desprenden de dicha teoría.

A continuación, comenzaremos una serie de pasos que empezarás a
automatizar con el tiempo.

# Crear un documento

Luego de abrir nuestro software lo primero es crear un nuevo documento.
Para lograr esto, recuerda los pasos vistos en la ayudantía 1.

> Nota: “En la parte superior haremos click en la hoja y seleccionaremos
> el archivo en formato R Markdown”

# Formato R-Markdown

Tal cómo lo mencionamos en la ayudantía anterior, el formato R-Markdown
es un formato que permite integrar texto plano en formato markdown (para
ver más información del formato has click
[aquí](https://www.markdownguide.org/cheat-sheet/)) en conjunto con
espacios de codificación de código. En la secciones de texto plano a
través de la sintaxis de markdown podemos organizar nuestro texto de
manera sencilla (por ejemplo si deseamos colocar un título anteponemos
el signo `#`). La secciones de código se pueden generar a través de lo
que se denomina *chunk*. Este es una porción que permitirá utilizar R
dentro del archivo.

Los *chunks* pueden ser generados a través de comando (`control+alt+I`
en el caso de Windows y `Cmd+Option+I` en el caso de MacOS) o
directamente en la esquina superior en la barra de tareas del editor.

Esta estructura es la que estaremos utilizando durante todo el semestre.

# Instalación de librerías

Las librerías ya fueron instaladas en la ayudantía 1, y estos se
necesitan instalar sólo una vez (a menos que salgan actualizaciones).
Sin embargo, cada vez que sea necesario hacer uso de una librería, esta
debe ser “llamada” o “cargada” para emplear sus funciones en la sesión
de trabajo.

Por otro lado, la librería del curso, requiere ser “actualizada” sesión
a sesión, ya que constantemente estamos actualizando el contenido de
esta librería, para incluir más bases de datos para los diferentes
clases y ayudantías.

> Nota: Instalar y cargar las librerías es un paso muy importante. Si
> una librería no está cargada en la sesión, no es posible hacer uso de
> sus funciones, objetos y datos.

``` r
# ---------------------------------------------------------
# bajar libreria del curso
# ---------------------------------------------------------

# remotes::install_github('dacarras/psi2301', force = TRUE)
# el especificación force = TRUE asegura 
# que la librería vuelva se descargada y se actualice

# ---------------------------------------------------------
# instalar libraries para esta ayudantía
# ---------------------------------------------------------

# librerias para generar descriptivos de forma rápida
# install.packages('psych')
# install.packages('skimr')
# remotes::install_github('dacarras/r4sda')


# librería para generar plots de mosaico
# install.packages('ggmosaic')
```

# Cargar datos

Con cargar datos, nos referimos a la acción de poder abrir datos en un
sesión de R. En otros textos, esta acción puede ser descrita como:

-   abrir datos
-   importar datos
-   cargar datos
-   leer datos

En termimos generales, todas estas acciones refieren a la idea de que
los datos que queremos analizar constituyan un objeto tabla que podamos
manipular dentro de un paquete estadístico u otro software que nos
permita realizar calculos.

En diferentes ejemplos de ayudantía, cargaremos los datos desde la
libería del curso: `library(psi2301)`. No obstante, esta no es la única
manera de cargar datos en una sesión. También es posible leer datos
desde archivos Excel, CSV, TXT, entre otros formatos. De la misma
manera, es posible leer datos que provienen de otros paquetes
estadísticos como SAS, STATA y SPSS. Asi mismo, es posible guardar datos
en diferentes formatos (e.g., txt, csv, xlsx, sav, dta).

En terminos generales, todas las operaciones de lectura de archivos
siguen la siguiente forma:


    [nombre_del_objecto] <- libreria::funcion_de_lectura('[nombre_del_archivo]')

Un ejemplo de la operación anterior puede ser la siguiente. -
`iccs_data <- haven::read_sav('ICCS_MERGE.sav`).

En el ejemplo anterior, estamos empleando la libreria `haven`, y su
función `read_sav`, para abrir datos en formato SPSS en R.

## Abrir datos de una librería

A continuación cargaremos la librería del curso y la base de datos
llamada `dem_16`. Para ésto, se requiere que se encuentre instalada la
librería `psi2301`. Para cargar los datos de la librería del curso,
emplearemos la función `data()`. Con esta función, llamaremos a los
datos `dem_16`, de la sigiuente manera: `data(dem_16)`.

Una vez ejecutado el *chunk* en el “ambiente” o “environment” debe
aparecer el nombre de la base de datos, el numero total de observaciones
y cantidad de variables.

``` r
#------------------------------------------------------------------------------
# abrir datos
#------------------------------------------------------------------------------

# ---------------------------------------------------------
# cargar libreria del curso
# ---------------------------------------------------------

library(psi2301)

# ---------------------------------------------------------
# cargar datos
# ---------------------------------------------------------

data(dem_16)

# ---------------------------------------------------------
# ver 10 primeras filas del objeto
# ---------------------------------------------------------

dem_16[1:10, ]
```

    ##    id_i  ctry sex   age dem  dem_group   aut    civ   ses edu level level_lab
    ## 1  8093 Chile   1 13.50   2    complex 42.55 514.89 -0.19   0     2   level 2
    ## 2  9243 Chile   0 13.83   3    limited 57.94 334.68 -0.56   0     0   level 0
    ## 3  7484 Chile   0 14.17   3    limited 17.67 527.46 -0.23   0     2   level 2
    ## 4  7187 Chile   0 14.50   2    complex 17.67 612.81 -0.81   0     3   level 3
    ## 5  9208 Chile   1 13.42   1 minimalist 38.07 479.65 -0.17   0     2   level 2
    ## 6  6863 Chile   1 13.33   2    complex 47.94 556.01  1.08   1     2   level 2
    ## 7  8736 Chile   0 13.92   3    limited 59.24 548.08 -1.03   0     2   level 2
    ## 8  9067 Chile   1 13.42   2    complex 51.06 391.79 -0.54   0     0   level 0
    ## 9  9691 Chile   0 14.25   3    limited 27.06 530.32  0.01   0     2   level 2
    ## 10 7096 Chile   1 14.25   1 minimalist 49.54 481.76  0.50   0     2   level 2

``` r
# Nota: agregamos [1:10, ], de modo que solo muestre
#       las primeras 10 filas. De lo contrario nos mostraría
#       toda la tabla de datos, la cual posee 2500 filas.
```

Una forma alternativa de abrir los datos de una librería, consiste en
llamar al objeto dentro de la librería. Esta forma, requiere que el
usuario, conozca de antemano el nombre de los datos que quiere cargar en
sesión. Esta forma de abrir datos, emplea la siguiente estructura de
código `libreria::nombre_datos`.

``` r
#------------------------------------------------------------------------------
# abrir datos
#------------------------------------------------------------------------------

# ---------------------------------------------------------
# cargar datos de una librería y ver objeto
# ---------------------------------------------------------

psi2301::dem_16[1:10, ]
```

    ##    id_i  ctry sex   age dem  dem_group   aut    civ   ses edu level level_lab
    ## 1  8093 Chile   1 13.50   2    complex 42.55 514.89 -0.19   0     2   level 2
    ## 2  9243 Chile   0 13.83   3    limited 57.94 334.68 -0.56   0     0   level 0
    ## 3  7484 Chile   0 14.17   3    limited 17.67 527.46 -0.23   0     2   level 2
    ## 4  7187 Chile   0 14.50   2    complex 17.67 612.81 -0.81   0     3   level 3
    ## 5  9208 Chile   1 13.42   1 minimalist 38.07 479.65 -0.17   0     2   level 2
    ## 6  6863 Chile   1 13.33   2    complex 47.94 556.01  1.08   1     2   level 2
    ## 7  8736 Chile   0 13.92   3    limited 59.24 548.08 -1.03   0     2   level 2
    ## 8  9067 Chile   1 13.42   2    complex 51.06 391.79 -0.54   0     0   level 0
    ## 9  9691 Chile   0 14.25   3    limited 27.06 530.32  0.01   0     2   level 2
    ## 10 7096 Chile   1 14.25   1 minimalist 49.54 481.76  0.50   0     2   level 2

``` r
# Nota: agregamos [1:10, ], de modo que solo muestre
#       las primeras 10 filas. De lo contrario nos mostraría
#       toda la tabla de datos, la cual posee 2500 filas.
```

# Inspeccionar los datos

Existen varias funciones con las que se pueden inspeccionar los datos. A
continuación se usará la forma especial `package::function()`, para
indicar que la función que le sigue pertenece a esa librería.

Entoces se nombra la librería `dplyr`, luego la función `glimpse` y
finalmente como siempre nombramos el objeto que queremos inspecionar. En
nuestro caso, este es la base de datos `dem_16`. En conjunto, el código
que emplearemos es `dplyr::glimpse(dem_16)`.

Observarás una vista previa de tu tabla indicando el número de filas
(2500), el número de columnas (12) y luego se indica la variable, el
tipo de variable y los valores de las observaciones.

``` r
# ---------------------------------------------------------
# inspeccionar datos
# ---------------------------------------------------------

library(psi2301)        # cargar la libreria
data(dem_16)            # cargar los datos
dplyr::glimpse(dem_16)  # inspeccionar los datos cargados
```

    ## Rows: 2,500
    ## Columns: 12
    ## $ id_i      <dbl> 8093, 9243, 7484, 7187, 9208, 6863, 8736, 9067, 9691, 7096, …
    ## $ ctry      <chr> "Chile", "Chile", "Chile", "Chile", "Chile", "Chile", "Chile…
    ## $ sex       <dbl> 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, …
    ## $ age       <hvn_lbll> 13.50, 13.83, 14.17, 14.50, 13.42, 13.33, 13.92, 13.42,…
    ## $ dem       <dbl> 2, 3, 3, 2, 1, 2, 3, 2, 3, 1, 1, 1, 1, 2, 3, 2, 1, 2, 2, 2, …
    ## $ dem_group <chr> "complex", "limited", "limited", "complex", "minimalist", "c…
    ## $ aut       <dbl> 42.55, 57.94, 17.67, 17.67, 38.07, 47.94, 59.24, 51.06, 27.0…
    ## $ civ       <hvn_lbll> 514.89, 334.68, 527.46, 612.81, 479.65, 556.01, 548.08,…
    ## $ ses       <hvn_lbll> -0.19, -0.56, -0.23, -0.81, -0.17, 1.08, -1.03, -0.54, …
    ## $ edu       <dbl> 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, …
    ## $ level     <dbl> 2, 0, 2, 3, 2, 2, 2, 0, 2, 2, 1, 0, 0, 2, 1, 2, 2, 3, 2, 3, …
    ## $ level_lab <chr> "level 2", "level 0", "level 2", "level 3", "level 2", "leve…

\# Gramática y sintaxis

Antes de empezar a trabajar es importante profundizar en la estructura y
forma de las instrucciones que se ejecutan en el programa `R`. La
mayoría de las funciones que utilizaremos durante el semestre están
alojadas bajo el universo del tidyverse. Basándose en la idea de poder
presentar un código que sea claro y rapídamente entendible la gramática
se presenta de manera secuencial. A través del operador lógico `%>%`,
llamado *pipe*, se busca expresar una secuencia de múltiples
operaciones.

Mediante este operador, se establece un flujo en el cuál se toma un
objeto y se ejecuta una acción, este genera un resultado y este
resultado será enviado a través del *pipe* a la siguiente instrucción y
así sucesivamente. De esta manera, podemos observar cada uno de los
pasos de nuestra función, permitiendonos revisar y mirar de manera
sencilla cuáles son los elementos que hay en nuestro proceso.

Este será un elemento que retomaremos e iremos revisando a medida que
utilicemos diferentes funciones.

# Tabla de las variables

Para obtener mayor información de nuestros datos vamos a producir una
tabla de nuestras variables. Para estos propósitos emplearemos la
librería `r4sda` y su función `variable_table`.

La librería `r4sda` contiene un conjunto de funciones para el análisis
de datos secundarios. La función `variable_table` aprovecha diferentes
funciones presentes en `dplyr` para mostrar de forma sintética, en una
tabla diferentes atributos que acompañan a una base de datos, tales como
el nombre de la variable, el tipo, una muestra de valores, y los
`labels` de cada variable. Los `labels` de cada variable refiere a
descripciones de cada campo de una base de datos, que quienes crean las
bases datos, incluyen como parte de su documentación. Esto permite a
otros usuarios, contar con información respecto a que información
contiene cada columna de una tabla de datos.

Para generar esta tabla de variables, realizaremos tres pasos. Primero,
vamos a llamar a la libreria `dplyr`, de modo de poder hacer uso del
operador `%>%`, llamado *pipe*. Tal como lo señalamos anteriormente,
estos operadores nos sirven para encadenar diferentes comandos en una
secuencia. En conjunto, sirven para simplificar un conjunto anidado de
instrucciones, sin necesidad de generar un objeto en cada uno de los
pasos de la secuencia. El segundo paso, consiste en aplicar la función
`r4sda::variables_table()`. Finalmente, el tercer paso consiste en
incluir el la función `kable()` de la librería `knitr`. Este último
paso, permite que la tabla generada, se despliegue como una tabla
estructurada en la consola.

En esa tabla se incluye: el nombre de la variable (variable), el tipo de
variable (type), una muestra de valores de cada variables (values), y
con una pequeña leyenda que describe a la variable (labels).

``` r
# -----------------------------------------------
# mostrar tabla de variables
# -----------------------------------------------

library(dplyr)                     # cargar dplyr
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
r4sda::variables_table(dem_16) %>% # crear tabla
knitr::kable()                     # darle formato a la tabla
```

    ## Loading required package: purrr

    ## Loading required package: stringr

| variable   | type      | values                        | labels                                                                                                            |
|:-----------|:----------|:------------------------------|:------------------------------------------------------------------------------------------------------------------|
| id\_i      | dbl       | 63, 8736, 9067, 9691, 7096, … | id único del caso                                                                                                 |
| ctry       | chr       | e“,”Chile“,”Chile“,”Chile…    | nombre del país                                                                                                   |
| sex        | dbl       | 1, 0, 0, 1, 0, 0, 1, 1, 1, …  | sexo del estudiante (0 = niño, 1 = niña)                                                                          |
| age        | hvn\_lbll | 13.42, 13.33, 13.92, 13.42,…  | edad del estudiante en años (media = 14.25, sd = .99                                                              |
| dem        | dbl       | 1, 1, 2, 3, 2, 1, 2, 2, 2, …  | perfil de concepciones de las democracia (1 = minimalista, 2 = complejo, 3 = limitado)                            |
| dem\_group | chr       | “complex”, “minimalist”, "c…  | perfil de concepciones de las democracia (en texto)                                                               |
| aut        | dbl       | 7, 47.94, 59.24, 51.06, 27.0… | creencias antidemocráticas (AUTGOV, media = 50, sd = 10)                                                          |
| civ        | hvn\_lbll | .81, 479.65, 556.01, 548.08,… | conocimiento cívico (PV1CVI, media = 500, sd = 100)                                                               |
| ses        | hvn\_lbll | -0.17, 1.08, -1.03, -0.54, …  | nivel socioecónomico (media = 0, sd = 1, en cada país                                                             |
| edu        | dbl       | 0, 0, 1, 0, 1, 1, 0, 0, 1, …  | educación de los padres (1 = educación universitaria, 0 = otro nivel educativo                                    |
| level      | dbl       | 0, 0, 2, 1, 2, 2, 3, 2, 3, …  | niveles de conocimiento cívico (numérico) (3 = alta sofisticación, 2 = medio, 1 = bajo, 0 = muy bajo              |
| level\_lab | chr       | “level 3”, “level 2”, "leve…  | niveles de conocimiento cívico (Level 3 = alta sofisticación, Level 2 = medio, Level 1 = bajo, Level 0 = muy bajo |

# Manipulación básica de variables

Existen dos manipulaciones muy básicas en el manejo de tablas. Una de
ellas consiste en seleccionar variables, o en otra palabras, seleccionar
columnas. Y la otra consiste en filtrar casos o filtrar filas. Estas
operaciones pueden ser realizadas empleando funciones de `dplyr`, como
`dplyr::select()` y `dplyr::filter`. Adicionalmente, estas mismas
operaciones pueden ser realizadas empleando operaciones de `base`. A
continuación se presentan algunos ejemplos:

``` r
#------------------------------------------------------------------------------
# seleccionar y filtrar casos
#------------------------------------------------------------------------------


# -----------------------------------------------
# seleccionar variables
# -----------------------------------------------

library(dplyr) 
dem_16 %>%
dplyr::select(civ, ses) %>%
dplyr::glimpse()
```

    ## Rows: 2,500
    ## Columns: 2
    ## $ civ <hvn_lbll> 514.89, 334.68, 527.46, 612.81, 479.65, 556.01, 548.08, 391.7…
    ## $ ses <hvn_lbll> -0.19, -0.56, -0.23, -0.81, -0.17, 1.08, -1.03, -0.54, 0.01, …

``` r
# -----------------------------------------------
# seleccionar variables con base
# -----------------------------------------------

dem_16[,c('civ','ses')] %>%
dplyr::glimpse()
```

    ## Rows: 2,500
    ## Columns: 2
    ## $ civ <hvn_lbll> 514.89, 334.68, 527.46, 612.81, 479.65, 556.01, 548.08, 391.7…
    ## $ ses <hvn_lbll> -0.19, -0.56, -0.23, -0.81, -0.17, 1.08, -1.03, -0.54, 0.01, …

``` r
# Nota: base opera sobre las tablas, como si estas fueran matrices.
#       En esta lógica, por convención se asume lo siguiente:
#
#       tabla_de_datos[nombre_filas, nombre_columnas]
#
#       De este modo, si uno quiere recuperar el caso 5,
#       y su columna 2, uno puede escribir:
#
#       tabla_de_datos[5,1]

# -----------------------------------------------
# filtrar casos
# -----------------------------------------------

library(dplyr) 
dem_16 %>%
dplyr::filter(ctry == 'Colombia') %>%
dplyr::count(ctry)
```

    ## # A tibble: 1 x 2
    ##   ctry         n
    ##   <chr>    <int>
    ## 1 Colombia   500

``` r
# -----------------------------------------------
# filtrar casos con base
# -----------------------------------------------

dem_16[dem_16$ctry=='Colombia',] %>%
dplyr::count(ctry)
```

    ## # A tibble: 1 x 2
    ##   ctry         n
    ##   <chr>    <int>
    ## 1 Colombia   500

``` r
# -----------------------------------------------
# filtrar casos incluyendo más de un grupo
# -----------------------------------------------

library(dplyr) 
dem_16 %>%
dplyr::filter(ctry %in% c('Colombia','Chile')) %>%
dplyr::count(ctry)
```

    ## # A tibble: 2 x 2
    ##   ctry         n
    ##   <chr>    <int>
    ## 1 Chile      500
    ## 2 Colombia   500

``` r
# -----------------------------------------------
# filtrar casos incluyendo más de un grupo, en base
# -----------------------------------------------

dem_16[dem_16$ctry %in% c('Colombia','Chile'),] %>%
dplyr::count(ctry)
```

    ## # A tibble: 2 x 2
    ##   ctry         n
    ##   <chr>    <int>
    ## 1 Chile      500
    ## 2 Colombia   500

``` r
# -----------------------------------------------
# filtrar casos excluyendo un grupo
# -----------------------------------------------

library(dplyr) 
dem_16 %>%
dplyr::filter(!ctry == 'Chile') %>%
dplyr::count(ctry)
```

    ## # A tibble: 4 x 2
    ##   ctry                   n
    ##   <chr>              <int>
    ## 1 Colombia             500
    ## 2 Dominican Republic   500
    ## 3 Mexico               500
    ## 4 Peru                 500

``` r
# -----------------------------------------------
# filtrar casos excluyendo un grupo, en base
# -----------------------------------------------

dem_16[!dem_16$ctry=='Chile',] %>%
dplyr::count(ctry)
```

    ## # A tibble: 4 x 2
    ##   ctry                   n
    ##   <chr>              <int>
    ## 1 Colombia             500
    ## 2 Dominican Republic   500
    ## 3 Mexico               500
    ## 4 Peru                 500

A continuación seleccionaremos sólo algunas variables, de modo de dar
ejemplos de aplicación práctica de tipos de escalas de medición, así
como pedazos de códigos de cómo hacer tablas y descriptivos.

# Descriptivos

`R` es un entorno estadístico, con el cual podemos realizar diferentes
operaciones aritméticas y análisis estadísticos sobre datos. Existen
diferentes maneras, y librerías para obtener estadísticos descriptivos.
En esta ayudantía revisaremos las siguientes formas:

-   Cálculo de descriptivos sobre una columna de una base de datos
    (i.e. sobre un vector numérico)
-   Cálculo de descriptivos empleando `summary`
-   Cálculo de descriptivos empleando librerías que generan tablas
-   Cálculo de descriptivos empleando la función `summarize` de dplyr
-   Cálculo de descriptivos empleando la función `summarize` para
    diferentes grupos

## Descriptivos sobre vectores

Una columna dentro de una tabla de datos es un vector. Estos, los
podemos llamar en la sesión empleando el formato
`nombre_de_tabla$nombre_de_columna`. Esto es posible ya que si un objeto
contiene una base de datos, podemos observar la información de las
columnas que se encuentran en su interior añadiendo al final del objeto
el operador `$` y posteriormente el nombre de la columna. En el
siguiente código vamos a calcular los siguientes descriptivos:

-   longitud de un vector
-   mínimo de una variable
-   máximo de una variable
-   rango de una variable
-   media o promedio de una variable
-   desviación estándar
-   cuartiles de una variable

``` r
# -----------------------------------------------------------------------------
# diferentes estadísticos descriptivos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# cantidad de observaciones
# -----------------------------------------------

# longitud del vector
length(dem_16$civ)                 
```

    ## [1] 2500

``` r
# cantidad de valores perdidos
sum(is.na(dem_16$civ))
```

    ## [1] 0

``` r
# sin valores perdidos
sum(!is.na(dem_16$civ))
```

    ## [1] 2500

``` r
# Nota: !is.na() es una forma de obtener el inverso de is.na().

# -----------------------------------------------
# descriptivos
# -----------------------------------------------

min(dem_16$civ, na.rm = TRUE)      # mínimo
```

    ## [1] 88.26

``` r
max(dem_16$civ, na.rm = TRUE)      # máxmimo
```

    ## [1] 751.08

``` r
range(dem_16$civ, na.rm = TRUE)    # rango
```

    ## [1]  88.26 751.08

``` r
mean(dem_16$civ, na.rm = TRUE)     # media o promedio
```

    ## [1] 450.5827

``` r
sd(dem_16$civ, na.rm = TRUE)       # desviación estándar
```

    ## [1] 95.55647

``` r
# -----------------------------------------------
# cuartiles
# -----------------------------------------------

# Cuartiles Q1, Q2, Q3 (i.e. percentiles P25, P50, P75)
quantile(dem_16$civ, probs = .25, na.rm = TRUE) 
```

    ##     25% 
    ## 380.255

``` r
quantile(dem_16$civ, probs = .50, na.rm = TRUE) 
```

    ##     50% 
    ## 455.175

``` r
quantile(dem_16$civ, probs = .75, na.rm = TRUE) 
```

    ##      75% 
    ## 522.2025

## Descriptivos con `base::summary`

`R` posee una librería básica que se encuentra siempre carga en sesión.
Esta es la libreria `base`. Podemos llamar sus funciones de forma
específica, al igual que como llamamos funciones de otras librerías. Una
de estas funciones es `summary`, la cual es capaz de producir un
descriptivo general sobre una variable numérica. Debido a que esta
libreria se encuentra cargada en sesión por defecto, uno puede ejecutar
el comando `summary(data$variable)` o `base::summary(data$variable)` y
obtendríamos el mismo resultado.

``` r
# -----------------------------------------------------------------------------
# estadísticos descriptivos con base::summary
# -----------------------------------------------------------------------------

# -----------------------------------------------
# summary()
# -----------------------------------------------

summary(dem_16$civ)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   88.26  380.25  455.18  450.58  522.20  751.08

``` r
# -----------------------------------------------
# base::summary()
# -----------------------------------------------

base::summary(dem_16$civ)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   88.26  380.25  455.18  450.58  522.20  751.08

> Nota: la práctica de emplear el nombre de la librería y luego su
> función, en conjunto a `::` entre medio, es para evitar confusiones
> respecto a cual es la función que se está ejecutando. Debido a que R
> posee diversas librerías, y estas pueden incluir nombres de funciones
> repetidos, cuando dos librerías poseen funciones con el mismo estas
> pueden entrar en conflicto. Para evitar este tipo de problemas, una
> práctica que los evita es llamar las funciones que requerios en un
> paso, sin necesidad de abrir toda la librería.

## Descriptivos generados con librerías

Adicional a `base::summary` existen diferentes librerías que generan
tablas de descriptivos, incluyendo diferentes estadísticos descriptivos.
Entre estos estadísticos descriptivos, ciertamemte los más común es
encontrar calculos de medias, desviación estándar, y otras medidas de
locación como mínimo y máximo, o diferentes percentiles.

En el siguiente código veremos tres ejemplos de librerías que generan
tablas de estadísticos descriptivos. Estas son las librerías `psych` y
`skimr`.

Usaremos la librería skimr que está diseñada para proporcionar
estadísticas resumidas. Entonces nombramos nuestra base, luego añadimos
un pipe (%&gt;%), nombramos nuestra librería(skimr) y la función skim
().Como sólo funciona para variables continuas (numéricas) excluye
automáticamente las nominales.

``` r
# -----------------------------------------------------------------------------
# tablas de descriptivos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# descriptivos con psych
# -----------------------------------------------

psych::describe(dem_16)
```

    ##            vars    n     mean       sd   median  trimmed      mad     min
    ## id_i          1 2500 35948.02 25602.24 26297.50 34520.14 26213.85 5901.00
    ## ctry*         2 2500     3.00     1.41     3.00     3.00     1.48    1.00
    ## sex           3 2500     0.49     0.50     0.00     0.49     0.00    0.00
    ## age           4 2500    14.21     0.94    14.00    14.10     0.62   11.50
    ## dem           5 2500     1.50     0.79     1.00     1.38     0.00    1.00
    ## dem_group*    6 2500     2.55     0.72     3.00     2.68     0.00    1.00
    ## aut           7 2483    49.41    11.47    51.06    50.10     9.76   17.67
    ## civ           8 2500   450.58    95.56   455.17   451.95   104.45   88.26
    ## ses           9 2481     0.02     1.00    -0.15    -0.03     1.05   -2.22
    ## edu          10 2466     0.26     0.44     0.00     0.20     0.00    0.00
    ## level        11 2500     1.24     1.00     1.00     1.17     1.48    0.00
    ## level_lab*   12 2500     2.24     1.00     2.00     2.17     1.48    1.00
    ##                 max    range  skew kurtosis     se
    ## id_i       77244.00 71343.00  0.41    -1.46 512.04
    ## ctry*          5.00     4.00  0.00    -1.30   0.03
    ## sex            1.00     1.00  0.02    -2.00   0.01
    ## age           19.67     8.17  1.34     2.60   0.02
    ## dem            3.00     2.00  1.12    -0.46   0.02
    ## dem_group*     3.00     2.00 -1.25     0.06   0.01
    ## aut           85.37    67.70 -0.57     1.13   0.23
    ## civ          751.08   662.82 -0.15    -0.37   1.91
    ## ses            2.77     4.99  0.43    -0.55   0.02
    ## edu            1.00     1.00  1.07    -0.84   0.01
    ## level          3.00     3.00  0.22    -1.08   0.02
    ## level_lab*     4.00     3.00  0.22    -1.08   0.02

``` r
# -----------------------------------------------
# descriptivos con skimr
# -----------------------------------------------

skimr::skim(dem_16)
```

    ## Warning: Couldn't find skimmers for class: haven_labelled; No user-defined `sfl`
    ## provided. Falling back to `character`.

    ## Warning: Couldn't find skimmers for class: haven_labelled; No user-defined `sfl`
    ## provided. Falling back to `character`.

    ## Warning: Couldn't find skimmers for class: haven_labelled; No user-defined `sfl`
    ## provided. Falling back to `character`.

|                                                  |         |
|:-------------------------------------------------|:--------|
| Name                                             | dem\_16 |
| Number of rows                                   | 2500    |
| Number of columns                                | 12      |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |         |
| Column type frequency:                           |         |
| character                                        | 6       |
| numeric                                          | 6       |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |         |
| Group variables                                  | None    |

Data summary

**Variable type: character**

| skim\_variable | n\_missing | complete\_rate | min | max | empty | n\_unique | whitespace |
|:---------------|-----------:|---------------:|----:|----:|------:|----------:|-----------:|
| ctry           |          0 |           1.00 |   4 |  18 |     0 |         5 |          0 |
| age            |          0 |           1.00 |   2 |   5 |     0 |        77 |          0 |
| dem\_group     |          0 |           1.00 |   7 |  10 |     0 |         3 |          0 |
| civ            |          0 |           1.00 |   3 |   6 |     0 |      2405 |          0 |
| ses            |         19 |           0.99 |   1 |   5 |     0 |       395 |          0 |
| level\_lab     |          0 |           1.00 |   7 |   7 |     0 |         4 |          0 |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate |     mean |       sd |      p0 |      p25 |      p50 |      p75 |     p100 | hist  |
|:---------------|-----------:|---------------:|---------:|---------:|--------:|---------:|---------:|---------:|---------:|:------|
| id\_i          |          0 |           1.00 | 35948.02 | 25602.24 | 5901.00 | 12295.50 | 26297.50 | 57802.50 | 77244.00 | ▇▃▁▃▃ |
| sex            |          0 |           1.00 |     0.49 |     0.50 |    0.00 |     0.00 |     0.00 |     1.00 |     1.00 | ▇▁▁▁▇ |
| dem            |          0 |           1.00 |     1.50 |     0.79 |    1.00 |     1.00 |     1.00 |     2.00 |     3.00 | ▇▁▂▁▂ |
| aut            |         17 |           0.99 |    49.41 |    11.47 |   17.67 |    44.48 |    51.06 |    56.63 |    85.37 | ▁▃▇▂▁ |
| edu            |         34 |           0.99 |     0.26 |     0.44 |    0.00 |     0.00 |     0.00 |     1.00 |     1.00 | ▇▁▁▁▃ |
| level          |          0 |           1.00 |     1.24 |     1.00 |    0.00 |     0.00 |     1.00 |     2.00 |     3.00 | ▇▇▁▇▃ |

La librería `skimr` clasifica a `age`, `civ` y `ses` como variables tipo
texto (i.e. `character`), debido a que estos campos poseen `labels`.
Podemos remover esta información de la tabla, para obtener un
descriptivo completo.

``` r
# -----------------------------------------------------------------------------
# tablas de descriptivos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# removiendo labels
# -----------------------------------------------

dem_16 %>%
r4sda::remove_labels() %>%
skimr::skim()
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

|                                                  |            |
|:-------------------------------------------------|:-----------|
| Name                                             | Piped data |
| Number of rows                                   | 2500       |
| Number of columns                                | 12         |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |            |
| Column type frequency:                           |            |
| character                                        | 3          |
| numeric                                          | 9          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |            |
| Group variables                                  | None       |

Data summary

**Variable type: character**

| skim\_variable | n\_missing | complete\_rate | min | max | empty | n\_unique | whitespace |
|:---------------|-----------:|---------------:|----:|----:|------:|----------:|-----------:|
| ctry           |          0 |              1 |   4 |  18 |     0 |         5 |          0 |
| dem\_group     |          0 |              1 |   7 |  10 |     0 |         3 |          0 |
| level\_lab     |          0 |              1 |   7 |   7 |     0 |         4 |          0 |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate |     mean |       sd |      p0 |      p25 |      p50 |      p75 |     p100 | hist  |
|:---------------|-----------:|---------------:|---------:|---------:|--------:|---------:|---------:|---------:|---------:|:------|
| id\_i          |          0 |           1.00 | 35948.02 | 25602.24 | 5901.00 | 12295.50 | 26297.50 | 57802.50 | 77244.00 | ▇▃▁▃▃ |
| sex            |          0 |           1.00 |     0.49 |     0.50 |    0.00 |     0.00 |     0.00 |     1.00 |     1.00 | ▇▁▁▁▇ |
| age            |          0 |           1.00 |    14.21 |     0.94 |   11.50 |    13.58 |    14.00 |    14.50 |    19.67 | ▁▇▂▁▁ |
| dem            |          0 |           1.00 |     1.50 |     0.79 |    1.00 |     1.00 |     1.00 |     2.00 |     3.00 | ▇▁▂▁▂ |
| aut            |         17 |           0.99 |    49.41 |    11.47 |   17.67 |    44.48 |    51.06 |    56.63 |    85.37 | ▁▃▇▂▁ |
| civ            |          0 |           1.00 |   450.58 |    95.56 |   88.26 |   380.26 |   455.17 |   522.20 |   751.08 | ▁▃▇▆▁ |
| ses            |         19 |           0.99 |     0.02 |     1.00 |   -2.22 |    -0.74 |    -0.15 |     0.74 |     2.77 | ▂▇▆▅▁ |
| edu            |         34 |           0.99 |     0.26 |     0.44 |    0.00 |     0.00 |     0.00 |     1.00 |     1.00 | ▇▁▁▁▃ |
| level          |          0 |           1.00 |     1.24 |     1.00 |    0.00 |     0.00 |     1.00 |     2.00 |     3.00 | ▇▇▁▇▃ |

## Descriptivos empleando `dplyr::summarize`

Empleando la libreria `dplyr` uno puede generar tablas de descriptivos
como las anteriores. Por ejemplo el siguiente código, calcula una tabla
de medias para la variable `civ`.

``` r
# -----------------------------------------------
# descriptivos con summarize
# -----------------------------------------------

dem_16 %>%                         # llamar a la base de datos
summarize(                         # especificar en dplyr que haremos summary
  mean = mean(civ, na.rm = TRUE),  # crear la media
  sd   = sd(civ, na.rm = TRUE)     # crear la desviación estándar
  ) %>%                            # cerrar la función
knitr::kable(.,digits = 2)         # crear tabla en consola, con decimales
```

|   mean |    sd |
|-------:|------:|
| 450.58 | 95.56 |

Las funciones de descriptivos de `skimr::skim`, y de `psych::describe`
comparten el espíritu de la idea de `summarize`, pero incluyen el
cálculo de diferentes cifras. La utilidad de `summarize` es que el
usuario puede incluir los estadísticos descriptivos que desee. Lo único
requerido es identificar el comando o función que produce el estadístico
sobre un vector numérico. En el siguiente ejemplo incluimos diferentes
comandos para enriquecer la tabla de descriptivos.

``` r
# -----------------------------------------------
# descriptivos con summarize
# -----------------------------------------------

dem_16 %>%                           # llamar a la base de datos
summarize(                           # especificar en dplyr que haremos summary
  mean   = mean(civ, na.rm = TRUE),  # crear la media
  sd     = sd(civ, na.rm = TRUE),    # crear la desviación estándar
  # crear percentiles 25, 50, y 75                                    
  p25    = quantile(civ, probs = .25, na.rm = TRUE),
  p50    = quantile(civ, probs = .50, na.rm = TRUE),
  p75    = quantile(civ, probs = .75, na.rm = TRUE),
  IQR    = IQR(civ, na.rm = TRUE),   # crear rango inter cuartil
  hist   = skimr::inline_hist(civ),  # crear histograma
  ) %>%                              # cerrar la función
knitr::kable(., digits = 2)          # crear tabla en consola, con decimales
```

|   mean |    sd |    p25 |    p50 |   p75 |    IQR | hist     |
|-------:|------:|-------:|-------:|------:|-------:|:---------|
| 450.58 | 95.56 | 380.26 | 455.17 | 522.2 | 141.95 | ▁▁▃▆▇▆▂▁ |

La función de descriptivos de `r4sda`, `r4sda::get_desc()` es
básicamente una tabla como la de `summarize` con algunas ventajas y
limitaciones. Una ventaja, es no es necesario que uno retire a los
labels de los datos antes de producir descriptivos. Esta operación ya se
encuentra dentro de la función `get_desc()`. Esta función posee dos
limitaciones: solo opera sobre variables numéricas, y no es posible de
encadenarka con `group_by()` (ver códigos siguientes).

``` r
# -----------------------------------------------
# descriptivos con r4sda::get_desc
# -----------------------------------------------

dem_16 %>%                                    # identificar variables tipo texto
r4sda::variables_table()                      # y tambien identicar variable `id`
```

    ## # A tibble: 12 x 4
    ##    variable  type   values               labels                                 
    ##    <chr>     <chr>  <chr>                <chr>                                  
    ##  1 id_i      dbl    "63, 8736, 9067, 96… id único del caso                      
    ##  2 ctry      chr    "e\", \"Chile\", \"… nombre del país                        
    ##  3 sex       dbl    " 1, 0, 0, 1, 0, 0,… sexo del estudiante (0 = niño, 1 = niñ…
    ##  4 age       dbl+l… "13.42, 13.33, 13.9… edad del estudiante en años (media = 1…
    ##  5 dem       dbl    " 1, 1, 2, 3, 2, 1,… perfil de concepciones de las democrac…
    ##  6 dem_group chr    " \"complex\", \"mi… perfil de concepciones de las democrac…
    ##  7 aut       dbl    "7, 47.94, 59.24, 5… creencias antidemocráticas (AUTGOV, me…
    ##  8 civ       dbl+l… "81, 479.65, 556.01… conocimiento cívico (PV1CVI, media =  …
    ##  9 ses       dbl+l… "-0.17,  1.08, -1.0… nivel socioecónomico (media = 0, sd = …
    ## 10 edu       dbl    " 0, 0, 1, 0, 1, 1,… educación de los padres (1 = educación…
    ## 11 level     dbl    " 0, 0, 2, 1, 2, 2,… niveles de conocimiento cívico (numéri…
    ## 12 level_lab chr    " \"level 3\", \"le… niveles de conocimiento cívico (Level …

``` r
dem_16 %>%                                    # llamar base de datos
  dplyr::select(                              # restar variables tipo texto
  -id_i, -ctry, 
  -dem_group,
  -level_lab
  ) %>%                                       
r4sda::get_desc() %>%                         # aplicar la función de descriptivos 
knitr::kable(., digits = 2)                   # crear tabla en consola, con decimales
```

    ## Loading required package: moments

    ## Loading required package: skimr

| var   | missing | complete |    n |   mean |    sd |   min |    p25 | median |    p75 |    max |  skew | kurt | hist     |
|:------|--------:|---------:|-----:|-------:|------:|------:|-------:|-------:|-------:|-------:|------:|-----:|:---------|
| sex   |    0.00 |     1.00 | 2500 |   0.49 |  0.50 |  0.00 |   0.00 |   0.00 |   1.00 |   1.00 |  0.02 | 1.00 | ▇▁▁▁▁▁▁▇ |
| age   |    0.00 |     1.00 | 2500 |  14.21 |  0.94 | 11.50 |  13.58 |  14.00 |  14.50 |  19.67 |  1.34 | 5.60 | ▁▃▇▂▁▁▁▁ |
| dem   |    0.00 |     1.00 | 2500 |   1.50 |  0.79 |  1.00 |   1.00 |   1.00 |   2.00 |   3.00 |  1.12 | 2.54 | ▇▁▁▂▁▁▁▂ |
| aut   |    0.01 |     0.99 | 2500 |  49.41 | 11.47 | 17.67 |  44.48 |  51.06 |  56.63 |  85.37 | -0.57 | 4.14 | ▁▁▃▇▇▃▁▁ |
| civ   |    0.00 |     1.00 | 2500 | 450.58 | 95.56 | 88.26 | 380.26 | 455.17 | 522.20 | 751.08 | -0.15 | 2.63 | ▁▁▃▆▇▆▂▁ |
| ses   |    0.01 |     0.99 | 2500 |   0.02 |  1.00 | -2.22 |  -0.74 |  -0.15 |   0.74 |   2.77 |  0.43 | 2.45 | ▁▅▇▇▅▃▂▁ |
| edu   |    0.01 |     0.99 | 2500 |   0.26 |  0.44 |  0.00 |   0.00 |   0.00 |   1.00 |   1.00 |  1.08 | 2.16 | ▇▁▁▁▁▁▁▃ |
| level |    0.00 |     1.00 | 2500 |   1.24 |  1.00 |  0.00 |   0.00 |   1.00 |   2.00 |   3.00 |  0.22 | 1.92 | ▇▁▇▁▁▇▁▃ |

``` r
# Nota: solo funciona con variables numericas
```

## Descriptivos empleando `dplyr::summarize` para diferentes grupos

Dentro del esquema de `dplyr::summarize` es posible generar descriptivos
condicionales a otra variable. Es decir, podemos obtener medias, y
desviaciones estándar, u otro tipo de estadístico para diferentes grupos
de observaciones. En el siguiente ejemplo calculamos medias,
desviaciones estándar de `civ` y cantidad de casos, para los diferentes
perfiles de concepciones de democracia.

``` r
# -----------------------------------------------
# descriptivos con summarize por grupo
# -----------------------------------------------

dem_16 %>%                         # llamar a la base de datos
group_by(dem_group) %>%            # especificar la covariable o grupo de comparación
summarize(                         # especificar en dplyr que haremos summary
  mean = mean(civ, na.rm = TRUE),  # crear la media
  sd   = sd(civ, na.rm = TRUE),    # crear la desviación estándar
  n    = n()                       # crear contador de casos
  ) %>%                            # cerrar la función
knitr::kable(.,digits = 2)         # crear tabla en consola, con decimales
```

| dem\_group |   mean |    sd |    n |
|:-----------|-------:|------:|-----:|
| complex    | 540.82 | 77.72 |  334 |
| limited    | 412.21 | 80.91 |  464 |
| minimalist | 443.34 | 91.64 | 1702 |

Podemos ampliar los factores de agrupación, incluyendo más variable en
el comando `group_by()`. Por ejemplo, con el siguiente codígo podemos
obtener las medias, desviación estándar, y cantidad de casos de cada
celda, por país, y por perfiles de concepciones de democracia.

``` r
# -----------------------------------------------
# descriptivos con summarize por grupo
# -----------------------------------------------

dem_16 %>%                         # llamar a la base de datos
group_by(ctry, dem_group) %>%      # especificar factores de agrupación
summarize(                         # especificar en dplyr que haremos summary
  mean = mean(civ, na.rm = TRUE),  # crear la media
  sd   = sd(civ, na.rm = TRUE),    # crear la desviación estándar
  n    = n()                       # crear contador de casos
  ) %>%                            # cerrar la función
knitr::kable(.,digits = 2)         # crear tabla en consola, con decimales
```

    ## `summarise()` has grouped output by 'ctry'. You can override using the `.groups` argument.

| ctry               | dem\_group |   mean |    sd |   n |
|:-------------------|:-----------|-------:|------:|----:|
| Chile              | complex    | 549.90 | 68.59 | 176 |
| Chile              | limited    | 421.15 | 80.97 | 124 |
| Chile              | minimalist | 459.37 | 89.55 | 200 |
| Colombia           | complex    | 552.31 | 93.59 |  56 |
| Colombia           | limited    | 443.30 | 75.35 |  73 |
| Colombia           | minimalist | 476.78 | 78.61 | 371 |
| Dominican Republic | complex    | 459.36 | 90.48 |  16 |
| Dominican Republic | limited    | 365.05 | 76.15 |  77 |
| Dominican Republic | minimalist | 382.04 | 83.20 | 407 |
| Mexico             | complex    | 545.58 | 56.43 |  52 |
| Mexico             | limited    | 420.34 | 71.81 | 114 |
| Mexico             | minimalist | 481.47 | 77.50 | 334 |
| Peru               | complex    | 505.90 | 87.11 |  34 |
| Peru               | limited    | 403.35 | 83.82 |  76 |
| Peru               | minimalist | 434.61 | 89.00 | 390 |

# Descriptivos por tipo de variable

Como se indicar en las clases, la escala con la que se representan los
valores de un atributo o variable limitan el conjunto de operaciones
aritméticas que son interpretables respecto a un conjunto de valores.
Por ejemplo, esto implica que si bien una variable nominal pueden ser
representada con los valores 1, 2, 3, estos valores no poseen
ordinalidad en el sentido estricto. Y por tanto, un promedio de los
valores que de una variable nominal carecen de una interpretación
razonable.

En la sigiuentes secciones vamos a revisar como producir tablas y
gráficos para variables nominales, ordinales, e intervalares.

# Variable Nominal: Perfiles democráticos

> Las variables representadas en **Escala Nominal** son aquellas que
> pueden tomar diferentes valores discretos, pero estos valores solo
> implican propiedades de igualdad o diferencia de elementos. Los
> estadísticos interpretables sobre este tipo de variables incluyen a:
> frecuencias, porcentajes, modas, y tablas de contigencias (ver
> Stevens, 1965, Tabla 1).

Los perfiles de concepciones democráticas, siguen el trabajo de
(Quaranta, 2019). Frente a un conjunto de diferentes eventos que pueden
suceder en un pais, y los estudiantes deben indicar si estos eventos son
buenos, ni bueno ni malo, o malo para una democracia. En general, se
plantea que la dsitribución de respuestas frentre a estos eventos
permite distinguir entre aquellos estudiantes que saben como una
democracia debe lucir.

y distinguen a los estudiantes en tres grupos:

-   **complex**: son aquellos estudiantes que consideran constitutivos
    de los sistemas democráticos, un conjunto complejo de
    características. Entre ellas se encuentran las elecciones de
    autoridades políticas, la igualdad ante la ley, y el ejericicio de
    protesta frente a leyes injustas. Además, consideran que la
    concentración de medios de comunicación, el nepotismo en el
    gobierno, y la influencia del ejecutivo sobre los tribunales de
    justicia como amenazas claras a los sistemas democráticos.

-   **minimalist**: son aquellos estudiantes que consideran
    constitutivos de los sistemas democráticos, un conjunto minimalista
    de características. Esto incluye a las elecciones de autoridades
    políticas, la igualdad ante la ley, y el ejericicio de protesta
    frente a leyes injustas. Sin embargo, este perfil de estudiantes, es
    insensible a la concentración de medios, el nepotismo, y la
    influencia del ejecutivo sobre el poder judicial.

-   **limited**: son aquellos estudiantes que no distinguen de forma
    adecuada las características centrales de los sistemas democráticos.

La siguiente figura describe la distribución de respuesta que estos
diferentes perfiles expresan frente los diferentes eventos.

Los respuestas recogidas provienen del estudio Internacional sobre
Educación Cívica y Ciudadana (ICCS). Este estudio incluye diferentes
paises de Latinoamérica, Europa y Asia, incluyendo muestras
representativas de estudiantes de 8vo grado (14 años de edad
aproximadamente). Los datos `dem_16` incluyen una sub muestra de 500
casos de Chile, Colombia, Republica Dominicana, Mexico y Perú.

A continuación, emplearemos la variable anterior para ilustrar como
obtener frecuencias, porcentajes, y como graficar estos resultados.

## Frecuencias

``` r
# -----------------------------------------------------------------------------
# frecuencias
# -----------------------------------------------------------------------------

# -----------------------------------------------
# tabla de frecuencia con base::table()
# -----------------------------------------------

base::table(dem_16$dem_group) %>%
knitr::kable()
```

| Var1       | Freq |
|:-----------|-----:|
| complex    |  334 |
| limited    |  464 |
| minimalist | 1702 |

``` r
# -----------------------------------------------
# tabla de frecuencia con stats::xtabs()
# -----------------------------------------------

stats::xtabs(~ dem_group, data = dem_16)
```

    ## dem_group
    ##    complex    limited minimalist 
    ##        334        464       1702

``` r
# -----------------------------------------------
# tabla de frecuencia dplyr::count()
# -----------------------------------------------

dplyr::count(dem_16, dem, dem_group) 
```

    ## # A tibble: 3 x 3
    ##     dem dem_group      n
    ##   <dbl> <chr>      <int>
    ## 1     1 minimalist  1702
    ## 2     2 complex      334
    ## 3     3 limited      464

## Porcentajes

``` r
# -----------------------------------------------------------------------------
# porcentajes
# -----------------------------------------------------------------------------

# -----------------------------------------------
# tabla de frecuencia con base::table()
# -----------------------------------------------


base::table(dem_16$dem_group) %>%
base::prop.table() %>%
knitr::kable()
```

| Var1       |   Freq |
|:-----------|-------:|
| complex    | 0.1336 |
| limited    | 0.1856 |
| minimalist | 0.6808 |

``` r
# -----------------------------------------------
# tabla de frecuencia con stats::xtabs()
# -----------------------------------------------

stats::xtabs(~ dem_group, data = dem_16) %>%
base::prop.table() %>%
knitr::kable()
```

| dem\_group |   Freq |
|:-----------|-------:|
| complex    | 0.1336 |
| limited    | 0.1856 |
| minimalist | 0.6808 |

``` r
# -----------------------------------------------
# tabla de frecuencia agregando porcentajes
# -----------------------------------------------

dplyr::count(dem_16, dem, dem_group) %>%
mutate(porcentajes = n/sum(n)) %>%
knitr::kable(., digits = 2)
```

| dem | dem\_group |    n | porcentajes |
|----:|:-----------|-----:|------------:|
|   1 | minimalist | 1702 |        0.68 |
|   2 | complex    |  334 |        0.13 |
|   3 | limited    |  464 |        0.19 |

## Gráfico de barras

Para poder visualizar la información en este caso utilizaremos la
librería `ggplot` la cuál consiste en una forma de crear gráficos
categóricos de manera mas sencilla a través de una creacción por partes.
En la sección se define la creacción del gráfico `ggplot`. Este es un
canvas vacío y a través de cada uno de los elementos que iremos
agregando a través del conector `+`.

La variable `dem_group` es una variable de tipo discreta, o tambien
referida como *cualitativa* (ver LMW, cap. 2). Para graficar la
distribución de este tipo de variables podemos emplear un gráfico de
barrras.

``` r
# -----------------------------------------------------------------------------
# gráfico de barras
# -----------------------------------------------------------------------------

# -----------------------------------------------
# gráfico de barras en vertical
# -----------------------------------------------
library(ggplot2)
dem_16 %>%
  ggplot(
    aes(                                             # definimos los ejes del gráfico
      x= dem_group,
      fill= dem_group)
    ) +
  geom_bar() +                                       # qué tipo de gráfico hacemos
  scale_fill_brewer(palette = "Set3") +              # colores!
  labs(                                              # nombre de los ejes
    x= "Perfiles democráticos",
    y= "Frecuencia",
    title = "Frecuencia de Perfiles Democráticos") +
  coord_flip() +        
  theme_classic()                                    # el formato
```

![](ayu02_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

``` r
# -----------------------------------------------
# gráfico de barras en horizontal
# -----------------------------------------------

dem_16 %>%
  ggplot(
    aes(
      x= dem_group,
      fill= dem_group)
    ) +
  geom_bar() +
  scale_fill_brewer(palette = "Set3") +
  labs(
    x= "Perfiles democráticos",
    y= "Frecuencia",
    title = "Frecuencia de Perfiles Democráticos") +
  coord_flip() +
  theme_classic()  
```

![](ayu02_files/figure-gfm/unnamed-chunk-20-2.png)<!-- -->

``` r
# -----------------------------------------------
# cambiando orden de los grupos
# -----------------------------------------------

ordered_dem <- factor(dem_16$dem_group,
                      level = c('limited', 'minimalist', 'complex'))


dem_16 %>%
  ggplot(
    aes(
      x= ordered_dem,
      fill= ordered_dem
      )) +
  geom_bar() +
  labs(
    x= "Perfiles democráticos",
    y= "Frecuencia",
    title = "Distribución de Perfiles Democráticos") +
  coord_flip() +
  theme_classic()
```

![](ayu02_files/figure-gfm/unnamed-chunk-20-3.png)<!-- -->

# Variable Ordinal: Niveles de Conocimiento cívico

> Las variables representadas en **Escala Ordinal** son aquellas que
> pueden tomar diferentes valores discretos. Sin embargo, estos valores
> solo incluyen propiedades de igualdad o diferencia entre elementos,
> ademas de orden entre elementos. Los estadísticos interpretables sobre
> este tipo de variables incluyen a: frecuencias, porcentajes, modas, y
> tablas de contigencias (ver Stevens, 1965, Tabla 1).

Los niveles de conocimiento cívico, expresan el nivel sofisticación
política que presentan los estudiantes de 8vo grado de diferentes
países(ver Schulz et al, 2013). Aquellos estudiantes que se encuentran
en **nivel 3 (‘level 3’)** presentan un conocimiento político integrado,
y pueden comprender por ejemplo, la necesidad de contar con leyes sobre
la concentración de medios de comunicación, dado el rol que poseen en la
sociedad los medios de comunicación referente a la presentación de
ideas. Por su parte los estudiantes de **nivel 2 (‘level 2’)** presentan
un conocimiento político general, y comprenden el rol de las
instituciones más comununes de los sistemas de gobierno. Por ejemplo,
estos estudiantes entienden el rol de la separación de poderes, entre el
legislativo y el ejecutivo, para asegurar sistemas democráticos.
Finalmente, estudiantes en **nivel 1 (‘level 1’)** presentan algun grado
de familiaridad con diferentes principios cívicos. Por ejemplo,
estudiantes en este nivel, pueden relacionar la libertad de prensa, con
respecto a la fidelidad con la que se presenta la información al
público. En contraste, los estudiantes bajo el nivel 1, los que aqui
llamaremos **nivel 0 (‘level 0’)** presentan dificultades para realizar
el mismo tipo de juicios que los estudiantes en los niveles superiores.
Es posible que puedan entender la diferencia de poderes del estado, pero
estudiantes tendrían dificultades para relacionar principios y las leyes
que debieran garantizarlos.

## Frecuencias

``` r
# -----------------------------------------------------------------------------
# frecuencias
# -----------------------------------------------------------------------------

# -----------------------------------------------
# tabla de frecuencia con base::table()
# -----------------------------------------------

base::table(dem_16$level_lab) %>%
knitr::kable()
```

| Var1    | Freq |
|:--------|-----:|
| level 0 |  729 |
| level 1 |  745 |
| level 2 |  728 |
| level 3 |  298 |

``` r
# -----------------------------------------------
# tabla de frecuencia con stats::xtabs()
# -----------------------------------------------

stats::xtabs(~ level_lab, data = dem_16)
```

    ## level_lab
    ## level 0 level 1 level 2 level 3 
    ##     729     745     728     298

``` r
# -----------------------------------------------
# tabla de frecuencia dplyr::count()
# -----------------------------------------------

dplyr::count(dem_16, level, level_lab) 
```

    ## # A tibble: 4 x 3
    ##   level level_lab     n
    ##   <dbl> <chr>     <int>
    ## 1     0 level 0     729
    ## 2     1 level 1     745
    ## 3     2 level 2     728
    ## 4     3 level 3     298

## Porcentajes

``` r
# -----------------------------------------------------------------------------
# porcentajes
# -----------------------------------------------------------------------------

# -----------------------------------------------
# tabla de frecuencia con base::table()
# -----------------------------------------------

base::table(dem_16$level_lab) %>%
base::prop.table() %>%
knitr::kable()
```

| Var1    |   Freq |
|:--------|-------:|
| level 0 | 0.2916 |
| level 1 | 0.2980 |
| level 2 | 0.2912 |
| level 3 | 0.1192 |

``` r
# -----------------------------------------------
# tabla de frecuencia con stats::xtabs()
# -----------------------------------------------

stats::xtabs(~ level_lab, data = dem_16) %>%
base::prop.table() %>%
knitr::kable()
```

| level\_lab |   Freq |
|:-----------|-------:|
| level 0    | 0.2916 |
| level 1    | 0.2980 |
| level 2    | 0.2912 |
| level 3    | 0.1192 |

``` r
# -----------------------------------------------
# tabla de frecuencia agregando porcentajes
# -----------------------------------------------

dplyr::count(dem_16, level, level_lab) %>%
mutate(porcentajes = n/sum(n)) %>%
knitr::kable(., digits = 2)
```

| level | level\_lab |   n | porcentajes |
|------:|:-----------|----:|------------:|
|     0 | level 0    | 729 |        0.29 |
|     1 | level 1    | 745 |        0.30 |
|     2 | level 2    | 728 |        0.29 |
|     3 | level 3    | 298 |        0.12 |

## Gráfico de barras

La variable `level_lab` es una variable de tipo discreta, que puede ser
interpretada en orden.

``` r
# -----------------------------------------------------------------------------
# gráfico de barras
# -----------------------------------------------------------------------------

# -----------------------------------------------
# gráfico de barras en horizontal
# -----------------------------------------------

dem_16 %>%
  ggplot(
    aes(
      x= level_lab,
      fill= level_lab)
    ) +
  geom_bar() +
  scale_fill_brewer(palette = "Set3") +
  labs(
    x= 'Niveles de Conocimiento Cívico',
    y= "Frecuencia",
    title = 'Niveles de Conocimiento Cívico') +
  coord_flip() +
  theme_classic()  
```

![](ayu02_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

``` r
# -----------------------------------------------
# gráfico de barras en horizontal con porcentajes
# -----------------------------------------------

dem_16 %>%
dplyr::count(level_lab) %>%
mutate(percentage = n/sum(n)) %>%
  ggplot(
    aes(
      x    = level_lab,
      y    = percentage
      )
    ) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set3") +
  labs(
    x= 'Niveles de Conocimiento Cívico',
    y= "Porcentajes",
    title = 'Niveles de Conocimiento Cívico') +
  ylim(0,1) +
  coord_flip() +
  theme_classic()  
```

![](ayu02_files/figure-gfm/unnamed-chunk-23-2.png)<!-- -->

## Tabla de contigencia

``` r
# -----------------------------------------------------------------------------
# porcentajes
# -----------------------------------------------------------------------------

# -----------------------------------------------
# tabla de contigencia
# -----------------------------------------------

stats::xtabs(~ level_lab + dem_group, data = dem_16) %>%
base::prop.table() %>%
knitr::kable(., digits = 2)
```

|         | complex | limited | minimalist |
|:--------|--------:|--------:|-----------:|
| level 0 |    0.01 |    0.08 |       0.20 |
| level 1 |    0.02 |    0.06 |       0.22 |
| level 2 |    0.06 |    0.04 |       0.20 |
| level 3 |    0.05 |    0.00 |       0.06 |

``` r
# -----------------------------------------------
# tabla de contigencia, margenes de filas
# -----------------------------------------------

stats::xtabs(~ level_lab + dem_group, data = dem_16) %>%
base::prop.table(., margin = 1) %>%
knitr::kable(., digits = 2)
```

|         | complex | limited | minimalist |
|:--------|--------:|--------:|-----------:|
| level 0 |    0.02 |    0.28 |       0.70 |
| level 1 |    0.06 |    0.20 |       0.74 |
| level 2 |    0.19 |    0.14 |       0.67 |
| level 3 |    0.45 |    0.03 |       0.52 |

``` r
# -----------------------------------------------
# tabla de contigencia, margenes de columnas
# -----------------------------------------------

stats::xtabs(~ level_lab + dem_group, data = dem_16) %>%
base::prop.table(., margin = 2) %>%
knitr::kable(., digits = 2)
```

|         | complex | limited | minimalist |
|:--------|--------:|--------:|-----------:|
| level 0 |    0.05 |    0.44 |       0.30 |
| level 1 |    0.14 |    0.33 |       0.32 |
| level 2 |    0.42 |    0.21 |       0.29 |
| level 3 |    0.40 |    0.02 |       0.09 |

``` r
# -----------------------------------------------
# tabla de contigencia, margenes de columnas
# -----------------------------------------------

stats::xtabs(~ dem_group + level_lab, data = dem_16) %>%
base::prop.table(., margin = 2) %>%
knitr::kable(., digits = 2)
```

|            | level 0 | level 1 | level 2 | level 3 |
|:-----------|--------:|--------:|--------:|--------:|
| complex    |    0.02 |    0.06 |    0.19 |    0.45 |
| limited    |    0.28 |    0.20 |    0.14 |    0.03 |
| minimalist |    0.70 |    0.74 |    0.67 |    0.52 |

## Gráfico de Mosaico

``` r
# -----------------------------------------------------------------------------
# gráfico de mosaico
# -----------------------------------------------------------------------------

# -----------------------------------------------
# gráfico de mosaico
# -----------------------------------------------

library(ggmosaic)
psi2301::dem_16 %>%
dplyr::select(level_lab, dem_group) %>%
na.omit() %>%
mutate(dem_lab = forcats::as_factor(dem_group)) %>% 
ggplot() +
  geom_mosaic(aes(x = product(dem_lab, level_lab), fill = dem_lab)) +
  theme_mosaic() +
  scale_fill_manual(
      values = c( 'red', 'grey80', 'grey20')
      ) +
  theme(
  axis.ticks = element_blank(),
  legend.title = element_blank(),
  axis.title.x = element_text(margin = unit(c(t = 9, r = 9, b = 9, l = 9), "mm")),
  axis.title.y = element_text(margin = unit(c(t = 9, r = 9, b = 9, l = 9), "mm"))
  ) +
  labs(
    x = 'Political Sophistication levels',
    y = 'Concepts of democracy',
    title = "Concept of democracy by political sophistication"
    )
```

![](ayu02_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

``` r
# -----------------------------------------------
# gráfico de mosaico, reordenando categorias
# -----------------------------------------------

library(ggmosaic)
# llamar datos y prepar datos para generar figura
psi2301::dem_16 %>%
dplyr::select(level_lab, dem_group) %>%
# crear variable con orden deseado
mutate(dem_order = case_when(
  dem_group == 'complex'    ~ 3,
  dem_group == 'minimalist' ~ 2,
  dem_group == 'limited'    ~ 1)
) %>%
# eliminar vacíos
na.omit() %>%
# ordenar datos segun variable creada
arrange(desc(dem_order)) %>%
# crear factor segun orden de la tabla
mutate(dem_lab = forcats::as_factor(dem_group)) %>%
# crear plot de mosaico
ggplot() +
  geom_mosaic(aes(x = product(dem_lab, level_lab), fill = dem_lab)) +
  theme_mosaic() +
# definir colores
  scale_fill_manual(
      values = c( 'red', 'grey80', 'grey20')
      ) +
# definir titulos de ejes y de figura
  labs(
    x = 'Political Sophistication levels',
    y = 'Concepts of democracy',
    title = "Concept of democracy by political sophistication"
    ) +
# definir elementos del template
  theme(
  axis.ticks = element_blank(),
  legend.title = element_blank(),
  axis.title.x = element_text(
    margin = unit(c(t = 9, r = 9, b = 9, l = 9), "mm")),
  axis.title.y = element_text(
    margin = unit(c(t = 9, r = 9, b = 9, l = 9), "mm"))
    )
```

![](ayu02_files/figure-gfm/unnamed-chunk-25-2.png)<!-- -->

``` r
# Nota: en `margin`
#       t = top
#       b = bottom
#       l = left
#       r = right
```

# Variable Intervalar: Creencias Antidemocráticas

> Las variables representadas en **Escala Intervalar** son aquellas que
> pueden tomar diferentes valores. Las propiedades que incuyen estos
> valores son los de igualdad y diferencia, orden, y distancias. Sin
> embargo, esta escala no posee un cero sustantivo. Por tanto, es
> importante contar con algún punto de referencia para su
> interpretación.

Las creencias antidemocráticas consisten en una serie de diferentes
creencias que sostienen las personas, las cuales se oponen a los
sistemas democráticos. Una de estas creencias son las creencias
autoritarias o tambien llamado autoritarismo. Estas creencias consisten
en diferentes ideas que plantean que las autoridades son
incuestionables. Las personas que presentan un alto apoyo al
autoritarismo, se caracterizan por apoyar autoridades fuertes, y
favorecer la obediencia a-crítica frente a tales autoridades (Duckitt,
Bizumic, Krauss, & Heled, 2010). El estudio ICCS 2016 incluye un
conjunto de preguntas tipo Likert, que permite conformar un puntaje de
apoyo al autoritarismo entre los estudiantes. Este instrumento incluye
las sigiuentes afirmaciones:

-   Las personas que tengan opiniones diferentes al gobierno deben ser
    consideradas como sus enemigos.
-   Es mejor que los líderes del gobierno tomen decisiones sin consultar
    a nadie.
-   Los gobernantes deben hacer valer su autoridad aunque violen los
    derechos de algunos ciudadanos.
-   Es justo que el gobierno no cumpla con las leyes cuando lo crea
    necesario.
-   El gobierno debería cerrar los medios de comunicación que lo
    cri9quen.
-   Si el presidente no está de acuerdo con el congreso, debería
    disolverlo.
-   Los gobernantes pierden su autoridad cuando reconocen sus errores.
-   La opinión más importante del país debe ser la de presidente.
-   La concentración del poder en una sola persona garantiza el orden.

Las respuestas de los estudiantes son modeladas con un modelo de
respuesta de credito parcial, generando un puntaje IRT continuo, de
media 50, y desviación estándar 10, en la muestra agregada de paises de
Latinoamérica que participó en el estudio en 2009.

## Descriptivos

``` r
# -----------------------------------------------------------------------------
# analisis
# -----------------------------------------------------------------------------

# -----------------------------------------------
# análisis descriptivos
# -----------------------------------------------

dem_16 %>%
summarize(
  mean   = mean(aut, na.rm = TRUE),
  sd     = sd(aut, na.rm = TRUE),
  p25    = quantile(aut, probs = .25, na.rm = TRUE),
  p50    = quantile(aut, probs = .50, na.rm = TRUE),
  p75    = quantile(aut, probs = .75, na.rm = TRUE),
  hist   = skimr::inline_hist(aut)
  ) %>%
knitr::kable(.,, digits = 2)
```

|  mean |    sd |   p25 |   p50 |   p75 | hist     |
|------:|------:|------:|------:|------:|:---------|
| 49.41 | 11.47 | 44.48 | 51.06 | 56.63 | ▁▁▃▇▇▃▁▁ |

``` r
# -----------------------------------------------
# análsis por niveles de conocimiento
# -----------------------------------------------

dem_16 %>%
group_by(level_lab) %>%
summarize(
  mean   = mean(aut, na.rm = TRUE),
  sd     = sd(aut, na.rm = TRUE),
  p25    = quantile(aut, probs = .25, na.rm = TRUE),
  p50    = quantile(aut, probs = .50, na.rm = TRUE),
  p75    = quantile(aut, probs = .75, na.rm = TRUE),
  hist   = skimr::inline_hist(aut)
  ) %>%
knitr::kable(.,, digits = 2)
```

| level\_lab |  mean |    sd |   p25 |   p50 |   p75 | hist     |
|:-----------|------:|------:|------:|------:|------:|:---------|
| level 0    | 57.18 |  9.32 | 52.52 | 56.63 | 61.87 | ▁▁▁▃▇▅▁▁ |
| level 1    | 51.23 |  9.20 | 47.94 | 52.52 | 56.63 | ▁▁▂▆▇▂▁▁ |
| level 2    | 44.87 |  9.35 | 40.44 | 46.26 | 51.06 | ▁▁▅▇▃▁▁▁ |
| level 3    | 37.22 | 10.62 | 31.87 | 38.07 | 44.70 | ▅▂▃▇▇▆▂▁ |

## Histogramas

Un histograma representa el número de frecuencias en cada clase o grupo
en forma de rectángulo. La mayoría de los histogramas poseen la misma
estructura: se nombra la base datos y `$` la variable que se quiere
graficar, el nombre de la figura, el xlab (etiqueta eje x) y el ylab
(etiqueta eje y). Luego indicamos corte (`breaks`), el ancho del eje x y
el color.

``` r
# -----------------------------------------------------------------------------
# gráficos
# -----------------------------------------------------------------------------

# -----------------------------------------------
# histograma con base
# -----------------------------------------------

hist(dem_16$aut,
  main = 'Histograma', 
  xlab = 'Apoyo al Autoritarismo',
  ylab = 'frecuencia',
  breaks = 12,
  xlim = c(20, 80))
```

![](ayu02_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

``` r
# -----------------------------------------------
# histograma en ggplot
# -----------------------------------------------

library(ggplot2)
dem_16 %>%
ggplot(., 
  aes(x = aut)
  ) +
  geom_histogram(
  position = "identity", 
  alpha = .8, 
  color = 'grey20',
  fill =  'red',
  binwidth = 5) +
scale_x_continuous(
  name = 'Apoyo al Autoritarismo',
  breaks = seq(20, 80, by = 10), 
  limits = c(20,80)
  ) +  
  theme_light()
```

![](ayu02_files/figure-gfm/unnamed-chunk-27-2.png)<!-- -->

``` r
# Nota: Éste es un plot generado con ggplot2.
#       Este tipo de figuras esta generado mediante
#       la lógica de `grammar of graphics`.
#       Esta es una librería muy versatil, que
#       cuenta con mucha documentación de ejemplos online.


# -----------------------------------------------
# histograma en ggplot por grupos
# -----------------------------------------------

library(ggplot2)
dem_16 %>%
ggplot(., 
  aes(x = aut)
  ) +
  geom_histogram(
  position = "identity", 
  alpha = .8, 
  color = 'grey20',
  fill =  'red',
  binwidth = 5) +
scale_x_continuous(
  name = 'Apoyo al Autoritarismo',
  breaks = seq(20, 80, by = 10), 
  limits = c(20,80)
  ) +  
  facet_grid(dem_group ~ .) +
  theme_light()
```

![](ayu02_files/figure-gfm/unnamed-chunk-27-3.png)<!-- -->

``` r
# -----------------------------------------------
# histograma en ggplot por grupos
# -----------------------------------------------

library(ggplot2)
dem_16 %>%
ggplot(., 
  aes(x = aut)
  ) +
  geom_histogram(
  position = "identity", 
  alpha = .8, 
  color = 'grey20',
  fill =  'red',
  binwidth = 5) +
scale_x_continuous(
  name = 'Apoyo al Autoritarismo',
  breaks = seq(20, 80, by = 10), 
  limits = c(20,80)
  ) +  
  facet_grid(level_lab ~ .) +
  theme_light()
```

![](ayu02_files/figure-gfm/unnamed-chunk-27-4.png)<!-- -->

## Dispersiogramas

``` r
# -----------------------------------------------------------------------------
# scatter
# -----------------------------------------------------------------------------

# -----------------------------------------------
# dispersiograma
# -----------------------------------------------

library(ggplot2)
dem_16 %>%
ggplot(
  aes(
    x = civ,
    y = aut)
  ) +
geom_point(
  alpha = 0.4,
  size  = 5,
  color = 'grey30') +
labs(
  title = "Conocimiento cívico vs Creencias autoritarias",
      y = "Creencias autoritarias",
      x = "Conocimiento Cívico") +
xlim(200,800) +
ylim(20,80) +
theme_light()
```

![](ayu02_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

``` r
# -----------------------------------------------
# dispersiograma
# -----------------------------------------------

library(ggplot2)
dem_16 %>%
ggplot(
  aes(
    x = civ,
    y = aut)
  ) +
geom_point(
  alpha = 0.2,
  size  = 2,
  color = 'grey30') +
labs(
  title = "Conocimiento cívico vs Creencias autoritarias, según Concepto de democracia",
      y = "Creencias autoritarias",
      x = "Conocimiento Cívico") +
xlim(200,800) +
ylim(20,80) +
facet_grid(dem_group ~ .) +
theme_light()
```

![](ayu02_files/figure-gfm/unnamed-chunk-28-2.png)<!-- -->

# Ejercicios

-   1.  Genere un dispersiograma que incluya nivel socioeconómico
        (`ses`) y conocimiento cívico (`civ`)

-   2.  ¿Qué país presenta el promedio más alto en Conocimiento cívico?

-   3.  Cuál es el nivel de conocimiento más frecuente en cada perfil de
        concepto de democracia, en Perú.

# Referencias

Duckitt, J., Bizumic, B., Krauss, S. W., & Heled, E. (2010). A
Tripartite Approach to Right-Wing Authoritarianism: The
Authoritarianism-Conservatism-Traditionalism Model. Political
Psychology, 31(5), 685–715.
<https://doi.org/10.1111/j.1467-9221.2010.00781.x>

Quaranta, M. (2019). What makes up democracy? Meanings of democracy and
their correlates among adolescents in 38 countries. Acta Politica,
0123456789. <https://doi.org/10.1057/s41269-019-00129-4>

Schulz, W., Fraillon, J., & Ainley, J. (2013). Measuring young people’s
understanding of civics and citizenship in a cross-national study.
Educational Psychology, 33(3), 327–349.
<https://doi.org/10.1080/01443410.2013.772776>
