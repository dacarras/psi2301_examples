Asociación entre variables
================

# Confiabilidad de puntajes

-   Ejemplos de *α* de Cronbach

## Amenazas a la democracia

-   Hay varias maneras de obtener un estimado de Alpha
-   En el siguiente código se ilustran tres formas:
    -   Las forma mas convencional, empleando la librería psych
    -   Empleando la matriz de correlaciones, usando la librería psych
    -   Empleando la media de correlaciones usando una formula

``` r
# -----------------------------------------------------------------------------
# threats to democracy
# -----------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------

data_lat <- psi2301::iccs_16_lat

# -----------------------------------------------
# items table
# -----------------------------------------------


items_table <- read.table(
text="
final_selection var_name  variable  item_text
yes IS3G22A td1 '[R] Political leaders give government jobs to their family members.'
yes IS3G22B td2 '[R] One company or the government owns all newspapers in a country.'
yes IS3G22C td3 'People are allowed to publicly criticize the government.'
yes IS3G22D td4 'All adult citizens have the right to elect their political leaders.'
yes IS3G22E td5 'People are able to protest if they think a law is unfair.'
yes IS3G22F td6 '[R] The police have the right to hold people suspected of threatening national security in jail without trial.'
no  IS3G22G td7 'Differences in income between poor and rich people are small.'
yes IS3G22H td8 '[R] The government influences decisions by courts of justice.'
yes IS3G22I td9 'All <ethnic/racial> groups in the country have the same rights.'
",
header=TRUE, stringsAsFactors = FALSE)

# -----------------------------------------------
# display item table
# -----------------------------------------------

knitr::kable(items_table)
```

| final\_selection | var\_name | variable | item\_text                                                                                                       |
|:-----------------|:----------|:---------|:-----------------------------------------------------------------------------------------------------------------|
| yes              | IS3G22A   | td1      | \[R\] Political leaders give government jobs to their family members.                                            |
| yes              | IS3G22B   | td2      | \[R\] One company or the government owns all newspapers in a country.                                            |
| yes              | IS3G22C   | td3      | People are allowed to publicly criticize the government.                                                         |
| yes              | IS3G22D   | td4      | All adult citizens have the right to elect their political leaders.                                              |
| yes              | IS3G22E   | td5      | People are able to protest if they think a law is unfair.                                                        |
| yes              | IS3G22F   | td6      | \[R\] The police have the right to hold people suspected of threatening national security in jail without trial. |
| no               | IS3G22G   | td7      | Differences in income between poor and rich people are small.                                                    |
| yes              | IS3G22H   | td8      | \[R\] The government influences decisions by courts of justice.                                                  |
| yes              | IS3G22I   | td9      | All <ethnic/racial> groups in the country have the same rights.                                                  |

``` r
# -----------------------------------------------
# response values
# -----------------------------------------------

response_values <- read.table(
text="
value response_label
1     'Good for democracy'
2     'Neither good nor bad for democracy'
3     'Bad for democracy'
",
header=TRUE, stringsAsFactors = FALSE)


# -----------------------------------------------
# display response values
# -----------------------------------------------

knitr::kable(response_values)
```

| value | response\_label                    |
|------:|:-----------------------------------|
|     1 | Good for democracy                 |
|     2 | Neither good nor bad for democracy |
|     3 | Bad for democracy                  |

``` r
#------------------------------------------------
# desired names for merge
#------------------------------------------------

merge_names <- items_table %>%
               dplyr::select(variable) %>%
               .$variable %>%
               as.character()

# -----------------------------------------------
# get item names
# -----------------------------------------------

original_names <- names(dplyr::select(data_lat, starts_with('IS3G22')))

# -----------------------------------------------
# recode functions
# -----------------------------------------------

rec_2 <- function(x){
dplyr::case_when(
#  variable == old ~ new
  x == 1 ~ 1,
  x == 2 ~ 0,
  x == 3 ~ 0,
  TRUE ~ as.numeric(x))
# Note: it recodes ordinal items,
#       where 1 is good for democracy (1)
#       and zero is neither good or bad (2) and bad for democracy(3)
}

rec_3 <- function(x){
dplyr::case_when(
#  variable == old ~ new
  x == 1 ~ 0,
  x == 2 ~ 0,
  x == 3 ~ 1,
  TRUE ~ as.numeric(x))
# Note: it recodes ordinal items, that are reverse coded,
#       where 1 is bad for democracy (1)
#       and zero is neither good or bad (2) and good for democracy(3)
}


#------------------------------------------------
# recode items, general recode
#------------------------------------------------

items_data <- data_lat %>%
              # replace original names for merge names
              rename_at(vars(original_names), ~paste0(merge_names)) %>%
              # dichotomization of items
              mutate(td1 = rec_3(td1)) %>%
              mutate(td2 = rec_3(td2)) %>%
              mutate(td3 = rec_2(td3)) %>%
              mutate(td4 = rec_2(td4)) %>%
              mutate(td5 = rec_2(td5)) %>%
              mutate(td6 = rec_3(td6)) %>%
              mutate(td7 = rec_2(td7)) %>%
              mutate(td8 = rec_3(td8)) %>%
              mutate(td9 = rec_2(td9)) %>%
              # remove labels 
              r4sda::remove_labels() %>%
              # select recoded data only
              dplyr::select(id_i, td1:td9)


#------------------------------------------------
# display ten cases
#------------------------------------------------

items_data[1:10,] %>%
knitr::kable()
```

| id\_i | td1 | td2 | td3 | td4 | td5 | td6 | td7 | td8 | td9 |
|------:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
|  5898 |   1 |   1 |   0 |   1 |   0 |   0 |   0 |   1 |   1 |
|  5899 |   0 |   1 |   1 |   1 |   1 |   0 |   1 |   0 |   1 |
|  5900 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   0 |   1 |
|  5901 |   1 |   1 |   1 |   0 |   1 |   1 |   1 |   1 |   0 |
|  5902 |   0 |   1 |   1 |   1 |   1 |   1 |   0 |   1 |   1 |
|  5903 |   0 |   1 |   1 |   1 |   1 |   1 |   1 |   0 |   1 |
|  5904 |   0 |   1 |   1 |   0 |   0 |   0 |   0 |   0 |   0 |
|  5905 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |
|  5906 |   1 |   1 |   1 |   1 |   1 |   0 |   0 |   1 |   1 |
|  5907 |   1 |   1 |   0 |   1 |   1 |   1 |   0 |   1 |   1 |

``` r
# -----------------------------------------------------------------------------
# alpha computes
# -----------------------------------------------------------------------------

#------------------------------------------------
# alpha with psych
#------------------------------------------------

items_data %>%
dplyr::select(-id_i) %>%
psych::alpha()
```

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r S/N    ase mean   sd median_r
    ##       0.55      0.54    0.54      0.12 1.2 0.0043 0.44 0.22    0.096
    ## 
    ##  lower alpha upper     95% confidence boundaries
    ## 0.54 0.55 0.55 
    ## 
    ##  Reliability if an item is dropped:
    ##     raw_alpha std.alpha G6(smc) average_r  S/N alpha se  var.r med.r
    ## td1      0.51      0.51    0.50      0.11 1.02   0.0047 0.0091 0.101
    ## td2      0.50      0.50    0.49      0.11 0.98   0.0048 0.0087 0.092
    ## td3      0.53      0.53    0.52      0.12 1.11   0.0044 0.0107 0.101
    ## td4      0.50      0.50    0.49      0.11 0.99   0.0047 0.0087 0.098
    ## td5      0.49      0.49    0.49      0.11 0.97   0.0048 0.0091 0.093
    ## td6      0.53      0.52    0.52      0.12 1.10   0.0045 0.0090 0.098
    ## td7      0.56      0.57    0.56      0.14 1.30   0.0041 0.0073 0.104
    ## td8      0.52      0.51    0.51      0.12 1.06   0.0046 0.0085 0.101
    ## td9      0.50      0.50    0.49      0.11 0.99   0.0047 0.0096 0.092
    ## 
    ##  Item statistics 
    ##         n raw.r std.r r.cor r.drop mean   sd
    ## td1 24603  0.49  0.49  0.37  0.275 0.28 0.45
    ## td2 24328  0.53  0.51  0.42  0.305 0.43 0.50
    ## td3 24151  0.43  0.43  0.28  0.203 0.29 0.45
    ## td4 24340  0.49  0.50  0.41  0.299 0.80 0.40
    ## td5 24319  0.53  0.52  0.44  0.312 0.64 0.48
    ## td6 24279  0.45  0.43  0.30  0.213 0.36 0.48
    ## td7 24120  0.29  0.31  0.11  0.071 0.24 0.43
    ## td8 24145  0.45  0.46  0.34  0.249 0.24 0.42
    ## td9 24370  0.52  0.51  0.41  0.297 0.67 0.47
    ## 
    ## Non missing response frequency for each item
    ##        0    1 miss
    ## td1 0.72 0.28 0.03
    ## td2 0.57 0.43 0.04
    ## td3 0.71 0.29 0.05
    ## td4 0.20 0.80 0.04
    ## td5 0.36 0.64 0.04
    ## td6 0.64 0.36 0.04
    ## td7 0.76 0.24 0.05
    ## td8 0.76 0.24 0.05
    ## td9 0.33 0.67 0.04

``` r
#------------------------------------------------
# alpha with psych over correlation
#------------------------------------------------

items_data %>%
dplyr::select(-id_i) %>%
cor(., use = 'pairwise') %>%
psych::alpha()
```

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r S/N median_r
    ##       0.54      0.54    0.54      0.12 1.2    0.096
    ## 
    ##  Reliability if an item is dropped:
    ##     raw_alpha std.alpha G6(smc) average_r  S/N  var.r med.r
    ## td1      0.51      0.51    0.50      0.11 1.02 0.0091 0.101
    ## td2      0.50      0.50    0.49      0.11 0.98 0.0087 0.092
    ## td3      0.53      0.53    0.52      0.12 1.11 0.0108 0.101
    ## td4      0.50      0.50    0.49      0.11 0.99 0.0087 0.098
    ## td5      0.49      0.49    0.49      0.11 0.97 0.0091 0.093
    ## td6      0.52      0.52    0.52      0.12 1.10 0.0090 0.098
    ## td7      0.57      0.57    0.56      0.14 1.30 0.0073 0.104
    ## td8      0.51      0.51    0.51      0.12 1.06 0.0085 0.101
    ## td9      0.50      0.50    0.49      0.11 0.99 0.0096 0.092
    ## 
    ##  Item statistics 
    ##        r r.cor r.drop
    ## td1 0.49  0.37  0.271
    ## td2 0.51  0.42  0.304
    ## td3 0.43  0.28  0.206
    ## td4 0.51  0.41  0.294
    ## td5 0.52  0.44  0.317
    ## td6 0.43  0.30  0.212
    ## td7 0.31  0.11  0.071
    ## td8 0.46  0.34  0.243
    ## td9 0.51  0.41  0.300

``` r
#------------------------------------------------
# alpha with average correlations
#------------------------------------------------

k <- 9
r <- items_data %>%
     dplyr::select(-id_i) %>%
     corrr::correlate(., 
      method = 'pearson',
      use = 'pairwise') %>%
     corrr::shave() %>%
     corrr::stretch() %>%
     na.omit() %>%
     .$r %>%
     mean()
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise'

``` r
alpha <- (k * r) / ( 1 + (k - 1) * r)
alpha
```

    ## [1] 0.54333

``` r
#------------------------------------------------
# comparison
#------------------------------------------------

alpha_method_1 <- items_data %>%
                  dplyr::select(-id_i) %>%
                  psych::alpha() %>%
                  purrr::pluck('total') %>%
                  pull('raw_alpha')

alpha_method_2 <- items_data %>%
                  dplyr::select(-id_i) %>%
                  cor(., use = 'pairwise') %>%
                  psych::alpha() %>%
                  purrr::pluck('total') %>%
                  pull('raw_alpha')

alpha_method_3 <- alpha



data.frame(
  method = c('conventional','correlations','average correlation'),
  estimate = c(
    alpha_method_1,
    alpha_method_2,
    alpha_method_3)
    ) %>%
  knitr::kable(., digits = 5)
```

| method              | estimate |
|:--------------------|---------:|
| conventional        |  0.54530 |
| correlations        |  0.54333 |
| average correlation |  0.54333 |

> Nota: el Alpha obtenido es más bajo de lo esperado (alpha &lt; .7).
> Bajo la convención de que puntajes con alpha menor .7 no debieran ser
> generados, no es recomendable generar un puntaje total con las
> respuestas a estos ítems.

## Autoritarismo

-   Ejemplo de escala con un mejor alpha

``` r
# -----------------------------------------------------------------------------
# threats to democracy
# -----------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------

data_aut <- psi2301::iccs_16_lat %>%
            mutate(au1 = r4sda::reverse(LS3G01A)) %>%
            mutate(au2 = r4sda::reverse(LS3G01B)) %>%
            mutate(au3 = r4sda::reverse(LS3G01C)) %>%
            mutate(au4 = r4sda::reverse(LS3G01D)) %>%
            mutate(au5 = r4sda::reverse(LS3G01E)) %>%
            mutate(au6 = r4sda::reverse(LS3G01F)) %>%
            mutate(au7 = r4sda::reverse(LS3G02A)) %>%
            mutate(au8 = r4sda::reverse(LS3G02B)) %>%
            mutate(au9 = r4sda::reverse(LS3G02C)) %>%
            dplyr::select(id_i, au1:au9)

# -----------------------------------------------
# items table
# -----------------------------------------------

# au1   !Es mejor que los líderes del gobierno tomen decisiones sin consultar a na
# au2   !Los gobernantes deben hacer valer su autoridad aunque violen los derechos
# au3   !Los gobernantes pierden su autoridad cuando reconocen sus errores. 
# au4   !Las personas que tengan opiniones diferentes al gobierno deben ser consid
# au5   !La opinión más importante del país debe ser la de presidente. 
# au6   !Es justo que el gobierno no cumpla con las leyes cuando lo crea necesario
# au7   !La concentración del poder en una sola persona garantiza el orden.
# au8   !El gobierno debería cerrar los medios de comunicación que lo critiquen. 
# au9   !Si el presidente no está de acuerdo con el <congreso>, debería <disolverl

#------------------------------------------------
# display ten cases
#------------------------------------------------

data_aut[1:10,] %>%
knitr::kable()
```

| id\_i | au1 | au2 | au3 | au4 | au5 | au6 | au7 | au8 | au9 |
|------:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
|  5898 |   2 |   1 |   2 |   1 |   2 |   1 |   2 |   1 |   3 |
|  5899 |   1 |   2 |   4 |   2 |   2 |   3 |   2 |   2 |   2 |
|  5900 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |
|  5901 |   1 |   1 |   2 |   1 |   1 |   1 |   1 |   1 |   2 |
|  5902 |   1 |   1 |   2 |   1 |   1 |   1 |   1 |   1 |   1 |
|  5903 |   1 |   1 |   1 |   1 |   1 |   3 |   2 |   1 |   1 |
|  5904 |   2 |   3 |   2 |   1 |   2 |   1 |   2 |   2 |   2 |
|  5905 |   1 |   1 |   1 |   1 |   2 |   1 |   2 |   1 |   1 |
|  5906 |   1 |   2 |   3 |   2 |   1 |   1 |   1 |   1 |   2 |
|  5907 |   2 |   2 |   2 |   2 |   2 |   2 |   2 |   2 |   2 |

``` r
# -----------------------------------------------------------------------------
# alpha computes
# -----------------------------------------------------------------------------

#------------------------------------------------
# alpha with psych
#------------------------------------------------

data_aut %>%
dplyr::select(-id_i) %>%
psych::alpha()
```

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r S/N    ase mean   sd median_r
    ##       0.87      0.87    0.86      0.42 6.5 0.0013  2.2 0.66     0.41
    ## 
    ##  lower alpha upper     95% confidence boundaries
    ## 0.86 0.87 0.87 
    ## 
    ##  Reliability if an item is dropped:
    ##     raw_alpha std.alpha G6(smc) average_r S/N alpha se  var.r med.r
    ## au1      0.85      0.85    0.84      0.42 5.7   0.0014 0.0018  0.41
    ## au2      0.85      0.85    0.83      0.41 5.6   0.0014 0.0019  0.41
    ## au3      0.86      0.86    0.85      0.43 6.1   0.0013 0.0017  0.43
    ## au4      0.85      0.85    0.83      0.41 5.6   0.0014 0.0021  0.41
    ## au5      0.85      0.85    0.84      0.42 5.8   0.0014 0.0028  0.41
    ## au6      0.85      0.85    0.84      0.42 5.7   0.0014 0.0023  0.41
    ## au7      0.85      0.85    0.84      0.42 5.8   0.0014 0.0025  0.42
    ## au8      0.85      0.85    0.84      0.42 5.7   0.0014 0.0023  0.41
    ## au9      0.85      0.85    0.84      0.42 5.9   0.0014 0.0023  0.43
    ## 
    ##  Item statistics 
    ##         n raw.r std.r r.cor r.drop mean   sd
    ## au1 24962  0.71  0.71  0.67   0.61  1.9 0.93
    ## au2 24806  0.73  0.73  0.68   0.63  2.0 0.94
    ## au3 24698  0.63  0.63  0.56   0.52  2.5 0.94
    ## au4 24743  0.72  0.73  0.69   0.64  1.9 0.87
    ## au5 24765  0.71  0.69  0.64   0.60  2.5 1.04
    ## au6 24796  0.71  0.71  0.66   0.61  2.0 0.96
    ## au7 24855  0.68  0.68  0.62   0.58  2.6 0.92
    ## au8 24797  0.71  0.71  0.66   0.61  2.0 0.89
    ## au9 24686  0.67  0.68  0.62   0.57  2.3 0.92
    ## 
    ## Non missing response frequency for each item
    ##        1    2    3    4 miss
    ## au1 0.41 0.39 0.11 0.09 0.01
    ## au2 0.35 0.38 0.19 0.08 0.02
    ## au3 0.17 0.34 0.34 0.14 0.02
    ## au4 0.37 0.44 0.12 0.07 0.02
    ## au5 0.22 0.30 0.28 0.20 0.02
    ## au6 0.37 0.37 0.17 0.10 0.02
    ## au7 0.12 0.32 0.37 0.19 0.02
    ## au8 0.30 0.43 0.19 0.08 0.02
    ## au9 0.20 0.42 0.27 0.12 0.03

> Nota: el Alpha obtenido esta por sobre lo esperado (alpha &gt; .7).
> Puntajes totales generados con las respuestas a estos nuevos 9 items,
> presentan una alta confiabilidad.

# Anexos

## Componentes del output de un psych::alpha

-   Raw\_alpha: basado en covarianzas
-   Std.alpha: basado en correlaciones
-   G6(smc): Indice de Guttman
-   Average\_r: Correlación media inter item
-   Ase: error estándar de la escala
-   Mean: Promedio de la escala
-   Sd: desviación estándar de la escala
-   raw.r : Correlación item-test
-   std.r: correlacion estandarizada
-   r.cor: Correlación con la escala controlando la interacción con
    otros ítems
-   r.drop: Correlación ítem con la escala que se arma sin ese ítem
-   mean: Promedio del ítem
-   sd: desviación estándar del ítem
