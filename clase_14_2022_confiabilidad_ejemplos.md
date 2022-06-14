Asociación entre variables
================

# Confiabilidad de puntajes

-   Ejemplos de
    ![\alpha](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Calpha "\alpha")
    de Cronbach

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

library(dplyr)
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

| final_selection | var_name | variable | item_text                                                                                                        |
|:----------------|:---------|:---------|:-----------------------------------------------------------------------------------------------------------------|
| yes             | IS3G22A  | td1      | \[R\] Political leaders give government jobs to their family members.                                            |
| yes             | IS3G22B  | td2      | \[R\] One company or the government owns all newspapers in a country.                                            |
| yes             | IS3G22C  | td3      | People are allowed to publicly criticize the government.                                                         |
| yes             | IS3G22D  | td4      | All adult citizens have the right to elect their political leaders.                                              |
| yes             | IS3G22E  | td5      | People are able to protest if they think a law is unfair.                                                        |
| yes             | IS3G22F  | td6      | \[R\] The police have the right to hold people suspected of threatening national security in jail without trial. |
| no              | IS3G22G  | td7      | Differences in income between poor and rich people are small.                                                    |
| yes             | IS3G22H  | td8      | \[R\] The government influences decisions by courts of justice.                                                  |
| yes             | IS3G22I  | td9      | All <ethnic/racial> groups in the country have the same rights.                                                  |

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

| value | response_label                     |
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

| id_i | td1 | td2 | td3 | td4 | td5 | td6 | td7 | td8 | td9 |
|-----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
| 5898 |   1 |   1 |   0 |   1 |   0 |   0 |   0 |   1 |   1 |
| 5899 |   0 |   1 |   1 |   1 |   1 |   0 |   1 |   0 |   1 |
| 5900 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   0 |   1 |
| 5901 |   1 |   1 |   1 |   0 |   1 |   1 |   1 |   1 |   0 |
| 5902 |   0 |   1 |   1 |   1 |   1 |   1 |   0 |   1 |   1 |
| 5903 |   0 |   1 |   1 |   1 |   1 |   1 |   1 |   0 |   1 |
| 5904 |   0 |   1 |   1 |   0 |   0 |   0 |   0 |   0 |   0 |
| 5905 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |
| 5906 |   1 |   1 |   1 |   1 |   1 |   0 |   0 |   1 |   1 |
| 5907 |   1 |   1 |   0 |   1 |   1 |   1 |   0 |   1 |   1 |

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
    ##     95% confidence boundaries 
    ##          lower alpha upper
    ## Feldt     0.54  0.55  0.55
    ## Duhachek  0.54  0.55  0.55
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
    ##     95% confidence boundaries 
    ##       lower alpha upper
    ## Feldt -0.09  0.54  0.88
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

``` r
# -----------------------------------------------------------------------------
# alpha computes with selected items
# -----------------------------------------------------------------------------

#------------------------------------------------
# alpha with psych
#------------------------------------------------

items_data %>%
dplyr::select(td2, td4, td5,td9) %>%
psych::alpha()
```

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r S/N    ase mean  sd median_r
    ##        0.5      0.51    0.45      0.21   1 0.0051 0.63 0.3      0.2
    ## 
    ##     95% confidence boundaries 
    ##          lower alpha upper
    ## Feldt     0.49   0.5  0.51
    ## Duhachek  0.49   0.5  0.51
    ## 
    ##  Reliability if an item is dropped:
    ##     raw_alpha std.alpha G6(smc) average_r  S/N alpha se   var.r med.r
    ## td2      0.54      0.54    0.44      0.28 1.18   0.0050 0.00079  0.29
    ## td4      0.38      0.38    0.30      0.17 0.61   0.0068 0.00491  0.13
    ## td5      0.40      0.41    0.32      0.19 0.69   0.0066 0.00837  0.14
    ## td9      0.41      0.42    0.33      0.19 0.72   0.0065 0.00931  0.14
    ## 
    ##  Item statistics 
    ##         n raw.r std.r r.cor r.drop mean   sd
    ## td2 24328  0.58  0.55  0.25   0.18 0.43 0.50
    ## td4 24340  0.65  0.68  0.52   0.37 0.80 0.40
    ## td5 24319  0.67  0.66  0.48   0.33 0.64 0.48
    ## td9 24370  0.66  0.65  0.46   0.32 0.67 0.47
    ## 
    ## Non missing response frequency for each item
    ##        0    1 miss
    ## td2 0.57 0.43 0.04
    ## td4 0.20 0.80 0.04
    ## td5 0.36 0.64 0.04
    ## td9 0.33 0.67 0.04

> Nota: el Alpha obtenido es más bajo de lo esperado (alpha \< .7). Bajo
> la convención de que puntajes con alpha menor .7 no debieran ser
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

| id_i | au1 | au2 | au3 | au4 | au5 | au6 | au7 | au8 | au9 |
|-----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
| 5898 |   2 |   1 |   2 |   1 |   2 |   1 |   2 |   1 |   3 |
| 5899 |   1 |   2 |   4 |   2 |   2 |   3 |   2 |   2 |   2 |
| 5900 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |   1 |
| 5901 |   1 |   1 |   2 |   1 |   1 |   1 |   1 |   1 |   2 |
| 5902 |   1 |   1 |   2 |   1 |   1 |   1 |   1 |   1 |   1 |
| 5903 |   1 |   1 |   1 |   1 |   1 |   3 |   2 |   1 |   1 |
| 5904 |   2 |   3 |   2 |   1 |   2 |   1 |   2 |   2 |   2 |
| 5905 |   1 |   1 |   1 |   1 |   2 |   1 |   2 |   1 |   1 |
| 5906 |   1 |   2 |   3 |   2 |   1 |   1 |   1 |   1 |   2 |
| 5907 |   2 |   2 |   2 |   2 |   2 |   2 |   2 |   2 |   2 |

``` r
# -----------------------------------------------------------------------------
# alpha computes
# -----------------------------------------------------------------------------

#------------------------------------------------
# alpha with psych
#------------------------------------------------

data_aut %>%
dplyr::select(au1:au9) %>%
psych::alpha()
```

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r S/N    ase mean   sd median_r
    ##       0.87      0.87    0.86      0.42 6.5 0.0013  2.2 0.66     0.41
    ## 
    ##     95% confidence boundaries 
    ##          lower alpha upper
    ## Feldt     0.86  0.87  0.87
    ## Duhachek  0.86  0.87  0.87
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

> Nota: el Alpha obtenido esta por sobre lo esperado (alpha \> .7).
> Puntajes totales generados con las respuestas a estos nuevos 9 items,
> presentan una alta confiabilidad.

## Apoyo a la equidad de género

-   Ejemplo de escala con un alpha aceptable

``` r
# -----------------------------------------------------------------------------
# geneql, apoyo a la equidad de genero
# -----------------------------------------------------------------------------


# -----------------------------------------------
# reverse function
# -----------------------------------------------

reverse <- function (var)  {
    var <- labelled::remove_labels(var)
    var <- haven::zap_labels(var)
    max <- max(var, na.rm = TRUE)
    min <- min(var, na.rm = TRUE)
    return(max + min - var)
}

# -----------------------------------------------
# mean score function
# -----------------------------------------------

mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}



# -----------------------------------------------
# load data
# -----------------------------------------------

data_gen <- psi2301::iccs_16_lat %>%
            mutate(ge1 = r4sda::reverse(IS3G24A)) %>%
            mutate(ge2 = r4sda::reverse(IS3G24B)) %>%
            mutate(ge3 = r4sda::reverse(IS3G24C)) %>%
            mutate(ge4 = r4sda::reverse(IS3G24D)) %>%
            mutate(ge5 = r4sda::reverse(IS3G24E)) %>%
            mutate(ge6 = r4sda::reverse(IS3G24F)) %>%
            # reverse responses to expected direction
            mutate(ge3r = r4sda::reverse(ge3)) %>%
            mutate(ge4r = r4sda::reverse(ge4)) %>%
            mutate(ge6r = r4sda::reverse(ge6)) %>%
            # create mean_score
            mutate(gen_score = mean_score(ge1, ge2, ge3r, ge4r, ge5, ge6r)) %>%
            dplyr::select(id_i, ge1:ge6r)

# -----------------------------------------------
# items table
# -----------------------------------------------

# ge1   !Los hombres y las mujeres deberían tener las mismas oportunidades de participar en el gobierno ..
# ge2   !Los hombres y las mujeres deberían tener los mismos derechos en todos los aspectos
# ge3   ![R] Las mujeres deberían permanecer alejadas de la política
# ge4   ![R] Cuando no hay muchos trabajos disponibles, los hombres deberían tener más derecho a un trabajo que las mujeres
# ge5   !Los hombres y las mujeres deberían recibir el mismo pago cuando hacen los mismos trabajos
# ge6   ![R] Los hombres están mejor preparados para ser líderes políticos que las mujeres.


#------------------------------------------------
# display ten cases
#------------------------------------------------

data_gen[1:10,] %>%
knitr::kable()
```

| id_i | ge1 | ge2 | ge3 | ge4 | ge5 | ge6 | ge3r | ge4r | ge6r |
|-----:|----:|----:|----:|----:|----:|----:|-----:|-----:|-----:|
| 5898 |   4 |   4 |   2 |   2 |   4 |   2 |    3 |    3 |    3 |
| 5899 |   3 |   3 |   2 |   2 |   3 |   2 |    3 |    3 |    3 |
| 5900 |   4 |   4 |   1 |   1 |   4 |   1 |    4 |    4 |    4 |
| 5901 |   4 |   4 |   2 |   2 |   4 |   2 |    3 |    3 |    3 |
| 5902 |   4 |   4 |   1 |   1 |   4 |   1 |    4 |    4 |    4 |
| 5903 |   4 |   4 |   1 |   1 |   4 |   1 |    4 |    4 |    4 |
| 5904 |   4 |   4 |   1 |   1 |   4 |   1 |    4 |    4 |    4 |
| 5905 |   4 |   4 |   1 |   1 |   4 |   1 |    4 |    4 |    4 |
| 5906 |   4 |   4 |   1 |   1 |   4 |   1 |    4 |    4 |    4 |
| 5907 |   4 |   4 |   1 |   1 |   4 |   1 |    4 |    4 |    4 |

``` r
# -----------------------------------------------------------------------------
# alpha computes
# -----------------------------------------------------------------------------

#------------------------------------------------
# alpha with psych
#------------------------------------------------

data_gen %>%
dplyr::select(ge1, ge2, ge3r, ge4r, ge5, ge6r) %>%
psych::alpha()
```

    ## 
    ## Reliability analysis   
    ## Call: psych::alpha(x = .)
    ## 
    ##   raw_alpha std.alpha G6(smc) average_r S/N    ase mean   sd median_r
    ##       0.69       0.7    0.72      0.28 2.3 0.0028  3.3 0.54     0.19
    ## 
    ##     95% confidence boundaries 
    ##          lower alpha upper
    ## Feldt     0.68  0.69   0.7
    ## Duhachek  0.68  0.69   0.7
    ## 
    ##  Reliability if an item is dropped:
    ##      raw_alpha std.alpha G6(smc) average_r S/N alpha se var.r med.r
    ## ge1       0.68      0.67    0.67      0.28 2.0   0.0029 0.033  0.19
    ## ge2       0.67      0.66    0.66      0.28 1.9   0.0029 0.034  0.18
    ## ge3r      0.66      0.68    0.70      0.30 2.2   0.0032 0.030  0.19
    ## ge4r      0.59      0.64    0.63      0.26 1.8   0.0040 0.026  0.19
    ## ge5       0.68      0.67    0.69      0.29 2.1   0.0028 0.037  0.18
    ## ge6r      0.59      0.63    0.64      0.26 1.7   0.0039 0.029  0.17
    ## 
    ##  Item statistics 
    ##          n raw.r std.r r.cor r.drop mean   sd
    ## ge1  24563  0.49  0.62  0.51   0.34  3.7 0.52
    ## ge2  24419  0.52  0.64  0.54   0.36  3.7 0.59
    ## ge3r 24150  0.67  0.57  0.44   0.42  2.9 1.04
    ## ge4r 24287  0.78  0.68  0.63   0.57  2.9 1.07
    ## ge5  24223  0.50  0.59  0.46   0.31  3.6 0.68
    ## ge6r 24224  0.77  0.69  0.63   0.58  3.0 1.02
    ## 
    ## Non missing response frequency for each item
    ##         1    2    3    4 miss
    ## ge1  0.01 0.02 0.20 0.78 0.03
    ## ge2  0.01 0.04 0.22 0.73 0.04
    ## ge3r 0.13 0.18 0.32 0.37 0.05
    ## ge4r 0.16 0.16 0.31 0.36 0.04
    ## ge5  0.02 0.05 0.21 0.72 0.04
    ## ge6r 0.13 0.16 0.34 0.38 0.04

# Anexos

## Componentes del output de un psych::alpha

-   Raw_alpha: basado en covarianzas
-   Std.alpha: basado en correlaciones
-   G6(smc): Indice de Guttman
-   Average_r: Correlación media inter item
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
