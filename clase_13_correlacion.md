Asociación entre variables
================

# Asociación entre variables

-   Ejemplos de r

## Correlación

-   Calculo de correlación por pasos

``` r
#------------------------------------------------------------------------------
# correlation by steps
#------------------------------------------------------------------------------

# -----------------------------------------------
# load data
# -----------------------------------------------

url_file <- 'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/correlation_example.csv'
data_correlation <- readr::read_csv(url_file)
```

    ## 
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ## cols(
    ##   x = col_double(),
    ##   y = col_double()
    ## )

``` r
# -----------------------------------------------
# display data
# -----------------------------------------------

data_correlation[1:10,] %>%
knitr::kable(., digits = 2)
```

|     x |      y |
|------:|-------:|
| 42.90 | 506.45 |
| 46.79 | 454.08 |
| 64.63 | 612.95 |
| 52.47 | 496.24 |
| 50.67 | 433.61 |
| 35.71 | 607.49 |
| 67.26 | 438.84 |
| 38.79 | 473.49 |
| 59.50 | 440.30 |
| 58.30 | 604.08 |

``` r
# -----------------------------------------------
# generate components
# -----------------------------------------------

data_corr <- data_correlation %>%
             # mean of x
             mutate(x_bar = mean(x, na.rm = TRUE)) %>%
             # mean of y
             mutate(y_bar = mean(y, na.rm = TRUE)) %>%
             # deviations from x             
             mutate(x_dev = x - x_bar) %>%
             # deviations from y     
             mutate(y_dev = y - y_bar) %>%
             # cross products of deviations     
             mutate(cross = x_dev*y_dev) %>%
             # square of x_dev             
             mutate(x_var = x_dev^2) %>%
             # square of y_dev           
             mutate(y_var = y_dev^2)

# -----------------------------------------------
# display components
# -----------------------------------------------

data_corr[1:10,] %>%
knitr::kable(., digits = 2)
```

|     x |      y | x\_bar | y\_bar | x\_dev | y\_dev |    cross | x\_var |   y\_var |
|------:|-------:|-------:|-------:|-------:|-------:|---------:|-------:|---------:|
| 42.90 | 506.45 |  50.75 | 500.56 |  -7.85 |   5.89 |   -46.25 |  61.69 |    34.68 |
| 46.79 | 454.08 |  50.75 | 500.56 |  -3.96 | -46.48 |   184.28 |  15.72 |  2160.50 |
| 64.63 | 612.95 |  50.75 | 500.56 |  13.88 | 112.39 |  1559.44 | 192.53 | 12631.24 |
| 52.47 | 496.24 |  50.75 | 500.56 |   1.72 |  -4.32 |    -7.41 |   2.94 |    18.67 |
| 50.67 | 433.61 |  50.75 | 500.56 |  -0.08 | -66.95 |     5.66 |   0.01 |  4482.46 |
| 35.71 | 607.49 |  50.75 | 500.56 | -15.04 | 106.93 | -1608.70 | 226.34 | 11433.77 |
| 67.26 | 438.84 |  50.75 | 500.56 |  16.51 | -61.72 | -1018.73 | 272.43 |  3809.51 |
| 38.79 | 473.49 |  50.75 | 500.56 | -11.96 | -27.07 |   323.90 | 143.15 |   732.85 |
| 59.50 | 440.30 |  50.75 | 500.56 |   8.75 | -60.26 |  -527.01 |  76.48 |  3631.41 |
| 58.30 | 604.08 |  50.75 | 500.56 |   7.55 | 103.52 |   781.09 |  56.93 | 10716.14 |

``` r
# -----------------------------------------------
# terms of correlation formula
# -----------------------------------------------

covariance  <- sum(data_corr$cross)
denominator <- sqrt(sum(data_corr$x_var)*sum(data_corr$y_var))

# -----------------------------------------------
# get correlation
# -----------------------------------------------

covariance/denominator
```

    ## [1] -0.5627226

``` r
# -----------------------------------------------
# get correlation via stats::cor()
# -----------------------------------------------

cor(data_corr$y, data_corr$x)
```

    ## [1] -0.5627226

## Correlación entre Conocimiento Cívico y Tolerancia a la Corrupción

``` r
#------------------------------------------------------------------------------
# Carrasco & Pavón (2021)
#------------------------------------------------------------------------------

# -----------------------------------------------
# data example
# -----------------------------------------------

set.seed(12345678)
library(dplyr)
data_tol <- psi2301::iccs_16_lat %>%
            group_by(COUNTRY) %>%
            dplyr::sample_n(100, weights = ws) %>%
            ungroup()


# Nota: tomamos una muestra aleatoria de 100 casos por país
#       de los datos de ICCS 2016, de latinoamérica.

#------------------------------------------------
# correlation via stats::cor()
#------------------------------------------------

cor(x = data_tol$L_ATTCORR, 
    y = data_tol$PV1CIV,
    use = 'complete.obs',
    method = 'pearson')
```

    ## [1] -0.5639312

``` r
#------------------------------------------------
# correlation via stats::cor(), get p value
#------------------------------------------------

cor.test(
    x = data_tol$L_ATTCORR, 
    y = data_tol$PV1CIV,
    use = 'complete.obs',
    method = 'pearson',
    conf.level = .95)
```

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  data_tol$L_ATTCORR and data_tol$PV1CIV
    ## t = -15.131, df = 491, p-value < 2.2e-16
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.6213009 -0.5005478
    ## sample estimates:
    ##        cor 
    ## -0.5639312

``` r
#------------------------------------------------
# get amount of observations
#------------------------------------------------

data_tol %>%
dplyr::select(L_ATTCORR, PV1CIV) %>%
na.omit() %>%
nrow()
```

    ## [1] 493

``` r
#------------------------------------------------
# correlation via corrr::correlate()
#------------------------------------------------

data_tol %>%
dplyr::select(L_ATTCORR, PV1CIV) %>%
r4sda::remove_labels() %>%
corrr::correlate() %>%
knitr::kable(., digits = 2)
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

| term       | L\_ATTCORR | PV1CIV |
|:-----------|-----------:|-------:|
| L\_ATTCORR |         NA |  -0.56 |
| PV1CIV     |      -0.56 |     NA |

## Generación de matrices de correlación

``` r
#------------------------------------------------------------------------------
# Carrasco & Pavón (2021)
#------------------------------------------------------------------------------

# -----------------------------------------------
# data example
# -----------------------------------------------

set.seed(12345678)
library(dplyr)
data_tol <- psi2301::iccs_16_lat %>%
            group_by(COUNTRY) %>%
            dplyr::sample_n(100, weights = ws) %>%
            ungroup()


# Nota: tomamos una muestra aleatoria de 100 casos por país
#       de los datos de ICCS 2016, de latinoamérica.

#------------------------------------------------
# tabla de variables
#------------------------------------------------

data_tol %>%
r4sda::variables_table() %>%
knitr::kable()
```

| variable       | type      | values                                                 | labels                                                                                                                                        |
|:---------------|:----------|:-------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------|
| COUNTRY        | chr       | “,”CHL“,”CHL“,”CHL“,”CHL“,”CHL“,”CHL“,”CHL“,”…         | Participant Alphanumeric Code                                                                                                                 |
| IDCNTRY        | hvn\_lbll | 152, 152, 152, 152, 152, 152, 152, 152, 152, 152, 15…  | Participant Code                                                                                                                              |
| IDSTUD         | hvn\_lbll | 10910103, 11680122, 10230131, 10210125, 10530204, 10…  | STUDENT ID                                                                                                                                    |
| IDSCHOOL       | hvn\_lbll | 1091, 1168, 1023, 1021, 1053, 1058, 1148, 1109, 1173…  | SCHOOL ID                                                                                                                                     |
| IDCLASS        | hvn\_lbll | 109101, 116801, 102301, 102101, 105302, 105805, 1148…  | CLASS ID                                                                                                                                      |
| IDGRADE        | hvn\_lbll | 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8…  | Grade ID                                                                                                                                      |
| IDPOP          | hvn\_lbll | 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2…  | Population ID                                                                                                                                 |
| IS3G03         | hvn\_lbll | 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2…  | About You/What is the highest level of education you expect to complete                                                                       |
| IS3G03BA       | hvn\_lbll | 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Your Home and your Family/Do any of these people live at home with you most or all of the time/Mother                                         |
| IS3G03BB       | hvn\_lbll | 2, 2, 2, 2, 1, 2, 2, NA, 2, NA, 2, 2, 2, 2, 2, 2, 2,…  | Your Home and your Family/Do any of these people live at home with you most or all of the time/Other <female guardian>                        |
| IS3G03BC       | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 1…  | Your Home and your Family/Do any of these people live at home with you most or all of the time/Father                                         |
| IS3G03BD       | hvn\_lbll | 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 1, 2, 2, 2…  | Your Home and your Family/Do any of these people live at home with you most or all of the time/Other <male guardian>                          |
| IS3G03BE       | hvn\_lbll | 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1…  | Your Home and your Family/Do any of these people live at home with you most or all of the time/Siblings                                       |
| IS3G03BF       | hvn\_lbll | 1, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 2, 1, 2, 2…  | Your Home and your Family/Do any of these people live at home with you most or all of the time/Grandparents                                   |
| IS3G03BG       | hvn\_lbll | 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2…  | Your Home and your Family/Do any of these people live at home with you most or all of the time/Others                                         |
| IS3G04A        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Your Home and your Family/In what country were you and your parents born/You                                                                  |
| IS3G04B        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Your Home and your Family/In what country were you and your parents born/Mother or <female guardian>                                          |
| IS3G04C        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Your Home and your Family/In what country were you and your parents born/Father or <male guardian>                                            |
| IS3G05         | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Your Home and your Family/What language do you speak at home most of the time                                                                 |
| IS3G07         | hvn\_lbll | 3, 4, 3, 2, 3, 3, 3, 5, 2, 3, 3, 2, 3, 3, 3, 3, 1, 3…  | Your Home and your Family/What is the highest level of education completed by your mother or <female guardian>                                |
| IS3G09         | hvn\_lbll | 3, 3, 3, 1, 3, 1, 2, 2, 1, 3, 3, 2, 4, 3, 3, 3, 1, 3…  | Your Home and your Family/What is the highest level of education completed by your father or <male guardian>                                  |
| IS3G10A        | hvn\_lbll | 3, 3, 3, 2, 4, 3, 2, 4, 3, 4, 2, 3, 3, 3, 4, 3, 3, 3…  | Your Home and your Family/How interested in political and social issues/You                                                                   |
| IS3G10B        | hvn\_lbll | 4, 2, 2, 2, 3, 1, 1, 3, 4, 3, 1, 3, 2, 2, 3, 3, 2, 3…  | Your Home and your Family/How interested in political and social issues/Mother or <female guardian>                                           |
| IS3G10C        | hvn\_lbll | 2, 2, 2, 2, 3, 1, 1, 3, 4, 3, 3, 2, 2, 3, 3, 3, 3, 2…  | Your Home and your Family/How interested in political and social issues/Father or <male guardian>                                             |
| IS3G11         | hvn\_lbll | 2, 3, 3, 4, 1, 3, 3, 1, 5, 1, 1, 2, 3, 2, 1, 2, 3, 2…  | Your Home and your Family/About how many books are there in your home                                                                         |
| IS3G12A        | hvn\_lbll | 2, 2, 4, 3, 4, 4, 3, 2, 4, 1, 2, 3, 2, 3, 2, 4, 3, 3…  | Your Home and your Family/How many devices are used regularly/Desktop or portable computers (laptop, notebook or netbook)                     |
| IS3G12B        | hvn\_lbll | 2, 1, 4, 3, 1, 3, 3, NA, 2, 2, 1, 4, 3, NA, 3, 2, 2,…  | Your Home and your Family/How many devices are used regularly/Tablet devices or e-readers (e.g. <iPad> or <Kindle>)                           |
| IS3G12C        | hvn\_lbll | 4, 4, 4, 4, 4, 4, 4, NA, 4, 3, 3, 4, 2, NA, 4, 4, 4,…  | Your Home and your Family/How many devices are used regularly/Mobile phones with internet access (e.g. <smart phones>)                        |
| IS3G13         | hvn\_lbll | 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 2, 1, 1, 1, 2, 1…  | Your Home and your Family/Do you have an Internet connection at home                                                                          |
| IS3G14A        | hvn\_lbll | 1, 2, 1, 2, 1, 1, 4, 1, 1, 1, 2, 1, NA, 3, 1, 1, 3, …  | Your Activities Outside School/How often involved/Talking with your parent(s) about political or social issues                                |
| IS3G14B        | hvn\_lbll | 4, 4, 4, 4, 4, 3, 4, 2, 3, 4, 4, 1, NA, 4, 4, 4, 4, …  | Your Activities Outside School/How often involved/Watching television to inform about national and international news                         |
| IS3G14C        | hvn\_lbll | 1, 2, 3, 3, 1, 1, 3, 2, 1, 3, 3, 1, 1, 3, 1, 2, 2, 1…  | Your Activities Outside School/How often involved/Reading newspaper to inform about national and international news                           |
| IS3G14D        | hvn\_lbll | 1, 1, 1, 2, 2, 1, 2, NA, 1, 1, 2, 1, 1, 1, 1, 1, 1, …  | Your Activities Outside School/How often involved/Talking with friends about political or social issues                                       |
| IS3G14E        | hvn\_lbll | 4, 3, 2, 3, 2, 1, 4, 2, 1, 3, 3, 2, 2, 2, 1, 2, 3, 1…  | Your Activities Outside School/How often involved/Talking with your parent(s) about what is happening in other countries                      |
| IS3G14F        | hvn\_lbll | 4, 2, 2, 2, 2, 1, 2, 3, 2, 1, 2, 2, 2, 3, 1, 2, 1, 2…  | Your Activities Outside School/How often involved/Talking with friends about what is happening in other countries                             |
| IS3G14G        | hvn\_lbll | 2, 2, 1, 2, 1, 1, 4, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1…  | Your Activities Outside School/How often involved/Using internet to find information about political or social issues                         |
| IS3G14H        | hvn\_lbll | 1, 2, 1, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Your Activities Outside School/How often involved/Posting a comment or image regarding a political or social issue on the internet            |
| IS3G14I        | hvn\_lbll | 1, 2, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Your Activities Outside School/How often involved/Sharing or commenting on another person’s online post regarding a political or social issue |
| IS3G15A        | hvn\_lbll | 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3…  | Your Activities Outside School/Have you ever been involved/A youth organisation affiliated with political party or union                      |
| IS3G15B        | hvn\_lbll | 2, 1, 3, 1, 3, 3, 2, 2, 3, 3, 2, 2, 2, 3, 3, 1, 3, 3…  | Your Activities Outside School/Have you ever been involved/An environmental action group or organisation                                      |
| IS3G15C        | hvn\_lbll | 3, 3, 2, 3, 3, 3, 3, 2, 3, 3, 2, 2, 2, 3, 3, 2, 3, 3…  | Your Activities Outside School/Have you ever been involved/A Human Rights organisation                                                        |
| IS3G15D        | hvn\_lbll | 3, 1, 3, 1, 3, 3, 3, 2, 3, 2, 2, 2, 3, 2, 3, 1, 3, 3…  | Your Activities Outside School/Have you ever been involved/A voluntary group doing something to help the community                            |
| IS3G15E        | hvn\_lbll | 2, 1, 2, 1, 3, 3, 2, 3, 3, 3, 2, 1, 2, 2, 3, 1, 3, 3…  | Your Activities Outside School/Have you ever been involved/An organisation collecting money for a social cause                                |
| IS3G15F        | hvn\_lbll | 3, 2, 2, 1, 3, 3, 1, 3, 3, 3, 2, 1, 1, 3, 3, 1, 3, 3…  | Your Activities Outside School/Have you ever been involved/A group of young people campaigning for an issue                                   |
| IS3G15G        | hvn\_lbll | 2, 2, 2, 3, 3, 3, 3, 2, 3, 3, 3, 2, 3, 3, 3, 1, 3, 3…  | Your Activities Outside School/Have you ever been involved/An animal rights or animal welfare group                                           |
| IS3G15H        | hvn\_lbll | 2, 1, 3, 3, 1, 1, 2, 3, 3, 3, 3, 2, 3, 3, 3, 2, 1, 3…  | Your Activities Outside School/Have you ever been involved/A religious group or organisation                                                  |
| IS3G15I        | hvn\_lbll | 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3…  | Your Activities Outside School/Have you ever been involved/A community youth group (such as &lt;boys/girls scouts, YMCA&gt;)                  |
| IS3G15J        | hvn\_lbll | 1, 1, 2, 1, 3, 2, 1, 2, 3, 3, 1, 1, 1, 1, 3, 1, 3, 1…  | Your Activities Outside School/Have you ever been involved/A sports team                                                                      |
| IS3G16A        | hvn\_lbll | 3, 3, 3, 3, 3, 3, 2, 1, 2, 2, 2, 3, 2, 2, 1, 1, 3, 2…  | Your School/At school, have you ever done/Active participation in an organised debate                                                         |
| IS3G16B        | hvn\_lbll | 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1…  | Your School/At school, have you ever done/Voting for <class representative> or <school parliament>                                            |
| IS3G16C        | hvn\_lbll | 3, 1, 2, 3, 2, 3, 3, 1, 3, 3, 1, 1, 3, 2, 3, 1, 3, 3…  | Your School/At school, have you ever done/Taking part in decision-making about how the school is run                                          |
| IS3G16D        | hvn\_lbll | 3, 3, 3, 3, 2, 3, 3, 2, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3…  | Your School/At school, have you ever done/Taking part in discussions at a <student assembly>                                                  |
| IS3G16E        | hvn\_lbll | 3, 2, 3, 1, 3, 3, 3, 2, 3, 3, 2, 3, 2, 2, 2, 1, 2, 3…  | Your School/At school, have you ever done/Becoming a candidate for <class representative> or <school parliament>                              |
| IS3G16F        | hvn\_lbll | 1, 2, 3, 1, 3, 3, 3, 1, 2, 3, 3, 1, 3, 2, 3, 3, 3, 3…  | Your School/At school, have you ever done/Participating in an activity to make school more <environmentally friendly>                         |
| IS3G16G        | hvn\_lbll | 1, 2, 3, 3, 2, 3, 2, 1, 2, 2, 3, 1, 3, 1, 2, 1, 3, 3…  | Your School/At school, have you ever done/Voluntary participation in school based music or drama activities outside of regular classes        |
| IS3G17A        | hvn\_lbll | 4, 3, 4, 3, 3, 3, 4, 2, 4, 3, 4, 4, 4, 3, 2, 3, 4, 1…  | Your School/Discussing issues, how often happen/Teachers encourage students to make up their own minds                                        |
| IS3G17B        | hvn\_lbll | 4, 3, 4, 3, 2, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 4, 4, 2…  | Your School/Discussing issues, how often happen/Teachers encourage students to express their opinions                                         |
| IS3G17C        | hvn\_lbll | 1, 2, NA, 2, 2, 2, 2, 2, 3, 2, 3, 4, 1, 3, 1, 3, 2, …  | Your School/Discussing issues, how often happen/Students bring up current political events for discussion in class                            |
| IS3G17D        | hvn\_lbll | 3, 3, NA, 2, 3, 4, 4, 1, 4, 2, 2, 4, 3, 3, 3, 3, 4, …  | Your School/Discussing issues, how often happen/Students express opinions in class even when opinions are different                           |
| IS3G17E        | hvn\_lbll | 4, 3, NA, 2, 2, 3, 2, 1, 4, 3, 3, 4, 2, 3, 2, 3, 4, …  | Your School/Discussing issues, how often happen/Teachers encourage to discuss with people having different opinions                           |
| IS3G17F        | hvn\_lbll | 4, 3, 4, 3, 2, 3, 3, 2, 4, 2, 3, 4, 4, 3, 2, 3, 4, 1…  | Your School/Discussing issues, how often happen/Teachers present several sides of issues when explaining them in class                        |
| IS3G18A        | hvn\_lbll | 2, 2, 2, 2, 2, 2, 2, 3, 1, 2, 1, 2, 4, 2, 3, 1, 1, 4…  | Your School/At school, to what extent have you learned/How citizens can vote in local or national elections                                   |
| IS3G18B        | hvn\_lbll | 3, 2, 2, 3, 2, 3, 4, 3, 2, 3, 1, 2, 3, 2, 3, 1, 1, 4…  | Your School/At school, to what extent have you learned/How laws are introduced and changed in <country of test>                               |
| IS3G18C        | hvn\_lbll | 2, 1, 3, 2, 2, 2, 3, 4, 1, 2, 1, 1, 1, 2, 1, 1, 2, 2…  | Your School/At school, to what extent have you learned/How to protect the environment                                                         |
| IS3G18D        | hvn\_lbll | 4, 2, 2, 3, 3, 4, 4, 3, 3, 2, 1, 1, 1, 2, 3, 1, 3, 4…  | Your School/At school, to what extent have you learned/How to contribute to solving problems in the <local community>                         |
| IS3G18E        | hvn\_lbll | 3, 2, 2, 3, 2, 2, 3, 4, 3, 3, 1, 2, 3, 2, 2, 1, 3, 4…  | Your School/At school, to what extent have you learned/How citizen rights are protected in <country of test>                                  |
| IS3G18F        | hvn\_lbll | 4, 3, 4, 3, 2, 3, 3, 3, 3, 3, 1, 2, 4, 2, 3, 1, 3, 4…  | Your School/At school, to what extent have you learned/Political issues and events in other countries                                         |
| IS3G18G        | hvn\_lbll | 4, 3, 3, 3, 3, 3, 4, 3, 3, 3, 1, 3, 4, 2, 2, 1, 1, 4…  | Your School/At school, to what extent have you learned/How the economy works                                                                  |
| IS3G19A        | hvn\_lbll | 1, 2, 2, 3, 2, 1, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 2…  | Your School/Teachers and students at your school/Most of my teachers treat me fairly                                                          |
| IS3G19B        | hvn\_lbll | 1, 1, 3, 3, 3, 2, 2, 1, 2, 3, 3, 1, 2, 2, 2, 1, 1, 2…  | Your School/Teachers and students at your school/Students get along well with most teachers                                                   |
| IS3G19C        | hvn\_lbll | 1, 2, 2, 2, 2, 1, 2, 2, 1, 3, 2, 1, 1, 1, 1, 2, 1, 3…  | Your School/Teachers and students at your school/Most teachers are interested in students’ well-being                                         |
| IS3G19D        | hvn\_lbll | 1, 3, 2, 3, 2, 2, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 3…  | Your School/Teachers and students at your school/Most of my teachers listen to what I have to say                                             |
| IS3G19E        | hvn\_lbll | 1, 3, 2, 2, 2, 2, 2, 2, 1, 3, 1, 2, 1, 1, 2, 2, 1, 3…  | Your School/Teachers and students at your school/If I need extra help, I receive it from my teachers                                          |
| IS3G19F        | hvn\_lbll | 1, 2, 2, 3, 2, 1, 1, 4, 1, 3, 1, 1, 1, 1, 2, 4, 1, 2…  | Your School/Teachers and students at your school/Most teachers would stop students from being bullied                                         |
| IS3G19G        | hvn\_lbll | 4, 2, 3, 3, 3, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4, 3, 4…  | Your School/Teachers and students at your school/Most students at my school treat each other with respect                                     |
| IS3G19H        | hvn\_lbll | 3, 2, 2, 3, 3, 2, 2, 1, 2, 2, 3, 1, 3, 2, 2, 4, 3, 3…  | Your School/Teachers and students at your school/Most students at my school get along well with each other                                    |
| IS3G19I        | hvn\_lbll | 2, 3, 3, 2, 2, 2, 2, 1, 2, 2, 1, 1, 3, 2, 2, 4, 3, 1…  | Your School/Teachers and students at your school/My school is a place where students feel safe                                                |
| IS3G19J        | hvn\_lbll | 4, 2, 4, 3, 4, 4, 4, 4, 3, 3, 4, 1, 3, 4, 3, 4, 3, 4…  | Your School/Teachers and students at your school/I am afraid of being bullied by other students                                               |
| IS3G20A        | hvn\_lbll | 1, 2, 1, 2, 2, 1, 3, 1, 1, 1, 1, 3, 1, 1, 4, 4, 1, 2…  | Your School/How often did you experience/A student called you by an offensive nickname                                                        |
| IS3G20B        | hvn\_lbll | 1, 2, 1, 3, 3, 1, 1, 1, 1, 1, 1, 2, 2, 1, 3, 4, 4, 2…  | Your School/How often did you experience/A student said things about you to make others laugh                                                 |
| IS3G20C        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 3, 1, 1…  | Your School/How often did you experience/A student threatened to hurt you                                                                     |
| IS3G20D        | hvn\_lbll | 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1…  | Your School/How often did you experience/You were physically attacked by another student                                                      |
| IS3G20E        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1…  | Your School/How often did you experience/A student broke something belonging to you on purpose                                                |
| IS3G20F        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1…  | Your School/How often did you experience/A student posted offensive pictures or text about you on the Internet                                |
| IS3G21A        | hvn\_lbll | 1, 2, 2, 2, 1, 1, 2, 4, 2, 2, 1, 1, 2, 1, 1, 2, 3, 2…  | Your School/Student participation/Student participation in how schools are run can make schools better                                        |
| IS3G21B        | hvn\_lbll | 1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2…  | Your School/Student participation/Lots of positive changes can happen in schools when students work together                                  |
| IS3G21C        | hvn\_lbll | 1, 2, 2, 2, 3, 2, 2, 1, 2, 2, 2, 1, 2, 1, 1, 4, 1, 2…  | Your School/Student participation/Organising groups of students to express their opinions could help solve problems                           |
| IS3G21D        | hvn\_lbll | 1, 2, 2, 2, 2, 2, 2, 3, 2, 2, 1, 2, 2, 1, 2, 2, 1, 2…  | Your School/Student participation/Students can have more influence on what happens in schools if they act together                            |
| IS3G21E        | hvn\_lbll | 1, 3, 2, 2, 2, 1, 2, 4, 1, 3, 3, 2, 3, 1, 2, 4, 1, 2…  | Your School/Student participation/Voting in student elections can make a difference to what happens at schools                                |
| IS3G22A        | hvn\_lbll | 2, 3, 2, 2, 3, 2, 3, 3, 3, 2, 3, 1, 3, 1, 2, 1, 3, 2…  | Citizens and Society/Situations for democracy/Political leaders give government jobs to their family members                                  |
| IS3G22B        | hvn\_lbll | 2, 3, 2, 3, 2, 3, 3, 3, 2, 2, 3, 2, 3, 2, 3, 2, 3, 2…  | Citizens and Society/Situations for democracy/One company or the government owns all newspapers in a country                                  |
| IS3G22C        | hvn\_lbll | 1, 3, 1, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 1, 3, 2, 1, 2…  | Citizens and Society/Situations for democracy/People are allowed to publicly criticise the government                                         |
| IS3G22D        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2…  | Citizens and Society/Situations for democracy/All adult citizens have the right to elect their political leaders                              |
| IS3G22E        | hvn\_lbll | 1, 1, 1, 3, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 2…  | Citizens and Society/Situations for democracy/People are able to protest if they think a law is unfair                                        |
| IS3G22F        | hvn\_lbll | 1, 3, 3, 3, 3, 3, 3, 3, 1, 2, 3, 2, 3, 1, 3, 1, 3, 2…  | Citizens and Society/Situations for democracy/The police have right to hold people in jail without trial                                      |
| IS3G22G        | hvn\_lbll | 3, 3, 1, 3, 2, 3, 2, 2, 3, 2, 2, 1, 3, 3, 1, 2, 2, 2…  | Citizens and Society/Situations for democracy/Differences in income between poor and rich people are small                                    |
| IS3G22H        | hvn\_lbll | 3, 2, 1, 3, 2, 3, 3, 3, 3, 2, 3, 2, 3, 3, 2, 2, 3, 2…  | Citizens and Society/Situations for democracy/The government influences decisions by courts of justice                                        |
| IS3G22I        | hvn\_lbll | 3, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1, 2, 1, 2…  | Citizens and Society/Situations for democracy/All <ethnic/racial> groups in the country have the same rights                                  |
| IS3G23A        | hvn\_lbll | 1, 2, 1, 3, 1, 1, 2, 4, 2, 3, 3, 2, 2, 1, 3, 2, 1, 4…  | Citizens and Society/How important behaviours/Voting in every national election                                                               |
| IS3G23B        | hvn\_lbll | 4, 2, 3, 3, 3, 2, 2, 4, 3, 3, 3, 2, 3, 2, 3, 3, 4, 3…  | Citizens and Society/How important behaviours/Joining a political party                                                                       |
| IS3G23C        | hvn\_lbll | 1, 2, 2, 2, 2, 1, 2, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2…  | Citizens and Society/How important behaviours/Learning about the country’s history                                                            |
| IS3G23D        | hvn\_lbll | 3, 2, 2, 3, 2, 1, 2, 1, 3, 2, 3, 2, 3, 2, 3, 2, 4, 1…  | Citizens and Society/How important behaviours/Following political issues in newspaper, on radio, on TV or on Internet                         |
| IS3G23E        | hvn\_lbll | 2, 3, 1, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 1, 2, 2, 1, 2…  | Citizens and Society/How important behaviours/Showing respect for government representatives                                                  |
| IS3G23F        | hvn\_lbll | 4, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 3, 1, 3, 4, 1, 3…  | Citizens and Society/How important behaviours/Engaging in political discussions                                                               |
| IS3G23G        | hvn\_lbll | 1, 3, 1, 3, 3, 2, 1, 1, 2, 3, 4, 3, 2, 2, 1, 4, 1, 2…  | Citizens and Society/How important behaviours/Participating in peaceful protests against laws believed to be unjust                           |
| IS3G23H        | hvn\_lbll | 1, 2, 2, 2, 2, 3, 3, 1, 3, 3, 1, 2, 2, 1, 1, 3, 2, 1…  | Citizens and Society/How important behaviours/Participating in activities to benefit people in the <local community>                          |
| IS3G23I        | hvn\_lbll | 1, 2, 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 2, 1, 1, 3, 1, 1…  | Citizens and Society/How important behaviours/Taking part in activities promoting human rights                                                |
| IS3G23J        | hvn\_lbll | 1, 1, 1, 2, 1, 3, 1, 4, 1, 2, 2, 2, 2, 1, 1, 2, 2, 1…  | Citizens and Society/How important behaviours/Taking part in activities to protect the environment                                            |
| IS3G23K        | hvn\_lbll | 2, 2, 1, 3, 1, 2, 2, 4, 1, 2, 1, 2, 2, 1, 3, 2, 1, 2…  | Citizens and Society/How important behaviours/Working hard                                                                                    |
| IS3G23L        | hvn\_lbll | 1, 2, 1, 2, 1, 1, 2, 4, 2, 2, 1, 1, 2, 1, 2, 2, 1, 1…  | Citizens and Society/How important behaviours/Always obeying the law                                                                          |
| IS3G23M        | hvn\_lbll | 1, 2, 1, 2, 1, 1, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1…  | Citizens and Society/How important behaviours/Ensuring the economic welfare of their families                                                 |
| IS3G23N        | hvn\_lbll | 1, 2, 2, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2…  | Citizens and Society/How important behaviours/Making personal efforts to protect natural resources                                            |
| IS3G23O        | hvn\_lbll | 1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1…  | Citizens and Society/How important behaviours/Respecting the rights of others to have their own opinions                                      |
| IS3G23P        | hvn\_lbll | 1, 2, 2, 2, 1, 2, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 2, 1…  | Citizens and Society/How important behaviours/Supporting people who are worse off than you                                                    |
| IS3G23Q        | hvn\_lbll | 1, 2, 2, 2, 1, 3, 2, 1, 2, 3, 2, 1, 2, 1, 2, 3, 3, 1…  | Citizens and Society/How important behaviours/Engaging in activities to help people in less developed countries                               |
| IS3G24A        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1…  | Rights and Responsibilities/Roles women and men/Men and women should have equal opportunities to take part in government                      |
| IS3G24B        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1…  | Rights and Responsibilities/Roles women and men/Men and women should have the same rights in every way                                        |
| IS3G24C        | hvn\_lbll | 4, 4, 3, 4, 4, 4, 3, 4, 4, NA, 1, 2, 2, 1, 4, 3, 4, …  | Rights and Responsibilities/Roles women and men/Women should stay out of politics                                                             |
| IS3G24D        | hvn\_lbll | 4, 2, 3, 4, 4, 4, 4, NA, 4, 3, 2, 1, 2, 1, 4, 3, 4, …  | Rights and Responsibilities/Roles women and men/Not many jobs available, men should have more right to a job than women                       |
| IS3G24E        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1…  | Rights and Responsibilities/Roles women and men/Men and women should get equal pay when they are doing the same jobs                          |
| IS3G24F        | hvn\_lbll | 4, 4, 3, 4, 4, 3, 3, 1, 4, 3, 3, 2, 2, 1, 4, 4, 1, 4…  | Rights and Responsibilities/Roles women and men/Men are better qualified to be political leaders than women                                   |
| IS3G24G        | hvn\_lbll | 4, 4, 3, 4, 2, 2, 2, 1, 4, 2, 3, 1, 2, 1, 3, 3, 2, 3…  | Rights and Responsibilities/Roles women and men/Women’s first priority should be raising children                                             |
| IS3G25A        | hvn\_lbll | 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1…  | Rights and Responsibilities/Rights and responsibilities/Should have equal chance to get good education                                        |
| IS3G25B        | hvn\_lbll | 1, 2, 1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1…  | Rights and Responsibilities/Rights and responsibilities/Should have an equal chance to get good jobs                                          |
| IS3G25C        | hvn\_lbll | 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1…  | Rights and Responsibilities/Rights and responsibilities/Schools should teach students to respect                                              |
| IS3G25D        | hvn\_lbll | 1, 2, 1, 1, 1, 3, 1, 3, 1, 3, 1, 1, 2, 1, 1, 3, 1, 1…  | Rights and Responsibilities/Rights and responsibilities/Should be encouraged to run in elections                                              |
| IS3G25E        | hvn\_lbll | 1, 2, 1, 1, 1, 2, 1, 4, 1, 3, 1, 1, 2, 1, 1, 2, 1, 1…  | Rights and Responsibilities/Rights and responsibilities/Should have same rights and responsibilities                                          |
| IS3G26A        | hvn\_lbll | 4, 2, 3, 3, 1, 2, 3, 3, 2, 3, 3, 2, 2, 1, 2, 2, 3, 2…  | Institutions and Society/Trust groups, institutions or sources of information/<National government> of <country of test>                      |
| IS3G26B        | hvn\_lbll | 4, 3, 3, 3, 1, 2, 3, 2, 4, 3, 3, 2, 2, 2, 2, 2, 3, 2…  | Institutions and Society/Trust groups, institutions or sources of information/<Local government> of your town or city                         |
| IS3G26C        | hvn\_lbll | 4, 4, 2, 3, 1, 2, 3, 3, 4, 2, 3, 2, 2, 2, 2, 3, 3, 3…  | Institutions and Society/Trust groups, institutions or sources of information/Courts of justice                                               |
| IS3G26D        | hvn\_lbll | 1, 2, 2, 3, 1, 3, 3, 3, 4, 2, 2, 1, 2, 2, 2, 2, 3, 1…  | Institutions and Society/Trust groups, institutions or sources of information/The police                                                      |
| IS3G26E        | hvn\_lbll | 4, 3, 4, 4, 2, 3, 3, 3, 4, 2, 3, 2, 2, 2, 3, 4, 4, 3…  | Institutions and Society/Trust groups, institutions or sources of information/Political parties                                               |
| IS3G26F        | hvn\_lbll | 4, 3, 4, 3, 2, 3, 4, 3, 4, 3, 3, 2, 2, 2, 3, 4, 4, 2…  | Institutions and Society/Trust groups, institutions or sources of information/<National Parliament>                                           |
| IS3G26G        | hvn\_lbll | 1, 2, 3, 3, 3, 3, 4, 2, 1, 3, 2, 1, 2, 2, 3, 2, 4, 2…  | Institutions and Society/Trust groups, institutions or sources of information/Media (television, newspapers, radio)                           |
| IS3G26H        | hvn\_lbll | 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 4, 1, 2, 2, 3, 2, 3, 2…  | Institutions and Society/Trust groups, institutions or sources of information/Social media (e.g. &lt;Twitter, blogs, YouTube&gt;)             |
| IS3G26I        | hvn\_lbll | 1, 1, 3, 2, 1, 3, 3, 2, 1, 2, 3, 1, 2, 1, 3, 1, 1, 1…  | Institutions and Society/Trust groups, institutions or sources of information/<The Armed Forces>                                              |
| IS3G26J        | hvn\_lbll | 3, 2, 3, 3, 2, 3, 3, 1, 2, 2, 1, 1, 2, 1, 3, 3, 1, 2…  | Institutions and Society/Trust groups, institutions or sources of information/Schools                                                         |
| IS3G26K        | hvn\_lbll | 4, 2, 3, 2, 2, 2, 3, 3, 1, 3, 2, 2, 2, 2, 3, 4, 1, 2…  | Institutions and Society/Trust groups, institutions or sources of information/The United Nations                                              |
| IS3G26L        | hvn\_lbll | 1, 2, 3, 2, 3, 3, 2, 1, 4, 3, 3, 1, 2, 2, 3, 3, 4, 3…  | Institutions and Society/Trust groups, institutions or sources of information/People in general                                               |
| IS3G26M        | hvn\_lbll | 4, 3, 3, 3, 2, 3, 3, 2, 4, 2, 4, 1, 2, 2, 3, 3, 4, 2…  | Institutions and Society/Trust groups, institutions or sources of information/<State/Province> government                                     |
| IS3G26N        | hvn\_lbll | NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …  | Institutions and Society/Trust groups, institutions or sources of information/European Commission                                             |
| IS3G26O        | hvn\_lbll | NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …  | Institutions and Society/Trust groups, institutions or sources of information/European Parliament                                             |
| IS3G27A        | hvn\_lbll | 1, 1, 2, 2, 1, 2, 2, 1, 2, 3, 1, 1, 2, 1, 2, 1, 1, 1…  | Institutions and Society/<Country of test>/The <flag of country of test> is important to me                                                   |
| IS3G27B        | hvn\_lbll | 1, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1…  | Institutions and Society/<Country of test>/I have great respect for <country of test>                                                         |
| IS3G27C        | hvn\_lbll | 1, 1, 2, 3, 1, 2, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1…  | Institutions and Society/<Country of test>/In <country of test> we should be proud of what we have achieved                                   |
| IS3G27D        | hvn\_lbll | 1, 1, 2, 2, 2, 2, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 3, 1…  | Institutions and Society/<Country of test>/I am proud to live in <country of test>                                                            |
| IS3G27E        | hvn\_lbll | 2, 1, 2, 3, 3, 2, 2, 1, 3, 2, 2, 2, 2, 1, 3, 1, 4, 2…  | Institutions and Society/<Country of test>/<Country of test> is a better country to live in than most other countries                         |
| IS3G28A        | hvn\_lbll | 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Pollution                                                    |
| IS3G28B        | hvn\_lbll | 1, 1, 2, 1, 1, 1, 1, 2, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Energy shortages                                             |
| IS3G28C        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Global financial crises                                      |
| IS3G28D        | hvn\_lbll | 1, 1, 2, 1, 1, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2…  | Institutions and Society/The following issues are a threat to the world’s future/Crime                                                        |
| IS3G28E        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Water shortages                                              |
| IS3G28F        | hvn\_lbll | 1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Violent conflict                                             |
| IS3G28G        | hvn\_lbll | 1, 3, 1, 1, 1, 1, 1, 3, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Poverty                                                      |
| IS3G28H        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2…  | Institutions and Society/The following issues are a threat to the world’s future/Food shortages                                               |
| IS3G28I        | hvn\_lbll | 1, 1, 1, 1, 1, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Climate change                                               |
| IS3G28J        | hvn\_lbll | 1, 2, 2, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2…  | Institutions and Society/The following issues are a threat to the world’s future/Unemployment                                                 |
| IS3G28K        | hvn\_lbll | 1, 2, 1, 1, 1, 2, 1, 3, 1, 2, 1, 1, 1, 1, 2, 2, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Overpopulation                                               |
| IS3G28L        | hvn\_lbll | 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2…  | Institutions and Society/The following issues are a threat to the world’s future/Infectious diseases (e.g. <bird flu>, <AIDS>)                |
| IS3G28M        | hvn\_lbll | 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1…  | Institutions and Society/The following issues are a threat to the world’s future/Terrorism                                                    |
| IS3G29A        | hvn\_lbll | 4, 2, 2, 2, 2, 3, 1, 3, 2, 3, 1, 3, 3, 1, 3, 2, 2, 3…  | Participating in Society/How well you would do/Discuss a newspaper article about a conflict between countries                                 |
| IS3G29B        | hvn\_lbll | 4, 2, 3, 3, 3, 2, 1, 3, 2, 3, 1, 3, 2, 1, 3, 2, 2, 2…  | Participating in Society/How well you would do/Argue your point of view about a controversial political or social issue                       |
| IS3G29C        | hvn\_lbll | 4, 2, 3, 3, 3, 3, 2, 4, 4, 3, 1, 2, 2, 1, 3, 2, 1, 2…  | Participating in Society/How well you would do/Stand as a candidate in a <school election>                                                    |
| IS3G29D        | hvn\_lbll | 4, 2, 3, 3, 3, 3, 3, 3, 4, 3, 2, 2, 2, 1, 3, 2, 2, 2…  | Participating in Society/How well you would do/Organise a group of students in order to achieve changes at school                             |
| IS3G29E        | hvn\_lbll | 4, 2, 3, 3, 3, 3, 3, 4, 2, 3, 3, 3, 2, 1, 4, 2, 1, 2…  | Participating in Society/How well you would do/Follow a television debate about a controversial issue                                         |
| IS3G29F        | hvn\_lbll | 4, 2, 3, 2, 3, 3, 3, 3, 2, 3, 1, 2, 2, 1, 4, 2, 2, 2…  | Participating in Society/How well you would do/Write letter or email to a newspaper giving your view on a current issue                       |
| IS3G29G        | hvn\_lbll | 4, 2, 3, 3, 2, 3, 3, 3, 2, 3, 1, 2, 2, 1, 3, 2, 1, 2…  | Participating in Society/How well you would do/Speak in front of your class about a social or political issue                                 |
| IS3G30A        | hvn\_lbll | 4, 2, 2, 3, 4, 2, 1, 1, 2, 3, 4, 2, 3, 1, 3, 2, 1, 2…  | Participating in Society/Take part in activities to express opinion/Talk to others about your views                                           |
| IS3G30B        | hvn\_lbll | 4, 2, 3, 3, 4, 3, 1, 2, 4, 3, 2, 3, 3, 1, 3, 2, 2, 2…  | Participating in Society/Take part in activities to express opinion/Contact an <elected representative>                                       |
| IS3G30C        | hvn\_lbll | 4, 2, 1, 3, 4, 3, 1, 3, 2, 3, 4, 3, 2, 1, 2, 4, 2, 1…  | Participating in Society/Take part in activities to express opinion/Take part in a peaceful march or rally                                    |
| IS3G30D        | hvn\_lbll | 4, 2, 2, 2, 4, 3, 2, 4, 3, 3, 1, 3, 2, 1, 3, 3, 2, 2…  | Participating in Society/Take part in activities to express opinion/Collect signatures for a petition                                         |
| IS3G30E        | hvn\_lbll | 4, 2, 2, 3, 4, 3, 1, 3, 3, 3, 2, 3, 3, 1, 3, 4, 2, 2…  | Participating in Society/Take part in activities to express opinion/Contribute to an online discussion forum                                  |
| IS3G30F        | hvn\_lbll | 4, 2, 2, 3, 4, 3, 2, 4, 3, 3, 3, 3, 3, 1, 3, 4, 2, 1…  | Participating in Society/Take part in activities to express opinion/Organise an online group to take a stance                                 |
| IS3G30G        | hvn\_lbll | 2, 2, 2, 3, 4, 3, 2, 2, 2, 3, 3, 3, 3, 1, 3, 4, 2, 2…  | Participating in Society/Take part in activities to express opinion/Participate in an online campaign                                         |
| IS3G30H        | hvn\_lbll | 2, 2, 2, 3, 3, 3, 2, 1, 2, 3, 3, 3, 2, 1, 3, 2, 2, 1…  | Participating in Society/Take part in activities to express opinion/Choose to buy products in support of social justice                       |
| IS3G30I        | hvn\_lbll | 4, 3, 3, 3, 4, 3, 1, 2, 2, 3, 1, 2, 3, 1, 3, 2, 2, 4…  | Participating in Society/Take part in activities to express opinion/Spray-paint protest slogans on walls                                      |
| IS3G30J        | hvn\_lbll | 4, 3, 3, 3, 4, 3, 1, 3, 3, 3, 2, 2, 3, 1, 2, 4, 2, 4…  | Participating in Society/Take part in activities to express opinion/Stage a protest by blocking traffic                                       |
| IS3G30K        | hvn\_lbll | 4, 3, 3, 3, 4, 3, 1, 4, 3, 3, 3, 2, 3, 1, 3, 4, 2, 4…  | Participating in Society/Take part in activities to express opinion/Occupy public buildings as a sign of protest                              |
| IS3G31A        | hvn\_lbll | 2, 2, 1, 2, 2, 1, 2, 1, 3, 3, 2, 3, 2, 2, 2, 2, 1, 2…  | Participating in Society/When an adult, what do you think you will do/Vote in <local elections>                                               |
| IS3G31B        | hvn\_lbll | 2, 2, 1, 2, 2, 1, 2, 1, 1, 3, 1, 3, 2, 2, 2, 1, 1, 2…  | Participating in Society/When an adult, what do you think you will do/Vote in <national elections>                                            |
| IS3G31C        | hvn\_lbll | 2, 2, 1, 2, 2, 1, 2, 1, 1, 3, 1, 3, 2, 2, 2, 2, 2, 1…  | Participating in Society/When an adult, what do you think you will do/Get information about candidates before voting                          |
| IS3G31D        | hvn\_lbll | 4, 2, 3, 3, 2, 3, 3, 2, 4, 3, 2, 3, 2, 1, 2, 2, 1, 2…  | Participating in Society/When an adult, what do you think you will do/Help a candidate or party during election campaign                      |
| IS3G31E        | hvn\_lbll | 4, 3, 3, 3, 3, 3, 3, 4, 3, 3, 4, 3, 3, 2, 4, 3, 2, 3…  | Participating in Society/When an adult, what do you think you will do/Join a political party                                                  |
| IS3G31F        | hvn\_lbll | 4, 3, 3, 3, 4, 2, 3, 4, 3, 3, 4, 2, 3, 2, 4, 3, 1, 3…  | Participating in Society/When an adult, what do you think you will do/Join a trade union                                                      |
| IS3G31G        | hvn\_lbll | 4, 3, 3, 3, 4, 3, 3, 3, 4, 3, 4, 3, 3, 1, 4, 3, 2, 3…  | Participating in Society/When an adult, what do you think you will do/Stand as a candidate in <local elections>                               |
| IS3G31H        | hvn\_lbll | 4, 3, 3, 3, 4, 3, 3, 2, 2, 3, 4, 3, 3, 2, 4, 3, 1, 2…  | Participating in Society/When an adult, what do you think you will do/Join an organisation for political or social cause                      |
| IS3G31I        | hvn\_lbll | 1, 3, 2, 2, 1, 3, 2, 1, 3, 3, 1, 3, 2, 1, 2, 2, 2, 1…  | Participating in Society/When an adult, what do you think you will do/Volunteer time to help people in <local community>                      |
| IS3G31J        | hvn\_lbll | 1, 1, 2, 2, 1, 3, 2, 1, 2, 3, 1, 3, 2, 2, 2, 2, 1, 1…  | Participating in Society/When an adult, what do you think you will do/Make personal efforts to help the environment                           |
| IS3G31K        | hvn\_lbll | 2, 2, 3, 3, 2, 2, 3, 1, 4, 3, 4, 3, 3, 1, 2, 2, 2, 2…  | Participating in Society/When an adult, what do you think you will do/Vote in &lt;state, province elections&gt;                               |
| IS3G31L        | hvn\_lbll | NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …  | Participating in Society/When an adult, what do you think you will do/Vote in European elections                                              |
| IS3G32A        | hvn\_lbll | 2, 2, 1, 2, 3, 1, 2, 1, 1, NA, 2, 3, 2, 2, 2, 2, 1, …  | Participating in Society/How likely participate/Vote school election of <class representatives> or <school parliament>                        |
| IS3G32B        | hvn\_lbll | 2, 1, 3, 2, 2, 3, 3, 2, 2, NA, 2, 2, 3, 1, 2, 2, 2, …  | Participating in Society/How likely participate/Join a group of students campaigning for an issue you agree with                              |
| IS3G32C        | hvn\_lbll | 4, 1, 2, 2, 3, 3, 3, 3, 2, NA, 3, 2, 2, 2, 3, 2, 1, …  | Participating in Society/How likely participate/Become a candidate for <class representative> or <school parliament>                          |
| IS3G32D        | hvn\_lbll | 3, 2, 3, 3, 3, 3, 3, 4, 4, NA, 3, 2, 3, NA, 4, 2, 1,…  | Participating in Society/How likely participate/Take part in discussions in a <student assembly>                                              |
| IS3G32E        | hvn\_lbll | 3, 2, 3, 3, 3, 4, 3, 2, 4, NA, 2, 2, 3, 1, 3, 2, 2, …  | Participating in Society/How likely participate/Participate in writing articles for a school newspaper or website                             |
| IS3G33         | hvn\_lbll | 1, 1, 1, 1, 1, 1, 0, 1, 1, NA, 1, 1, 1, 1, 1, 1, 1, …  | You and Religion/What is your <religion>                                                                                                      |
| IS3G34         | hvn\_lbll | 4, 2, 3, 3, 3, 5, 3, 1, 3, NA, 3, 3, 1, 2, 1, 2, 4, …  | You and Religion/How often do you attend <religious services> outside your home with a group of other people                                  |
| IS3G35A        | hvn\_lbll | 1, 2, 2, 2, 3, 1, 3, 4, 4, NA, 4, 2, 3, 1, 3, 2, 1, …  | You and Religion/Religion/Religion is more important to me than what is happening in national politics                                        |
| IS3G35B        | hvn\_lbll | 2, 1, 3, 2, 3, 1, 3, 3, 4, NA, 4, 2, 2, 1, 3, 2, 1, …  | You and Religion/Religion/Religion helps me to decide what is right and what is wrong                                                         |
| IS3G35C        | hvn\_lbll | 2, 2, 3, 3, 3, 3, 4, 2, 4, NA, 4, 2, 3, 1, 4, 4, 4, …  | You and Religion/Religion/Religious leaders should have more power in society                                                                 |
| IS3G35D        | hvn\_lbll | 2, 2, 2, 2, 3, 2, 4, 3, 4, NA, 4, 2, 3, 1, 3, 3, 1, …  | You and Religion/Religion/Religion should influence people’s behaviour towards others                                                         |
| IS3G35E        | hvn\_lbll | 3, 1, 3, 3, 3, 2, 4, 4, 4, NA, 4, 2, 2, 1, 4, 3, 1, …  | You and Religion/Religion/Rules of life based on religion are more important than civil laws                                                  |
| IS3G35F        | hvn\_lbll | 1, 1, 2, 2, 2, 1, 1, 3, 1, NA, 1, 2, 2, 2, 1, 2, 1, …  | You and Religion/Religion/All people should be free to practice the religion they choose                                                      |
| IS3G35G        | hvn\_lbll | 3, 2, 3, 3, 3, 3, 3, 2, 3, NA, 4, 2, 3, 2, 2, 4, 1, …  | You and Religion/Religion/Religious people are better citizens                                                                                |
| IS3G02BN       | hvn\_lbll | 15201, 15201, 15201, 15203, 15201, 15202, 15201, 152…  | About You/<What best describes you>                                                                                                           |
| IS3G04AN       | hvn\_lbll | 15201, 15201, 15201, 15201, 15201, 15201, 15201, 152…  | Your Home and your Family/In what country were you and your parents born/You                                                                  |
| IS3G04BN       | hvn\_lbll | 15201, 15201, 15201, 15201, 15201, 15201, 15201, 152…  | Your Home and your Family/In what country were you and your parents born/Mother or <female guardian>                                          |
| IS3G04CN       | hvn\_lbll | 15201, 15201, 15201, 15201, 15201, 15201, 15201, 152…  | Your Home and your Family/In what country were you and your parents born/Father or <male guardian>                                            |
| IS3G05N        | hvn\_lbll | 15201, 15201, 15201, 15201, 15201, 15201, 15201, 152…  | Your Home and your Family/What language do you speak at home most of the time                                                                 |
| IS3G33N        | hvn\_lbll | 15203, 15202, 15202, 15202, 15202, 15203, 15201, 152…  | You and Religion/What is your <religion>                                                                                                      |
| IDBOOK         | hvn\_lbll | 4, 4, 7, 8, 2, 8, 4, 3, 3, 7, 2, 1, 1, 8, 7, 2, 5, 7…  | BOOKLET ID                                                                                                                                    |
| ITADMINI       | hvn\_lbll | 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3…  | Test Administrator Position                                                                                                                   |
| ITLANG         | hvn\_lbll | 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2…  | Language of Testing                                                                                                                           |
| ILRELIAB       | hvn\_lbll | 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0…  | Reliability Coding Status                                                                                                                     |
| STREAM         | hvn\_lbll | NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …  | Stream                                                                                                                                        |
| S\_AGE         | hvn\_lbll | 13.50, 14.00, 13.83, 14.67, 15.25, 14.25, 14.00, 14.…  | Student age                                                                                                                                   |
| S\_FINT        | hvn\_lbll | 2, 2, 2, 2, 1, 3, 3, 1, 0, 1, 1, 2, 2, 1, 1, 1, 1, 2…  | Father’s interest                                                                                                                             |
| S\_FISCED      | hvn\_lbll | 2, 2, 2, 4, 2, 4, 3, 3, 4, 2, 2, 3, 1, 2, 2, 2, 4, 2…  | Father’s highest educational attainment                                                                                                       |
| S\_FISCO       | hvn\_lbll | 8332, 4321, 7511, 8350, 7311, 9999, 2511, 7411, 2411…  | ISCO of father                                                                                                                                |
| S\_FISEI       | hvn\_lbll | 36, 36, 29, 44, 38, NA, 70, 43, 66, 36, 38, 37, 35, …  | Father’s occupational status                                                                                                                  |
| S\_GENDER      | hvn\_lbll | 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0…  | Student gender                                                                                                                                |
| S\_HINT        | hvn\_lbll | 2, 2, 2, 2, 1, 3, 3, 1, 0, 1, 3, 2, 2, 2, 1, 1, 2, 2…  | Highest parental interest                                                                                                                     |
| S\_HISCED      | hvn\_lbll | 2, 2, 2, 4, 2, 4, 3, 3, 4, 2, 2, 3, 2, 2, 2, 2, 4, 2…  | Highest parental educational level                                                                                                            |
| S\_HISEI       | hvn\_lbll | 36, 36, 29, 47, 38, NA, 70, 43, 66, 41, 38, 38, 35, …  | Highest parental occupational status                                                                                                          |
| S\_HOMLIT      | hvn\_lbll | 1, 2, 2, 3, 0, 2, 2, 0, 4, 0, 0, 1, 2, 1, 0, 1, 2, 1…  | Home literacy resources                                                                                                                       |
| S\_IMMIG       | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Immigration status                                                                                                                            |
| S\_ISCED       | hvn\_lbll | 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2…  | Student’s expected educational attainment                                                                                                     |
| S\_MINT        | hvn\_lbll | 0, 2, 2, 2, 1, 3, 3, 1, 0, 1, 3, 1, 2, 2, 1, 1, 2, 1…  | Mother’s interest                                                                                                                             |
| S\_MISCED      | hvn\_lbll | 2, 1, 2, 3, 2, 2, 2, 0, 3, 2, 2, 3, 2, 2, 2, 2, 4, 2…  | Mother’s highest educational attainment                                                                                                       |
| S\_MISCO       | hvn\_lbll | 7512, 9111, 9701, 3432, 9111, 9999, 2511, 9211, 4120…  | ISCO of mother                                                                                                                                |
| S\_MISEI       | hvn\_lbll | 29, 17, NA, 47, 17, NA, 70, 16, 42, 41, 32, 38, NA, …  | Mother’s occupational status                                                                                                                  |
| S\_RELIG       | hvn\_lbll | 1, 1, 1, 1, 1, 1, 0, 1, 1, NA, 1, 1, 1, 1, 1, 1, 1, …  | Students’ religious affiliation                                                                                                               |
| S\_RELSER      | hvn\_lbll | 3, 1, 2, 2, 2, 4, 2, 0, 2, NA, 2, 2, 0, 1, 0, 1, 3, …  | Students’ attendance of religious services                                                                                                    |
| S\_SINT        | hvn\_lbll | 1, 1, 1, 2, 0, 1, 2, 0, 1, 0, 2, 1, 1, 1, 0, 1, 1, 1…  | Student interest                                                                                                                              |
| S\_TLANG       | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Test language use at home                                                                                                                     |
| S\_ABUSE       | hvn\_lbll | 37.04, 50.42, 37.04, 56.17, 53.55, 37.04, 50.42, 37.…  | Students’ experiences of physical and verbal abuse at school - WLE                                                                            |
| S\_CNTATT      | hvn\_lbll | 57.12, 64.53, 43.64, 38.27, 49.60, 43.64, 43.64, 64.…  | Students’ positive attitudes toward their country of residence - WLE                                                                          |
| S\_CITCON      | hvn\_lbll | 44.04, 46.80, 52.59, 41.39, 49.65, 62.12, 52.59, 44.…  | Students’ perception of the importance of conventional citizenship - WLE                                                                      |
| S\_CITEFF      | hvn\_lbll | 16.59, 54.59, 43.17, 45.10, 45.10, 43.17, 50.75, 36.…  | Students’ sense of citizenship self-efficacy - WLE                                                                                            |
| S\_CITRESP     | hvn\_lbll | 60.13, 41.45, 51.82, 39.40, 69.02, 46.13, 41.45, 41.…  | Students’ perception of the importance of personal responsibility for citizenship - WLE                                                       |
| S\_CITSOC      | hvn\_lbll | 66.98, 47.78, 59.44, 40.99, 51.30, 40.99, 55.01, 40.…  | Students’ perception of the importance of social movement related citizenship - WLE                                                           |
| S\_CIVLRN      | hvn\_lbll | 38.22, 50.70, 45.41, 43.68, 48.90, 43.68, 36.17, 36.…  | Student reports on civic learning at school - WLE                                                                                             |
| S\_ELECPART    | hvn\_lbll | 46.74, 46.74, 61.51, 46.74, 46.74, 61.51, 46.74, 61.…  | Students’ expected electoral participation - WLE                                                                                              |
| S\_ETHRGHT     | hvn\_lbll | 66.36, 47.51, 66.36, 66.36, 66.36, 40.97, 66.36, 40.…  | Students’ endorsement of equal rights for all ethnic/racial groups - WLE                                                                      |
| S\_GENEQL      | hvn\_lbll | 63.94, 51.72, 48.72, 63.94, 63.94, 55.93, 51.72, 43.…  | Students’ endorsement of gender equality - WLE                                                                                                |
| S\_ILLACT      | hvn\_lbll | 39.15, 53.64, 53.64, 53.64, 39.15, 53.64, 74.12, 53.…  | Students’ expected participation in illegal protest activities - WLE                                                                          |
| S\_INTACT      | hvn\_lbll | 36.34, 43.84, 39.78, 39.78, 39.78, 50.19, 56.63, 68.…  | Students’ perceptions of student interaction at school - WLE                                                                                  |
| S\_INTRUST     | hvn\_lbll | 34.37, 43.05, 40.98, 38.88, 65.22, 47.28, 38.88, 43.…  | Students’ trust in civic institutions - WLE                                                                                                   |
| S\_LEGACT      | hvn\_lbll | 31.62, 56.66, 56.66, 45.49, 20.99, 45.49, 64.41, 47.…  | Students’ expected participation in legal activities - WLE                                                                                    |
| S\_OPDISC      | hvn\_lbll | 55.84, 48.57, 68.03, 44.61, 42.75, 50.75, 53.15, 37.…  | Students’ perception of openness in classroom discussions - WLE                                                                               |
| S\_POLDISC     | hvn\_lbll | 58.64, 54.00, 47.86, 56.41, 51.24, 34.77, 63.03, 52.…  | Students’ discussion of political and social issues outside school - WLE                                                                      |
| S\_POLPART     | hvn\_lbll | 29.89, 52.07, 49.29, 49.29, 43.34, 52.07, 49.29, 49.…  | Students’ expected active political participation - WLE                                                                                       |
| S\_COMPART     | hvn\_lbll | 54.87, 65.55, 57.42, 65.55, 38.11, 38.11, 57.42, 57.…  | Students’ participation in the wider community - WLE                                                                                          |
| S\_SCHPART     | hvn\_lbll | 46.52, 54.46, 46.52, 54.46, 49.45, 42.98, 46.52, 65.…  | Students’ participation at school - WLE                                                                                                       |
| S\_RELINF      | hvn\_lbll | 55.02, 60.12, 49.68, 51.55, 45.75, 56.69, 39.54, 45.…  | Students’ endorsement of the influence of religion in society - WLE                                                                           |
| S\_SCACT       | hvn\_lbll | 43.85, 57.42, 48.46, 48.46, 43.85, 43.85, 43.85, 48.…  | Students’ willingness to participate in school activities - WLE                                                                               |
| S\_SOCMED      | hvn\_lbll | 49.01, 58.75, 38.90, 49.01, 38.90, 38.90, 73.89, 54.…  | Students’ engagement with social media - WLE                                                                                                  |
| S\_STUTREL     | hvn\_lbll | 71.68, 45.48, 45.48, 39.86, 45.48, 56.82, 49.29, 60.…  | Students’ perception of student-teacher relations at school - WLE                                                                             |
| S\_VALPARTS    | hvn\_lbll | 68.37, 41.65, 45.66, 45.66, 50.05, 57.27, 45.66, 34.…  | Students’ perception of the value of participation at school - WLE                                                                            |
| S\_NISB        | hvn\_lbll | -0.57, -0.23, -0.42, 1.33, -0.85, 0.94, 1.17, -0.25,…  | National index of socioeconomic background                                                                                                    |
| PV1CIV         | hvn\_lbll | 502.42, 451.55, 395.57, 617.31, 484.77, 557.16, 487.…  | Civic knowledge - 1st PV                                                                                                                      |
| PV2CIV         | hvn\_lbll | 504.77, 473.87, 392.09, 557.64, 541.60, 580.65, 527.…  | Civic knowledge - 2nd PV                                                                                                                      |
| PV3CIV         | hvn\_lbll | 527.29, 466.81, 348.29, 646.08, 604.24, 557.19, 547.…  | Civic knowledge - 3rd PV                                                                                                                      |
| PV4CIV         | hvn\_lbll | 500.84, 427.52, 425.24, 586.77, 563.55, 574.95, 538.…  | Civic knowledge - 4th PV                                                                                                                      |
| PV5CIV         | hvn\_lbll | 523.53, 495.12, 347.08, 572.87, 516.32, 568.93, 543.…  | Civic knowledge - 5th PV                                                                                                                      |
| INICS16        | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | In ICCS 2016                                                                                                                                  |
| WGTFAC1        | hvn\_lbll | 11.542145, 36.315529, 20.679677, 4.804497, 30.386463…  | School Base Weight                                                                                                                            |
| WGTADJ1S       | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | School Weight Adjustment - Student Study                                                                                                      |
| WGTFAC2S       | hvn\_lbll | 3, 1, 2, 4, 2, 16, 1, 1, 6, 1, 4, 2, 4, 3, 2, 3, 16,…  | Class Base Weight                                                                                                                             |
| WGTADJ2S       | hvn\_lbll | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…  | Class Weight Adjustment                                                                                                                       |
| WGTADJ3S       | hvn\_lbll | 1.000000, 1.078947, 1.025000, 1.083333, 1.062500, 1.…  | Student Weight Adjustment                                                                                                                     |
| TOTWGTS        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Final Student Weight                                                                                                                          |
| JKZONES        | hvn\_lbll | 74, 56, 4, 28, 27, 38, 70, 70, 63, 46, 62, 14, 72, 5…  | Jackknife Zone - Student Study                                                                                                                |
| JKREPS         | hvn\_lbll | 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1…  | Jackknife Replicate Code - Student Study                                                                                                      |
| SRWGT1         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 1                                                                                                          |
| SRWGT2         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 2                                                                                                          |
| SRWGT3         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 3                                                                                                          |
| SRWGT4         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 4                                                                                                          |
| SRWGT5         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 5                                                                                                          |
| SRWGT6         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 6                                                                                                          |
| SRWGT7         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 7                                                                                                          |
| SRWGT8         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 8                                                                                                          |
| SRWGT9         | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 9                                                                                                          |
| SRWGT10        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 10                                                                                                         |
| SRWGT11        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 11                                                                                                         |
| SRWGT12        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 0.00000, 64.57123, 38.…  | Student Jackknife Replicate Weight 12                                                                                                         |
| SRWGT13        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 13                                                                                                         |
| SRWGT14        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 14                                                                                                         |
| SRWGT15        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 15                                                                                                         |
| SRWGT16        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 16                                                                                                         |
| SRWGT17        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 17                                                                                                         |
| SRWGT18        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 18                                                                                                         |
| SRWGT19        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 19                                                                                                         |
| SRWGT20        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 20                                                                                                         |
| SRWGT21        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 21                                                                                                         |
| SRWGT22        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 22                                                                                                         |
| SRWGT23        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 23                                                                                                         |
| SRWGT24        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 24                                                                                                         |
| SRWGT25        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 25                                                                                                         |
| SRWGT26        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 26                                                                                                         |
| SRWGT27        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 27                                                                                                         |
| SRWGT28        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 28                                                                                                         |
| SRWGT29        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 29                                                                                                         |
| SRWGT30        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 30                                                                                                         |
| SRWGT31        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 31                                                                                                         |
| SRWGT32        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 32                                                                                                         |
| SRWGT33        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 33                                                                                                         |
| SRWGT34        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 34                                                                                                         |
| SRWGT35        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 0.…  | Student Jackknife Replicate Weight 35                                                                                                         |
| SRWGT36        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 36                                                                                                         |
| SRWGT37        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 37                                                                                                         |
| SRWGT38        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 38                                                                                                         |
| SRWGT39        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 39                                                                                                         |
| SRWGT40        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 40                                                                                                         |
| SRWGT41        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 41                                                                                                         |
| SRWGT42        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 42                                                                                                         |
| SRWGT43        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 43                                                                                                         |
| SRWGT44        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 44                                                                                                         |
| SRWGT45        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 45                                                                                                         |
| SRWGT46        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 46                                                                                                         |
| SRWGT47        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 47                                                                                                         |
| SRWGT48        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 48                                                                                                         |
| SRWGT49        | hvn\_lbll | 34.62644, 78.36509, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 49                                                                                                         |
| SRWGT50        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 50                                                                                                         |
| SRWGT51        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 51                                                                                                         |
| SRWGT52        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 52                                                                                                         |
| SRWGT53        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 53                                                                                                         |
| SRWGT54        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 54                                                                                                         |
| SRWGT55        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 55                                                                                                         |
| SRWGT56        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 56                                                                                                         |
| SRWGT57        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 57                                                                                                         |
| SRWGT58        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 58                                                                                                         |
| SRWGT59        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 59                                                                                                         |
| SRWGT60        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 0.00000, 38.…  | Student Jackknife Replicate Weight 60                                                                                                         |
| SRWGT61        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 61                                                                                                         |
| SRWGT62        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 62                                                                                                         |
| SRWGT63        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 63                                                                                                         |
| SRWGT64        | hvn\_lbll | 34.62644, 39.18254, 0.00000, 20.81949, 64.57123, 38.…  | Student Jackknife Replicate Weight 64                                                                                                         |
| SRWGT65        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 65                                                                                                         |
| SRWGT66        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 66                                                                                                         |
| SRWGT67        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 67                                                                                                         |
| SRWGT68        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 68                                                                                                         |
| SRWGT69        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 69                                                                                                         |
| SRWGT70        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 70                                                                                                         |
| SRWGT71        | hvn\_lbll | 0.00000, 39.18254, 42.39334, 20.81949, 64.57123, 38.…  | Student Jackknife Replicate Weight 71                                                                                                         |
| SRWGT72        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 72                                                                                                         |
| SRWGT73        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 73                                                                                                         |
| SRWGT74        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 74                                                                                                         |
| SRWGT75        | hvn\_lbll | 34.62644, 39.18254, 42.39334, 20.81949, 64.57123, 38…  | Student Jackknife Replicate Weight 75                                                                                                         |
| VERSION        | hvn\_lbll | 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, …  | Version Number                                                                                                                                |
| SCOPE          | hvn\_lbll | 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3…  | Scope of the file                                                                                                                             |
| id\_k          | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | unique country code                                                                                                                           |
| id\_s          | dbl       | 256, 204, 228, 227, 238, 270, 270, 263, 246, 262, 21…  | unique strata code                                                                                                                            |
| id\_j          | dbl       | 1, 21168, 21023, 21021, 21053, 21058, 21148, 21109, 2… | unique school code                                                                                                                            |
| id\_i          | dbl       | , 10630, 6521, 6466, 7332, 7451, 10085, 8951, 10773, … | unique student code                                                                                                                           |
| IC3G01         | hvn\_lbll | 1, 1, 1, 3, 3, NA, 1, 3, 3, 3, NA, 1, NA, 2, 3, 3, N…  | General/How long been &lt;the principal, the headteacher, the school head&gt; of this school including the current school year                |
| IC3G02A        | hvn\_lbll | 2, 4, 3, 2, 1, NA, 3, 1, 2, 2, 2, 2, NA, 3, 2, 1, NA…  | The School Environment/Teachers participate/Making useful suggestions for improving school governance                                         |
| IC3G02B        | hvn\_lbll | 2, 3, 2, 1, 1, NA, 3, 1, 1, 2, 4, 2, NA, 2, 1, 1, NA…  | The School Environment/Teachers participate/Supporting good discipline throughout the school                                                  |
| IC3G02C        | hvn\_lbll | 2, 3, 3, 2, 1, NA, 2, 1, 1, 2, 3, 2, NA, 2, 1, 1, NA…  | The School Environment/Teachers participate/Actively taking part in school <development/improvement activities>                               |
| IC3G02D        | hvn\_lbll | 2, 4, 1, 2, 1, NA, 3, 2, 1, 2, 3, 2, NA, 3, 2, 1, NA…  | The School Environment/Teachers participate/Encouraging students’ active participation in school life                                         |
| IC3G02E        | hvn\_lbll | 2, 4, 3, 1, 2, NA, 3, 2, 2, 3, 3, 3, NA, 3, 1, 1, NA…  | The School Environment/Teachers participate/Members of &lt;school council, school governing board&gt; as representatives                      |
| IC3G03A        | hvn\_lbll | 1, 3, 3, 1, 1, NA, 1, 1, 1, 1, 1, 1, NA, 2, 1, 1, NA…  | The School Environment/Statements describe current situation/Teachers have a positive attitude towards the school                             |
| IC3G03B        | hvn\_lbll | 1, 3, 2, 1, 1, NA, 1, 1, 1, 1, 1, 1, NA, 2, 1, 1, NA…  | The School Environment/Statements describe current situation/Teachers feel part of the school community                                       |
| IC3G03C        | hvn\_lbll | 1, 3, 2, 1, 1, NA, 2, 1, 1, 1, 1, 1, NA, 2, 1, 1, NA…  | The School Environment/Statements describe current situation/Teachers work with enthusiasm                                                    |
| IC3G03D        | hvn\_lbll | 1, 3, 2, 1, 1, NA, 2, 2, 1, 1, 1, 1, NA, 2, 1, 1, NA…  | The School Environment/Statements describe current situation/Teachers take pride in this school                                               |
| IC3G03E        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 1, 2, 1, 1, 1, 1, NA, 2, 1, 1, NA…  | The School Environment/Statements describe current situation/Students enjoy being in school                                                   |
| IC3G03F        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 3, 2, 1, 1, 3, 1, NA, 2, 1, 2, NA…  | The School Environment/Statements describe current situation/Students are actively involved in school work                                    |
| IC3G03G        | hvn\_lbll | 1, 2, 2, 1, 1, NA, 3, 2, 1, 1, 2, 1, NA, 2, 1, 1, NA…  | The School Environment/Statements describe current situation/Students take pride in this school                                               |
| IC3G03H        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 2, 1, 1, 1, 2, 1, NA, 2, 1, 1, NA…  | The School Environment/Statements describe current situation/Students feel part of the school community                                       |
| IC3G04A        | hvn\_lbll | 1, 1, 3, 2, 5, NA, 4, 2, 3, 3, 3, 3, NA, 4, 3, 4, NA…  | The School Environment/How many students opportunity to take part/Activities related to environmental sustainability                          |
| IC3G04B        | hvn\_lbll | 5, 1, 4, 5, 5, NA, 4, 4, 1, 5, 4, 5, NA, 4, 4, 3, NA…  | The School Environment/How many students opportunity to take part/Human rights projects                                                       |
| IC3G04C        | hvn\_lbll | 2, 5, 2, 2, 3, NA, 3, 2, 1, NA, 4, 2, NA, 4, 2, 3, N…  | The School Environment/How many students opportunity to take part/Activities for underprivileged people or groups                             |
| IC3G04D        | hvn\_lbll | 1, 2, 3, 3, 3, NA, 2, 2, 1, 2, 4, 2, NA, 2, 1, 3, NA…  | The School Environment/How many students opportunity to take part/Cultural activities (e.g. theatre, music)                                   |
| IC3G04E        | hvn\_lbll | 1, 1, 4, 2, 2, NA, 2, 2, 1, NA, 4, 3, NA, 2, 1, 3, N…  | The School Environment/How many students opportunity to take part/Multicultural and intercultural activities                                  |
| IC3G04F        | hvn\_lbll | 4, 1, 4, 2, 3, NA, 3, 2, 1, 2, 3, 3, NA, 3, 3, 4, NA…  | The School Environment/How many students opportunity to take part/Campaigns to raise people’s awareness                                       |
| IC3G04G        | hvn\_lbll | 2, 1, 4, 3, 2, NA, 4, 2, 3, NA, 3, 2, NA, 4, 2, 4, N…  | The School Environment/How many students opportunity to take part/Activities aimed at protecting the cultural heritage                        |
| IC3G04H        | hvn\_lbll | 5, 1, 4, 3, 5, NA, 3, 4, 4, 4, 4, 3, NA, 3, 4, 4, NA…  | The School Environment/How many students opportunity to take part/Visits to political institutions                                            |
| IC3G04I        | hvn\_lbll | 1, 4, 3, 3, 1, NA, 2, 1, 1, 3, 3, 2, NA, 1, 1, 3, NA…  | The School Environment/How many students opportunity to take part/Sports events                                                               |
| IC3G05A        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 1, 1, 1, 1, 2, NA, 1, 1, 1, NA…  | The School Environment/How many <target grade> students/Elect their class representatives                                                     |
| IC3G05B        | hvn\_lbll | 1, 5, 1, 1, 1, NA, 1, 1, 1, 1, 1, 1, NA, 5, 1, 1, NA…  | The School Environment/How many <target grade> students/Vote in &lt;student council, school parliament&gt; elections                          |
| IC3G06A        | hvn\_lbll | 3, 3, 2, 1, 1, NA, 2, 2, 3, 2, 3, 2, NA, 2, 1, 1, NA…  | The School Environment/How often happen/A student reported aggressive or destructive behaviours by other students                             |
| IC3G06B        | hvn\_lbll | 1, 2, 2, 1, 1, NA, 2, 1, 2, 2, 1, 1, NA, 2, 1, 1, NA…  | The School Environment/How often happen/A student reported that s/he was <bullied> by a teacher                                               |
| IC3G06C        | hvn\_lbll | 2, 3, 2, 1, 1, NA, 2, 2, 2, 2, 2, 2, NA, 2, 2, 2, NA…  | The School Environment/How often happen/A teacher reported that a student was <bullied> by other students                                     |
| IC3G06D        | hvn\_lbll | 2, 2, 2, 1, 1, NA, 2, 1, 2, 2, 1, 2, NA, 2, 1, 1, NA…  | The School Environment/How often happen/A teacher reported that a student helped another student who was being <bullied>                      |
| IC3G06E        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 1, 1, 2, 1, 1, 1, NA, 1, 1, 1, NA…  | The School Environment/How often happen/A teacher reported that s/he was being <bullied> by students                                          |
| IC3G06F        | hvn\_lbll | 3, 3, 1, 1, 1, NA, 2, 2, 2, 2, 2, 2, NA, 3, 2, 1, NA…  | The School Environment/How often happen/A parent reported that his/her son/daughter was <bullied> by other students                           |
| IC3G07A        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 1, 1, 1, 2, 2, NA, 2, 2, 1, NA…  | The School Environment/Activities against <bullying>/Meetings aiming at informing parents about <bullying> at school                          |
| IC3G07B        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 2, 1, 1, 2, 2, NA, 2, 2, 2, NA…  | The School Environment/Activities against <bullying>/Training to provide teachers with knowledge, skills, confidence                          |
| IC3G07C        | hvn\_lbll | 2, 2, 1, 2, 1, NA, 1, 2, 1, 2, 2, 2, NA, 2, 2, 2, NA…  | The School Environment/Activities against <bullying>/Teacher training sessions on safe and responsible internet use                           |
| IC3G07D        | hvn\_lbll | 2, 2, 1, 1, 1, NA, 2, 2, 1, 1, 2, 2, NA, 1, 2, 2, NA…  | The School Environment/Activities against <bullying>/Student training sessions for responsible internet conduct use                           |
| IC3G07E        | hvn\_lbll | 1, 2, 2, 1, 1, NA, 2, 2, 1, 1, 2, 2, NA, 1, 2, 1, NA…  | The School Environment/Activities against <bullying>/Meetings aiming at raising parents’ awareness on <cyber-bullying>                        |
| IC3G07F        | hvn\_lbll | 1, 2, 2, 1, 1, NA, 2, 2, 2, 1, 2, 2, NA, 1, 2, 1, NA…  | The School Environment/Activities against <bullying>/Development of a system to report anonymously incidents                                  |
| IC3G07G        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 1, 1, 1, 1, 1, NA, 1, 1, 1, NA…  | The School Environment/Activities against <bullying>/Classroom activities aiming at raising students’ awareness                               |
| IC3G07H        | hvn\_lbll | 2, 1, 2, 1, 1, NA, 1, 2, 1, 2, 1, 2, NA, 2, 2, 2, NA…  | The School Environment/Activities against <bullying>/<Anti-bullying> conferences held by experts, local authorities                           |
| IC3G08A        | hvn\_lbll | 3, 2, 2, 1, 2, NA, 2, 1, 1, 1, 3, 2, NA, 2, 1, 1, NA…  | The School Environment/Statements apply/Teachers are involved in decision-making processes                                                    |
| IC3G08B        | hvn\_lbll | 4, 3, 3, 2, 2, NA, 3, 1, 2, 1, 3, 2, NA, 3, 1, 3, NA…  | The School Environment/Statements apply/Parents are involved in decision-making processes                                                     |
| IC3G08C        | hvn\_lbll | 3, 2, 3, 2, 2, NA, 3, 1, 2, 1, 3, 3, NA, 2, 1, 2, NA…  | The School Environment/Statements apply/Students’ opinions in decision-making processes                                                       |
| IC3G08D        | hvn\_lbll | 1, 2, 2, 1, 1, NA, 2, 1, 1, 1, 1, 2, NA, 2, 1, 1, NA…  | The School Environment/Statements apply/Rules and regulations are followed                                                                    |
| IC3G08E        | hvn\_lbll | 3, 2, 3, 1, 2, NA, 2, 2, 2, 1, 1, 3, NA, 2, 1, 2, NA…  | The School Environment/Statements apply/Students opportunity to actively participate in school decisions                                      |
| IC3G08F        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 1, 1, 1, 1, 1, 2, NA, 1, 1, 1, NA…  | The School Environment/Statements apply/Parents are provided with information on school and student performance                               |
| IC3G09A        | hvn\_lbll | 4, 4, 4, 2, 4, NA, 4, 2, 1, 3, 3, 4, NA, 3, 1, 1, NA…  | The School Environment/Practices implemented/Differential waste collection                                                                    |
| IC3G09B        | hvn\_lbll | 4, 4, 3, 2, 4, NA, 4, 2, 2, 3, 3, 3, NA, 3, 3, 1, NA…  | The School Environment/Practices implemented/Waste reduction                                                                                  |
| IC3G09C        | hvn\_lbll | 3, 4, 4, 2, 2, NA, 4, 2, 1, 4, 3, 3, NA, 4, 3, 2, NA…  | The School Environment/Practices implemented/Purchasing of environmentally friendly items                                                     |
| IC3G09D        | hvn\_lbll | 2, 4, 3, 1, 2, NA, 4, 1, 2, 3, 3, 3, NA, 3, 2, 3, NA…  | The School Environment/Practices implemented/Energy-saving practices                                                                          |
| IC3G09E        | hvn\_lbll | 2, 2, 3, 1, 2, NA, 2, 1, 1, 3, 3, 3, NA, 1, 2, 2, NA…  | The School Environment/Practices implemented/Posters to encourage students’ environmental-friendly behaviours                                 |
| IC3G10A        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 1, 1, 2, 1, 1, NA, 1, 1, 1, NA…  | The School Environment/Devices with internet access provided to students for learning activities/Desktop computers                            |
| IC3G10B        | hvn\_lbll | 2, 2, 1, 2, 2, NA, 2, 1, 1, 1, 2, 2, NA, 2, 1, 2, NA…  | The School Environment/Devices with internet access provided to students for learning activities/Portable computers                           |
| IC3G10C        | hvn\_lbll | 2, 2, 2, 2, 2, NA, 2, 2, 2, 2, 2, 2, NA, 1, 1, 2, NA…  | The School Environment/Devices with internet access provided to students for learning activities/Tablet devices                               |
| IC3G10D        | hvn\_lbll | 2, 2, 2, 2, 2, NA, 2, 2, 2, 2, 2, 2, NA, 2, 2, 2, NA…  | The School Environment/Devices with internet access provided to students for learning activities/E-readers                                    |
| IC3G10E        | hvn\_lbll | 1, 2, 1, 2, 2, NA, 2, 2, 1, 2, 2, 2, NA, 1, 1, 2, NA…  | The School Environment/Devices with internet access provided to students for learning activities/Interactive whiteboards                      |
| IC3G11A        | hvn\_lbll | 2, 2, 1, 2, 1, NA, 1, 2, 2, 2, 2, 1, NA, 1, 1, 2, NA…  | The Local Community/Resources available in immediate area/Public library                                                                      |
| IC3G11B        | hvn\_lbll | 2, 2, 1, 2, 1, NA, 1, 2, 1, 2, 2, 2, NA, 2, 2, 2, NA…  | The Local Community/Resources available in immediate area/Cinema                                                                              |
| IC3G11C        | hvn\_lbll | 2, 2, 1, 2, 1, NA, 1, 2, 1, 2, 2, 2, NA, 1, 1, 2, NA…  | The Local Community/Resources available in immediate area/Theatre or Concert Hall                                                             |
| IC3G11D        | hvn\_lbll | 2, 2, 2, 2, 1, NA, 1, 2, 1, 2, 2, 2, NA, 1, 2, 2, NA…  | The Local Community/Resources available in immediate area/Language school                                                                     |
| IC3G11E        | hvn\_lbll | 2, 2, 1, 2, 1, NA, 1, 2, 2, 2, 2, 2, NA, 1, 2, 2, NA…  | The Local Community/Resources available in immediate area/Museum or Art Gallery                                                               |
| IC3G11F        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 1, 1, 2, 2, 1, NA, 1, 2, 1, NA…  | The Local Community/Resources available in immediate area/Playground                                                                          |
| IC3G11G        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 2, 1, 2, 1, 1, NA, 1, 1, 1, NA…  | The Local Community/Resources available in immediate area/Public garden or Park                                                               |
| IC3G11H        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 1, 1, 1, 1, 1, NA, 1, 1, 2, NA…  | The Local Community/Resources available in immediate area/Religious centre                                                                    |
| IC3G11I        | hvn\_lbll | 1, 1, 2, 1, 1, NA, 1, 1, 1, 1, 2, 1, NA, 1, 2, 1, NA…  | The Local Community/Resources available in immediate area/Sports facilities                                                                   |
| IC3G11J        | hvn\_lbll | 2, 2, 2, 2, 2, NA, 1, 2, 2, 2, 2, 2, NA, 1, 2, 2, NA…  | The Local Community/Resources available in immediate area/Music schools                                                                       |
| IC3G12A        | hvn\_lbll | 4, 2, 3, 4, 4, NA, 1, 4, 4, 3, 3, 4, NA, 3, 4, 3, NA…  | The Local Community/Source of social tension in the immediate area/Presence of immigrants                                                     |
| IC3G12B        | hvn\_lbll | 4, 1, 3, 4, 4, NA, 2, 3, 2, 2, 3, 3, NA, 2, 3, 3, NA…  | The Local Community/Source of social tension in the immediate area/Poor quality of housing                                                    |
| IC3G12C        | hvn\_lbll | 4, 1, 3, 4, 4, NA, 2, 1, 2, 1, 3, 1, NA, 3, 1, 2, NA…  | The Local Community/Source of social tension in the immediate area/Unemployment                                                               |
| IC3G12D        | hvn\_lbll | 4, 1, 4, 4, 4, NA, 4, 3, 4, 3, 3, 3, NA, 4, 3, 4, NA…  | The Local Community/Source of social tension in the immediate area/Religious intolerance                                                      |
| IC3G12E        | hvn\_lbll | 4, 1, 4, 4, 4, NA, 2, 4, 4, 4, 3, 4, NA, 4, 4, 4, NA…  | The Local Community/Source of social tension in the immediate area/Ethnic conflicts                                                           |
| IC3G12F        | hvn\_lbll | 4, 1, 2, 4, 4, NA, 2, 2, 3, 1, 2, 3, NA, 1, 3, 3, NA…  | The Local Community/Source of social tension in the immediate area/Extensive poverty                                                          |
| IC3G12G        | hvn\_lbll | 4, 1, 2, 4, 4, NA, 2, 4, 4, 4, 2, 4, NA, 2, 3, 4, NA…  | The Local Community/Source of social tension in the immediate area/Organised crime                                                            |
| IC3G12H        | hvn\_lbll | 4, 1, 2, 4, 4, NA, 3, 4, 2, 2, 2, 3, NA, 2, 2, 4, NA…  | The Local Community/Source of social tension in the immediate area/Youth gangs                                                                |
| IC3G12I        | hvn\_lbll | 3, 1, 2, 4, 4, NA, 1, 3, 2, 2, 2, 3, NA, 2, 2, 3, NA…  | The Local Community/Source of social tension in the immediate area/Petty crime                                                                |
| IC3G12J        | hvn\_lbll | 3, 2, 3, 4, 4, NA, 3, 3, 3, 3, 3, 4, NA, 3, 3, 4, NA…  | The Local Community/Source of social tension in the immediate area/Sexual harassment                                                          |
| IC3G12K        | hvn\_lbll | 2, 1, 2, 4, 4, NA, 1, 3, 1, 2, 2, 3, NA, 1, 3, 3, NA…  | The Local Community/Source of social tension in the immediate area/Drug abuse                                                                 |
| IC3G12L        | hvn\_lbll | 2, 1, 2, 4, 4, NA, 2, 1, 1, 2, 2, 3, NA, 1, 3, 3, NA…  | The Local Community/Source of social tension in the immediate area/Alcohol abuse                                                              |
| IC3G13A        | hvn\_lbll | 2, 2, 2, 2, 2, NA, 2, 2, 2, 2, 2, 2, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/How taught/Taught as a separate subject by teachers                                                 |
| IC3G13B        | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 1, 1, 1, 1, 1, NA, 1, 1, 2, NA…  | Civic and Citizenship Education at School/How taught/Taught by teachers of subjects related to human/social sciences                          |
| IC3G13C        | hvn\_lbll | 1, 2, 2, 2, 2, NA, 2, 1, 2, 2, 2, 2, NA, 2, 2, 1, NA…  | Civic and Citizenship Education at School/How taught/It is integrated into all subjects taught at school                                      |
| IC3G13D        | hvn\_lbll | 2, 2, 2, 1, 2, NA, 2, 2, 1, 2, 2, 2, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/How taught/It is an <extra-curricular activity>                                                     |
| IC3G13E        | hvn\_lbll | 1, 2, 2, 1, 1, NA, 1, 2, 1, 2, 2, 2, NA, 1, 2, 1, NA…  | Civic and Citizenship Education at School/How taught/It is considered the result of school experience as a whole                              |
| IC3G14A        | hvn\_lbll | 1, 2, 3, 1, 1, NA, 1, 3, 1, 1, 2, 3, NA, 3, 3, 3, NA…  | Civic and Citizenship Education at School/How much autonomy/Choice of textbooks and teaching materials                                        |
| IC3G14B        | hvn\_lbll | 1, 2, 3, 1, 1, NA, 1, 2, 1, 1, 2, 2, NA, 2, 3, 1, NA…  | Civic and Citizenship Education at School/How much autonomy/Establishing student assessment procedures and tools                              |
| IC3G14C        | hvn\_lbll | 1, 2, 3, 1, 4, NA, 1, 1, 1, 2, 2, 2, NA, 3, 2, 1, NA…  | Civic and Citizenship Education at School/How much autonomy/Curriculum planning                                                               |
| IC3G14D        | hvn\_lbll | 1, 2, 3, 1, 4, NA, 1, 1, 1, 3, 3, 3, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/How much autonomy/Determining content of in-service programmes                                      |
| IC3G14E        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 1, 2, 1, 2, 2, 3, NA, 1, 1, 2, NA…  | Civic and Citizenship Education at School/How much autonomy/<Extra-curricular activities>                                                     |
| IC3G14F        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 1, 2, 1, 2, 4, 3, NA, 1, 3, 2, NA…  | Civic and Citizenship Education at School/How much autonomy/Establishing cooperation agreements                                               |
| IC3G14G        | hvn\_lbll | 1, 2, 1, 1, 1, NA, 1, 2, 1, 4, 4, 3, NA, 1, 3, 4, NA…  | Civic and Citizenship Education at School/How much autonomy/Participating in projects in partnership with other schools                       |
| IC3G14H        | hvn\_lbll | NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …  | Civic and Citizenship Education at School/How much autonomy/Participating in European projects                                                |
| IC3G15         | hvn\_lbll | 2, 1, 4, 1, 4, NA, 3, 4, 1, 4, 4, 4, NA, 1, 4, 4, NA…  | Civic and Citizenship Education at School/Specific tasks for civic and citizenship education assigned to teachers                             |
| IC3G16A        | hvn\_lbll | 2, 2, 1, 1, 1, NA, 2, 2, 2, 1, 1, 2, NA, 1, 1, 1, NA…  | Civic and Citizenship Education at School/Most important/Promoting knowledge of social, political and civic institutions                      |
| IC3G16B        | hvn\_lbll | 2, 2, 1, 2, 2, NA, 2, 1, 2, 2, 2, 1, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/Most important/Promoting respect for and safeguard of the environment                               |
| IC3G16C        | hvn\_lbll | 2, 2, 2, 2, 2, NA, 2, 2, 2, 1, 2, 2, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/Most important/Promoting the capacity to defend one’s own point of view                             |
| IC3G16D        | hvn\_lbll | 2, 1, 2, 2, 2, NA, 1, 1, 1, 2, 2, 1, NA, 2, 2, 1, NA…  | Civic and Citizenship Education at School/Most important/Developing students’ skills in conflict resolution                                   |
| IC3G16E        | hvn\_lbll | 1, 1, 2, 1, 1, NA, 1, 2, 1, 2, 1, 2, NA, 1, 1, 2, NA…  | Civic and Citizenship Education at School/Most important/Promoting knowledge of citizens’ rights and responsibilities                         |
| IC3G16F        | hvn\_lbll | 1, 2, 1, 1, 2, NA, 2, 2, 2, 2, 2, 2, NA, 1, 1, 2, NA…  | Civic and Citizenship Education at School/Most important/Promoting students’ participation in the <local community>                           |
| IC3G16G        | hvn\_lbll | 2, 1, 2, 2, 1, NA, 2, 1, 2, 1, 1, 1, NA, 2, 2, 1, NA…  | Civic and Citizenship Education at School/Most important/Promoting students’ critical and independent thinking                                |
| IC3G16H        | hvn\_lbll | 1, 2, 2, 2, 2, NA, 1, 2, 2, 2, 2, 2, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/Most important/Promoting students’ participation in school life                                     |
| IC3G16I        | hvn\_lbll | 2, 2, 2, 2, 2, NA, 2, 2, 2, 2, 2, 2, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/Most important/Supporting development of effective strategies to reduce racism                      |
| IC3G16J        | hvn\_lbll | 2, 2, 2, 2, 2, NA, 2, 2, 1, 2, 2, 2, NA, 2, 2, 2, NA…  | Civic and Citizenship Education at School/Most important/Preparing students for future political engagement                                   |
| IC3G20         | hvn\_lbll | 4, 5, 4, 4, 4, NA, 3, 1, 5, 1, 4, 2, NA, 5, 3, 4, NA…  | School Size and Resources/Which best describes the immediate area in which this school is located                                             |
| IC3G21A        | hvn\_lbll | 1, NA, 1, 4, 1, NA, 4, 1, 4, NA, 1, 2, NA, 1, 1, 1, …  | School Size and Resources/Percentage of students backgrounds/Come from economically affluent homes                                            |
| IC3G21B        | hvn\_lbll | 4, NA, 4, 1, 4, NA, 1, 4, 2, 4, 4, 4, NA, 4, 4, 3, N…  | School Size and Resources/Percentage of students backgrounds/Come from economically disadvantaged homes                                       |
| C\_COMP        | hvn\_lbll | 3, NA, 3, 1, 3, NA, 1, 3, 1, NA, 3, 3, NA, 3, 3, 3, …  | School composition by student background                                                                                                      |
| C\_GENROL\_CAT | hvn\_lbll | 2, 1, 1, 2, 1, NA, 1, 1, 3, 1, 2, 1, NA, 2, 1, 1, NA…  | Number of students enrolled in target grade - categorized                                                                                     |
| C\_SCSIZE\_CAT | hvn\_lbll | 4, 3, 4, 4, 3, NA, 2, 1, 4, 3, 4, 2, NA, 4, 3, 4, NA…  | School size - categorized                                                                                                                     |
| C\_TGPERC      | hvn\_lbll | 6.72, 6.16, 7.92, 8.26, 6.48, NA, 7.83, 6.73, 6.76, …  | Percentage of target grade students at school                                                                                                 |
| C\_URBAN       | hvn\_lbll | 1, 1, 1, 1, 1, NA, 0, 0, 1, 0, 1, 0, NA, 1, 0, 1, NA…  | Urbanicity of school                                                                                                                          |
| C\_AVRESCOM    | hvn\_lbll | 42.23, 42.23, 52.61, 42.23, 60.17, NA, 67.08, 38.89,…  | Principals’ reports on the availability of resources in local community - WLE                                                                 |
| C\_BULACT      | hvn\_lbll | 50.71, 46.74, 50.71, 60.65, 69.96, NA, 50.71, 38.12,…  | Principals’ report on activities against bullying at school - WLE                                                                             |
| C\_BULSCH      | hvn\_lbll | 57.17, 66.49, 50.09, 30.58, 30.58, NA, 53.85, 46.02,…  | Principals’ perceptions of bullying at school - WLE                                                                                           |
| C\_COMCRI      | hvn\_lbll | 55.51, 76.24, 64.89, 34.14, 34.14, NA, 66.39, 55.51,…  | Principals’ perceptions of crime in the community - WLE                                                                                       |
| C\_COMETN      | hvn\_lbll | 40.03, 78.55, 48.06, 40.03, 40.03, NA, 67.04, 48.06,…  | Principals’ perceptions of social tension due to ethnic differences in the community - WLE                                                    |
| C\_COMPOV      | hvn\_lbll | 33.15, 72.27, 52.72, 33.15, 33.15, NA, 59.27, 59.27,…  | Principals’ perceptions of poverty in the community - WLE                                                                                     |
| C\_ENGAGE      | hvn\_lbll | 34.10, 37.78, 34.10, 56.86, 48.22, NA, 37.78, 62.21,…  | Principals’ perceptions of engagement of the school community - WLE                                                                           |
| C\_ENPRAC      | hvn\_lbll | 37.72, 29.78, 32.86, 54.08, 39.88, NA, 29.78, 54.08,…  | Principals’ reports on environment-friendly practices at school - WLE                                                                         |
| C\_STDCOM      | hvn\_lbll | 48.52, 36.13, 39.75, 53.41, 47.16, NA, 47.78, 57.51,…  | Principals’ perceptions of student opportunities to participate in community activities - WLE                                                 |
| C\_STSBELS     | hvn\_lbll | 61.00, 38.43, 54.46, 61.00, 61.00, NA, 30.50, 46.13,…  | Principals’ perceptions of students’ sense of belonging to school - WLE                                                                       |
| C\_TCPART      | hvn\_lbll | 51.52, 25.15, 43.34, 57.77, 64.87, NA, 33.14, 60.94,…  | Principals’ perceptions of teacher participation in school governance - WLE                                                                   |
| C\_TCSBELS     | hvn\_lbll | 59.33, 12.79, 27.87, 59.33, 59.33, NA, 47.94, 52.44,…  | Principals’ perceptions of teachers’ sense of belonging to school - WLE                                                                       |
| WGTADJ1C       | hvn\_lbll | 1.164179, 1.164179, 1.164179, 1.200000, 1.164179, NA…  | School Weight Adjustment - School Study                                                                                                       |
| TOTWGTC        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | Final School Weight - School Study                                                                                                            |
| JKZONEC        | hvn\_lbll | 16, 59, 28, 20, 68, NA, 8, 67, 35, 7, 16, 72, NA, 2,…  | Jackknife Zone - School Study                                                                                                                 |
| JKREPC         | hvn\_lbll | 1, 0, 0, 1, 1, NA, 0, 0, 1, 1, 0, 0, NA, 1, 1, 0, NA…  | Jackknife Replicate Code - School Study                                                                                                       |
| CRWGT1         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 1                                                                                                           |
| CRWGT2         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 2                                                                                                           |
| CRWGT3         | hvn\_lbll | 13.43712, 42.27778, 24.07485, 11.53079, 35.37528, NA…  | School Jackknife Replicate Weight 3                                                                                                           |
| CRWGT4         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 4                                                                                                           |
| CRWGT5         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 5                                                                                                           |
| CRWGT6         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 6                                                                                                           |
| CRWGT7         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 7                                                                                                           |
| CRWGT8         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 8                                                                                                           |
| CRWGT9         | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 9                                                                                                           |
| CRWGT10        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 10                                                                                                          |
| CRWGT11        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 11                                                                                                          |
| CRWGT12        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 12                                                                                                          |
| CRWGT13        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 13                                                                                                          |
| CRWGT14        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 14                                                                                                          |
| CRWGT15        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 15                                                                                                          |
| CRWGT16        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 16                                                                                                          |
| CRWGT17        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 17                                                                                                          |
| CRWGT18        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 18                                                                                                          |
| CRWGT19        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 19                                                                                                          |
| CRWGT20        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 20                                                                                                          |
| CRWGT21        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 21                                                                                                          |
| CRWGT22        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 22                                                                                                          |
| CRWGT23        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 23                                                                                                          |
| CRWGT24        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 24                                                                                                          |
| CRWGT25        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 25                                                                                                          |
| CRWGT26        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 26                                                                                                          |
| CRWGT27        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 27                                                                                                          |
| CRWGT28        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 28                                                                                                          |
| CRWGT29        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 29                                                                                                          |
| CRWGT30        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 30                                                                                                          |
| CRWGT31        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 31                                                                                                          |
| CRWGT32        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 32                                                                                                          |
| CRWGT33        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 33                                                                                                          |
| CRWGT34        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 34                                                                                                          |
| CRWGT35        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 35                                                                                                          |
| CRWGT36        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 36                                                                                                          |
| CRWGT37        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 37                                                                                                          |
| CRWGT38        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 38                                                                                                          |
| CRWGT39        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 39                                                                                                          |
| CRWGT40        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 40                                                                                                          |
| CRWGT41        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 41                                                                                                          |
| CRWGT42        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 42                                                                                                          |
| CRWGT43        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 43                                                                                                          |
| CRWGT44        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 44                                                                                                          |
| CRWGT45        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 45                                                                                                          |
| CRWGT46        | hvn\_lbll | 13.437124, 0.000000, 24.074847, 5.765396, 35.375285,…  | School Jackknife Replicate Weight 46                                                                                                          |
| CRWGT47        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 47                                                                                                          |
| CRWGT48        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 48                                                                                                          |
| CRWGT49        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 49                                                                                                          |
| CRWGT50        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 50                                                                                                          |
| CRWGT51        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 51                                                                                                          |
| CRWGT52        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 52                                                                                                          |
| CRWGT53        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 53                                                                                                          |
| CRWGT54        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 70.750570…  | School Jackknife Replicate Weight 54                                                                                                          |
| CRWGT55        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 55                                                                                                          |
| CRWGT56        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 56                                                                                                          |
| CRWGT57        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 57                                                                                                          |
| CRWGT58        | hvn\_lbll | 13.437124, 42.277780, 0.000000, 5.765396, 35.375285,…  | School Jackknife Replicate Weight 58                                                                                                          |
| CRWGT59        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 59                                                                                                          |
| CRWGT60        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 60                                                                                                          |
| CRWGT61        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 61                                                                                                          |
| CRWGT62        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 62                                                                                                          |
| CRWGT63        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 63                                                                                                          |
| CRWGT64        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 64                                                                                                          |
| CRWGT65        | hvn\_lbll | 26.874248, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 65                                                                                                          |
| CRWGT66        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 66                                                                                                          |
| CRWGT67        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 67                                                                                                          |
| CRWGT68        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 68                                                                                                          |
| CRWGT69        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 69                                                                                                          |
| CRWGT70        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 70                                                                                                          |
| CRWGT71        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 71                                                                                                          |
| CRWGT72        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 72                                                                                                          |
| CRWGT73        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 73                                                                                                          |
| CRWGT74        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 74                                                                                                          |
| CRWGT75        | hvn\_lbll | 13.437124, 42.277780, 24.074847, 5.765396, 35.375285…  | School Jackknife Replicate Weight 75                                                                                                          |
| C\_PRIVATE     | hvn\_lbll | 1, 1, 1, 1, 1, NA, 1, 0, 1, 0, 0, 0, NA, 1, 0, 1, NA…  | Private school management                                                                                                                     |
| n\_j           | int       | 6, 6, 15, 7, NA, NA, 5, 12, 7, 14, 5, NA, 9, 8, 10, N… | number of surveyed teachers per school                                                                                                        |
| T\_AGE\_c      | dbl       | 0000, 40.45455, 27.00000, 43.26667, 41.76923, NA, NA,… | Teacher’s age \[aggregated, weighted mean\]                                                                                                   |
| T\_CCESUB\_c   | dbl       | 00000, 0.2727273, 0.3333333, 0.2000000, 0.3076923, NA… | Teacher teaching CCE subject \[aggregated, weighted mean\]                                                                                    |
| T\_GENDER\_c   | dbl       | 00000, 0.5454545, 1.0000000, 0.6000000, 0.5384615, NA… | Teacher’s gender \[aggregated, weighted mean\]                                                                                                |
| T\_TIME\_c     | dbl       | 00000, 0.1545455, 0.3666667, 0.2600000, 0.2846154, NA… | Teacher’s teaching load at school \[aggregated, weighted mean\]                                                                               |
| T\_BULSCH\_c   | dbl       | 4400, 57.51000, 46.11333, 43.91867, 38.54077, NA, NA,… | Teachers’ perceptions of bullying at school - WLE \[aggregated, weighted mean\]                                                               |
| T\_CIVCLAS\_c  | dbl       | 2000, 44.72000, 40.50000, 53.15000, 51.63000, NA, NA,… | Teachers’ reports on civic-related activities in class - WLE \[aggregated, weighted mean\]                                                    |
| T\_PCCLIM\_c   | dbl       | 5800, 43.55545, 52.95500, 53.54400, 58.77308, NA, NA,… | Teachers’ perceptions of classroom climate - WLE \[aggregated, weighted mean\]                                                                |
| T\_PDACCE\_c   | dbl       | 2000, 42.77000, 33.96000, 49.96000, 33.96000, NA, NA,… | Teachers’ PD activities for CCE topics - WLE \[aggregated, weighted mean\]                                                                    |
| T\_PDATCH\_c   | dbl       | 3000, 35.98000, 39.50000, 53.57667, 28.94000, NA, NA,… | Teachers’ PD activities for teaching methods - WLE \[aggregated, weighted mean\]                                                              |
| T\_PROBSC\_c   | dbl       | 3600, 62.75273, 43.22000, 43.70267, 28.92231, NA, NA,… | Teachers’ perceptions of social problems at school - WLE \[aggregated, weighted mean\]                                                        |
| T\_PRPCCE\_c   | dbl       | 6000, 52.44000, 26.31000, 48.09000, 50.70000, NA, NA,… | Teachers’ preparedness for teaching CCE topics - WLE \[aggregated, weighted mean\]                                                            |
| T\_STDCOM\_c   | dbl       | 7500, 43.86909, 43.09333, 50.89200, 56.94538, NA, NA,… | Teachers’ perceptions of student activities in the community - WLE \[aggregated, weighted mean\]                                              |
| T\_STUDB\_c    | dbl       | 7700, 34.14182, 43.79167, 54.90600, 60.04769, NA, NA,… | Teachers’ perception of student behaviour at school - WLE \[aggregated, weighted mean\]                                                       |
| T\_TCHPRT\_c   | dbl       | 2700, 47.79545, 48.51667, 47.58333, 54.21231, NA, NA,… | Teachers’ perception of teacher participation at school - WLE \[aggregated, weighted mean\]                                                   |
| T\_AGE\_m      | dbl       | , 35.0, 27.0, 45.0, 42.5, NA, NA, 55.0, 35.0, 55.0, 3… | Teacher’s age \[aggregated, weighted median\]                                                                                                 |
| T\_CCESUB\_m   | dbl       | , 0, 0, 0, NA, NA, 0, 0, 0, 0, 0, NA, 0, 0, 0, NA, 0,… | Teacher teaching CCE subject \[aggregated, weighted median\]                                                                                  |
| T\_GENDER\_m   | dbl       | , 0.75, 1.00, 1.00, 0.75, NA, NA, 1.00, 0.50, 1.00, 1… | Teacher’s gender \[aggregated, weighted median\]                                                                                              |
| T\_TIME\_m     | dbl       | 00000, 0.1000000, 0.4000000, 0.3000000, 0.3000000, NA… | Teacher’s teaching load at school \[aggregated, weighted median\]                                                                             |
| T\_BULSCH\_m   | dbl       | 250, 57.4100, 45.6350, 42.0400, 35.1100, NA, NA, 51.3… | Teachers’ perceptions of bullying at school - WLE \[aggregated, weighted median\]                                                             |
| T\_CIVCLAS\_m  | dbl       | 20, 44.720, 40.500, 53.750, 51.630, NA, NA, 55.250, 4… | Teachers’ reports on civic-related activities in class - WLE \[aggregated, weighted median\]                                                  |
| T\_PCCLIM\_m   | dbl       | 350, 42.9500, 57.9250, 57.9200, 59.3825, NA, NA, 46.6… | Teachers’ perceptions of classroom climate - WLE \[aggregated, weighted median\]                                                              |
| T\_PDACCE\_m   | dbl       | 2000, 42.77000, 33.96000, 49.53000, 33.96000, NA, NA,… | Teachers’ PD activities for CCE topics - WLE \[aggregated, weighted median\]                                                                  |
| T\_PDATCH\_m   | dbl       | 30, 35.980, 39.500, 57.630, 28.940, NA, NA, 46.770, 3… | Teachers’ PD activities for teaching methods - WLE \[aggregated, weighted median\]                                                            |
| T\_PROBSC\_m   | dbl       | 4000, 64.85750, 41.77500, 39.51000, 25.10000, NA, NA,… | Teachers’ perceptions of social problems at school - WLE \[aggregated, weighted median\]                                                      |
| T\_PRPCCE\_m   | dbl       | 6000, 52.44000, 26.31000, 43.73000, 50.70000, NA, NA,… | Teachers’ preparedness for teaching CCE topics - WLE \[aggregated, weighted median\]                                                          |
| T\_STDCOM\_m   | dbl       | 8500, 45.77000, 43.88500, 49.12000, 58.45750, NA, NA,… | Teachers’ perceptions of student activities in the community - WLE \[aggregated, weighted median\]                                            |
| T\_STUDB\_m    | dbl       | 3000, 33.78500, 43.20000, 58.25000, 58.84500, NA, NA,… | Teachers’ perception of student behaviour at school - WLE \[aggregated, weighted median\]                                                     |
| T\_TCHPRT\_m   | dbl       | 3000, 48.59000, 51.33000, 42.33000, 53.37000, NA, NA,… | Teachers’ perception of teacher participation at school - WLE \[aggregated, weighted median\]                                                 |
| T\_AGE\_d      | dbl       | 7395, 8.566705, 4.381780, 10.361099, 8.411038, NA, NA… | Teacher’s age \[aggregated, weighted deviation\]                                                                                              |
| T\_CCESUB\_d   | dbl       | 62278, 0.4878694, 0.5163978, 0.4140393, 0.4985185, NA… | Teacher teaching CCE subject \[aggregated, weighted deviation\]                                                                               |
| T\_GENDER\_d   | dbl       | 16370, 0.5454545, 0.0000000, 0.5070926, 0.5384615, NA… | Teacher’s gender \[aggregated, weighted deviation\]                                                                                           |
| T\_TIME\_d     | dbl       | 757296, 0.09757388, 0.16329932, 0.15491933, 0.1329382… | Teacher’s teaching load at school \[aggregated, weighted deviation\]                                                                          |
| T\_BULSCH\_d   | dbl       | 8426, 3.877594, 4.583526, 8.061482, 8.690530, NA, NA,… | Teachers’ perceptions of bullying at school - WLE \[aggregated, weighted deviation\]                                                          |
| T\_CIVCLAS\_d  | dbl       | 13.674755, 5.161880, 8.715503, 10.219626, NA, NA, 8.6… | Teachers’ reports on civic-related activities in class - WLE \[aggregated, weighted deviation\]                                               |
| T\_PCCLIM\_d   | dbl       | 08557, 6.940165, 9.715521, 9.820527, 6.286779, NA, NA… | Teachers’ perceptions of classroom climate - WLE \[aggregated, weighted deviation\]                                                           |
| T\_PDACCE\_d   | dbl       | 7.665120, 0.000000, 7.943733, 0.000000, NA, NA, 18.01… | Teachers’ PD activities for CCE topics - WLE \[aggregated, weighted deviation\]                                                               |
| T\_PDATCH\_d   | dbl       | 15.965219, 14.934095, 7.020579, 0.000000, NA, NA, 12.… | Teachers’ PD activities for teaching methods - WLE \[aggregated, weighted deviation\]                                                         |
| T\_PROBSC\_d   | dbl       | 65896, 8.904725, 6.943999, 8.668303, 5.432819, NA, NA… | Teachers’ perceptions of social problems at school - WLE \[aggregated, weighted deviation\]                                                   |
| T\_PRPCCE\_d   | dbl       | 1.201927, NA, 7.551742, 21.846499, NA, NA, 13.632561,… | Teachers’ preparedness for teaching CCE topics - WLE \[aggregated, weighted deviation\]                                                       |
| T\_STDCOM\_d   | dbl       | 1703, 9.133821, 9.098184, 6.999699, 8.296600, NA, NA,… | Teachers’ perceptions of student activities in the community - WLE \[aggregated, weighted deviation\]                                         |
| T\_STUDB\_d    | dbl       | 25932, 7.977785, 5.976442, 10.069237, 7.191496, NA, N… | Teachers’ perception of student behaviour at school - WLE \[aggregated, weighted deviation\]                                                  |
| T\_TCHPRT\_d   | dbl       | 8817, 10.507597, 6.719079, 14.582159, 8.524837, NA, N… | Teachers’ perception of teacher participation at school - WLE \[aggregated, weighted deviation\]                                              |
| T\_AGE\_g      | dbl       | 1825, 41.91825, 41.91825, 41.91825, 41.91825, NA, NA,… | Teacher’s age \[aggregated, weighted mean by country\]                                                                                        |
| T\_CCESUB\_g   | dbl       | 37742, 0.2337742, 0.2337742, 0.2337742, 0.2337742, NA… | Teacher teaching CCE subject \[aggregated, weighted mean by country\]                                                                         |
| T\_GENDER\_g   | dbl       | 48211, 0.6348211, 0.6348211, 0.6348211, 0.6348211, NA… | Teacher’s gender \[aggregated, weighted mean by country\]                                                                                     |
| T\_TIME\_g     | dbl       | 78172, 0.2678172, 0.2678172, 0.2678172, 0.2678172, NA… | Teacher’s teaching load at school \[aggregated, weighted mean by country\]                                                                    |
| T\_BULSCH\_g   | dbl       | 7894, 48.77894, 48.77894, 48.77894, 48.77894, NA, NA,… | Teachers’ perceptions of bullying at school - WLE \[aggregated, weighted mean by country\]                                                    |
| T\_CIVCLAS\_g  | dbl       | 9076, 47.59076, 47.59076, 47.59076, 47.59076, NA, NA,… | Teachers’ reports on civic-related activities in class - WLE \[aggregated, weighted mean by country\]                                         |
| T\_PCCLIM\_g   | dbl       | 1232, 50.51232, 50.51232, 50.51232, 50.51232, NA, NA,… | Teachers’ perceptions of classroom climate - WLE \[aggregated, weighted mean by country\]                                                     |
| T\_PDACCE\_g   | dbl       | 3574, 45.23574, 45.23574, 45.23574, 45.23574, NA, NA,… | Teachers’ PD activities for CCE topics - WLE \[aggregated, weighted mean by country\]                                                         |
| T\_PDATCH\_g   | dbl       | 9453, 45.59453, 45.59453, 45.59453, 45.59453, NA, NA,… | Teachers’ PD activities for teaching methods - WLE \[aggregated, weighted mean by country\]                                                   |
| T\_PROBSC\_g   | dbl       | 8707, 46.58707, 46.58707, 46.58707, 46.58707, NA, NA,… | Teachers’ perceptions of social problems at school - WLE \[aggregated, weighted mean by country\]                                             |
| T\_PRPCCE\_g   | dbl       | 1959, 49.51959, 49.51959, 49.51959, 49.51959, NA, NA,… | Teachers’ preparedness for teaching CCE topics - WLE \[aggregated, weighted mean by country\]                                                 |
| T\_STDCOM\_g   | dbl       | 4843, 49.04843, 49.04843, 49.04843, 49.04843, NA, NA,… | Teachers’ perceptions of student activities in the community - WLE \[aggregated, weighted mean by country\]                                   |
| T\_STUDB\_g    | dbl       | 7629, 50.17629, 50.17629, 50.17629, 50.17629, NA, NA,… | Teachers’ perception of student behaviour at school - WLE \[aggregated, weighted mean by country\]                                            |
| T\_TCHPRT\_g   | dbl       | 6303, 47.66303, 47.66303, 47.66303, 47.66303, NA, NA,… | Teachers’ perception of teacher participation at school - WLE \[aggregated, weighted mean by country\]                                        |
| wt             | dbl       | 2644, 39.18254, 42.39334, 20.81949, 64.57123, 38.1037… | weight, total weight for students                                                                                                             |
| wi             | dbl       | 0000, 1.078947, 2.050000, 4.333332, 2.125000, 16.7804… | weight, within schools                                                                                                                        |
| wj             | dbl       | 42145, 36.315529, 20.679677, 4.804497, 30.386463, 2.2… | weight, between schools                                                                                                                       |
| wh             | dbl       | 39, 42, 21, 65, 38, 34, 80, 33, 22, 46, 67, 38, 39, 3… | weight, for histograms                                                                                                                        |
| wa1            | dbl       | , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, … | weight, within schools, normalized weights (method 2)                                                                                         |
| wa2            | dbl       | 198156, 1.35916147, 0.77396698, 0.17981529, 1.1372575… | weight, between schools, normalized weights (method 2)                                                                                        |
| wb1            | dbl       | , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, … | weight, within schools, effective sample size weights (method 1)                                                                              |
| wb2            | dbl       | 198156, 1.35916147, 0.77396698, 0.17981529, 1.1372575… | weight, between schools, effective sample size weights (method 1)                                                                             |
| ws             | dbl       | 037248, 0.17015833, 0.18410187, 0.09041295, 0.2804139… | weight, senate weight up to 500 cases                                                                                                         |
| LS3G01A        | dbl       | , 3, 3, 4, 4, 4, 2, 4, 3, 4, 3, 3, 4, 3, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G01B        | dbl       | , 3, 3, 4, 4, 4, 2, 3, 2, 4, 3, 3, 4, 3, 3, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G01C        | dbl       | , 3, 3, 4, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 2, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G01D        | dbl       | , 3, 3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 4, 3, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G01E        | dbl       | , 2, 3, 4, 4, 3, 3, 3, 2, 4, 4, 2, 2, 3, 3, 4, 2, 4, … | === no variable label ===                                                                                                                     |
| LS3G01F        | dbl       | , 3, 3, 4, 4, 4, 2, 4, 2, 4, 4, 3, 4, 3, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G02A        | dbl       | , 4, 3, 4, 4, 3, 1, 2, 3, 4, 3, 3, 1, 2, 3, 4, 2, 4, … | === no variable label ===                                                                                                                     |
| LS3G02B        | dbl       | , 4, 3, 4, 4, 4, 2, 4, 3, 4, 2, 3, 2, 2, 3, 4, 2, 4, … | === no variable label ===                                                                                                                     |
| LS3G02C        | dbl       | , 3, 3, 4, 4, 3, 3, 4, 3, 4, 3, 2, 2, 3, 2, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G02D        | dbl       | A, 3, 3, 2, 3, 3, 2, 2, 3, 4, 3, 2, 1, 2, 2, 4, 2, 1,… | === no variable label ===                                                                                                                     |
| LS3G02E        | dbl       | , 3, 3, 2, 3, 3, 1, 2, 3, 4, 4, 3, 1, 3, 3, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G03A        | dbl       | , 4, 3, 4, 4, 3, 4, 3, 3, 3, 4, 2, 4, 4, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G03B        | dbl       | , 4, 3, 4, 3, 3, 3, 2, 3, 4, 4, 3, 4, 3, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G03C        | dbl       | , 3, 3, 4, 3, 3, 2, 3, 3, 4, 3, 2, 2, 3, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G03D        | dbl       | , 4, 3, 4, 3, 4, 1, NA, 2, 4, 3, 2, 2, 3, 3, 4, 4, 4,… | === no variable label ===                                                                                                                     |
| LS3G03E        | dbl       | , 4, 2, 3, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 2, 1, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G03F        | dbl       | , 4, 3, 4, 4, 3, 4, 3, 2, 4, 4, 2, 4, 3, 2, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G04A        | dbl       | , 2, 2, 1, 2, 2, 2, 2, 2, 1, 2, 2, 1, 3, 3, 1, 4, 3, … | === no variable label ===                                                                                                                     |
| LS3G04B        | dbl       | , 2, 2, 2, 3, 3, 1, 2, 2, 4, 2, 3, 1, 3, 2, 1, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G04C        | dbl       | , 2, 2, 4, 3, 2, 3, 2, 3, 2, 3, 2, 4, 1, 1, 1, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G04D        | dbl       | , 3, 2, 4, 3, 2, 4, 2, 2, 1, 3, 2, 2, 2, 2, 1, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G04E        | dbl       | , 3, 3, 1, 3, 2, 2, 2, 2, 1, 1, 2, 2, 1, 2, 1, 4, 2, … | === no variable label ===                                                                                                                     |
| LS3G04F        | dbl       | , 2, 3, 4, 3, 3, 3, 3, 3, 3, 1, 3, 4, 3, 2, 3, 4, 3, … | === no variable label ===                                                                                                                     |
| LS3G04G        | dbl       | , 3, 3, 2, 3, 2, 2, 2, 3, 1, 1, 1, 3, 2, 2, 1, 4, 2, … | === no variable label ===                                                                                                                     |
| LS3G04H        | dbl       | , 3, 3, 4, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 4, 3, … | === no variable label ===                                                                                                                     |
| LS3G04I        | dbl       | , 3, 3, 4, 3, 3, 1, 2, 3, 4, 1, 3, 4, 3, 3, 3, 4, 3, … | === no variable label ===                                                                                                                     |
| LS3G04J        | dbl       | , 3, 3, 4, 3, 3, 2, 3, 3, 4, 4, 3, 4, 3, 3, 3, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G05A        | dbl       | , 2, 3, 3, 3, 2, 1, 2, 3, 4, 2, 2, 4, 3, 2, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G05B        | dbl       | , 2, 2, 2, 3, 2, 3, 2, 3, 4, 1, 2, 3, 2, 2, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G05C        | dbl       | , 3, 3, 4, 3, 3, 2, 2, 3, 4, 3, 2, 4, 3, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G05D        | dbl       | , 3, 3, 4, 3, 3, 4, 4, 3, 4, 3, 2, 4, 4, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G05E        | dbl       | , 3, 3, 4, 3, 3, 1, 4, 2, 2, 3, 2, 4, 3, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G05F        | dbl       | , 3, 3, 3, 3, 4, 3, 4, 3, 2, 3, 2, 4, 3, 3, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G05G        | dbl       | , 2, 3, 1, 3, 2, 2, 2, 2, 1, 3, 2, 2, 3, 3, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G05H        | dbl       | , 2, 2, 4, 3, 3, 4, 4, 2, 1, 3, 2, 1, 3, 2, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G05I        | dbl       | , 2, 3, 3, 3, 3, 1, 4, 2, 1, 4, 2, 1, 3, 2, 4, 3, 4, … | === no variable label ===                                                                                                                     |
| LS3G05J        | dbl       | , 3, 3, 4, 3, 4, 3, 4, 3, 4, 4, 3, 4, 3, 2, 4, 4, 4, … | === no variable label ===                                                                                                                     |
| LS3G06A        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G06B        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G06C        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G06D        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G06E        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G06F        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G06G        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G06H        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G07A        | dbl       | , 2, 3, 2, 3, 1, 3, 3, 3, 2, 2, 3, 2, 3, 1, 1, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07B        | dbl       | , 3, 3, 3, 3, 3, 2, 3, 3, 2, 2, 3, 3, 2, 3, 3, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07C        | dbl       | , 2, 3, 2, 3, 2, NA, 3, 2, 1, 3, 3, 3, 3, 3, 3, 3, 3,… | === no variable label ===                                                                                                                     |
| LS3G07D        | dbl       | , 3, 3, 2, 3, 2, 2, 3, 2, 1, 3, 3, 3, 3, 3, 3, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07E        | dbl       | , 2, 2, 2, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07F        | dbl       | , 2, 3, 3, 3, 3, 2, 3, 3, 2, 3, 3, 2, 3, 1, 3, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07G        | dbl       | , 2, 3, 3, 2, 3, 1, 3, 2, 3, 3, 3, 2, 3, 3, 3, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07H        | dbl       | , 3, 3, 2, 2, 2, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07I        | dbl       | , 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 2, 3, 3, 2, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G07J        | dbl       | , 3, 3, 3, 3, 3, 1, 3, 3, 2, 3, 3, 2, 3, 3, 2, 3, 2, … | === no variable label ===                                                                                                                     |
| LS3G07K        | dbl       | , 2, 3, 3, 3, 3, 2, 2, 3, 2, 3, 3, 3, 2, 1, 2, 3, 3, … | === no variable label ===                                                                                                                     |
| LS3G08A        | dbl       | , 1, 2, 2, 4, 1, 1, 1, 3, 1, 2, 2, 2, 1, 2, 4, 1, 2, … | === no variable label ===                                                                                                                     |
| LS3G08B        | dbl       | , 1, 2, 1, 4, 1, 2, 1, 4, 1, 2, 2, 2, 1, 2, 4, 1, 2, … | === no variable label ===                                                                                                                     |
| LS3G08C        | dbl       | , 1, 2, 1, 2, 1, 1, 1, 3, 1, 1, 2, 2, 1, 2, 4, 1, 2, … | === no variable label ===                                                                                                                     |
| LS3G08D        | dbl       | , 1, 2, 2, 2, 1, 3, 1, 4, 1, 1, 2, 2, 1, 2, 4, 1, 1, … | === no variable label ===                                                                                                                     |
| LS3G08E        | dbl       | , 1, 2, 1, 2, 1, 4, 1, 4, 1, 1, 2, 2, 1, 2, 4, 1, 1, … | === no variable label ===                                                                                                                     |
| LS3G09A        | dbl       | , 3, 1, 2, 3, 2, 4, 2, 4, 1, 3, 3, 4, 3, 2, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G09B        | dbl       | , 3, 2, 1, 1, 3, 4, 4, 4, 3, 2, 1, 4, 3, 2, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G09C        | dbl       | , 1, 1, 1, NA, 2, 4, 1, 2, 1, 1, 1, 3, 1, 1, 1, 1, 1,… | === no variable label ===                                                                                                                     |
| LS3G09D        | dbl       | , 3, 1, 3, 3, 3, 4, 3, 3, 3, 1, 1, 3, 3, 2, 4, 2, 2, … | === no variable label ===                                                                                                                     |
| LS3G09E        | dbl       | , 2, 1, 2, 2, 2, 3, 2, 2, 1, 1, 2, 3, 2, 2, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G09F        | dbl       | , 2, 2, 3, 3, 3, 3, 2, 2, 1, 2, 3, 3, 2, 2, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G09G        | dbl       | , 2, 2, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 2, 3, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G09H        | dbl       | , 3, 1, 3, 3, 2, 4, 2, 2, 1, 2, 1, 3, 2, 1, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G09I        | dbl       | , 3, 2, 3, 4, 3, 3, 3, 3, 4, 2, 3, 4, 3, 3, 4, 3, 2, … | === no variable label ===                                                                                                                     |
| LS3G09J        | dbl       | , 1, 3, 3, 2, 3, 3, 1, 2, 1, 3, 1, 3, 3, 1, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| LS3G09K        | dbl       | , 2, 3, 3, 2, 2, 3, 2, 3, 4, 3, 3, 3, 2, 1, 4, 2, 1, … | === no variable label ===                                                                                                                     |
| L\_ATTCORR     | dbl       | 8, 51.18, 36.12, 51.18, 36.12, 47.20, 47.20, 51.18, 5… | === no variable label ===                                                                                                                     |
| L\_ATTDIV      | dbl       | 2, 55.65, 55.65, 55.65, 55.65, 55.65, 55.65, 55.65, 5… | === no variable label ===                                                                                                                     |
| L\_ATTHS       | dbl       | 7, 65.57, 65.57, 49.38, 56.50, 42.76, 65.57, 47.45, 6… | === no variable label ===                                                                                                                     |
| L\_ATTVIOL     | dbl       | 2, 51.23, 53.57, 51.23, 48.65, 51.23, 55.60, 60.39, 5… | === no variable label ===                                                                                                                     |
| L\_AUTGOV      | dbl       | 6, 47.94, 46.26, 47.94, 17.67, 27.06, 40.44, 55.30, 4… | === no variable label ===                                                                                                                     |
| L\_DISLAW      | dbl       | 0, 54.29, 49.53, 46.13, 34.65, 42.56, 42.56, 51.16, 3… | === no variable label ===                                                                                                                     |
| L\_EMPCLAS     | dbl       | 5, 46.17, 41.19, 50.87, 42.71, 48.27, 41.19, 36.95, 5… | === no variable label ===                                                                                                                     |

``` r
#------------------------------------------------
# variables elegidas
#------------------------------------------------

# L_ATTCORR = Tolerancia a la corrupción (M = 50, SD = 10)
# L_AUTGOV = Autoritarismo (M = 50, SD = 10)
# S_NISB = Nivel Socioeconómico (M = 0, SD = 1)
# PV1CIV = Conocimiento Cívico (M = 500, SD = 100)

# S_OPDISC  = Apertura a la discusión en la sala de clases (M = 50, SD = 10)
# S_CIVLRN  = Educación Cívica (M = 50, SD = 10)
# S_POLDISC = Discusión Política  (M = 50, SD = 10)
# S_SOCMED  = Frecuencia de uso de redes sociales para compartir contenidos políticos (M = 50, SD = 10)


#------------------------------------------------
# matriz general
#------------------------------------------------

data_tol %>%
dplyr::select(
  L_ATTCORR, L_AUTGOV, S_NISB, PV1CIV, 
  S_CIVLRN, S_OPDISC, S_POLDISC, S_SOCMED
  ) %>%
r4sda::remove_labels() %>%
corrr::correlate() %>%
knitr::kable(., digits = 2)
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

| term       | L\_ATTCORR | L\_AUTGOV | S\_NISB | PV1CIV | S\_CIVLRN | S\_OPDISC | S\_POLDISC | S\_SOCMED |
|:-----------|-----------:|----------:|--------:|-------:|----------:|----------:|-----------:|----------:|
| L\_ATTCORR |         NA |      0.73 |   -0.18 |  -0.56 |     -0.09 |     -0.07 |       0.00 |      0.12 |
| L\_AUTGOV  |       0.73 |        NA |   -0.19 |  -0.58 |     -0.10 |      0.00 |      -0.02 |      0.12 |
| S\_NISB    |      -0.18 |     -0.19 |      NA |   0.34 |      0.15 |      0.07 |       0.15 |      0.18 |
| PV1CIV     |      -0.56 |     -0.58 |    0.34 |     NA |      0.18 |      0.17 |       0.00 |     -0.06 |
| S\_CIVLRN  |      -0.09 |     -0.10 |    0.15 |   0.18 |        NA |      0.30 |       0.26 |      0.18 |
| S\_OPDISC  |      -0.07 |      0.00 |    0.07 |   0.17 |      0.30 |        NA |       0.22 |      0.17 |
| S\_POLDISC |       0.00 |     -0.02 |    0.15 |   0.00 |      0.26 |      0.22 |         NA |      0.50 |
| S\_SOCMED  |       0.12 |      0.12 |    0.18 |  -0.06 |      0.18 |      0.17 |       0.50 |        NA |

``` r
#------------------------------------------------
# matriz general, diagonal
#------------------------------------------------

data_tol %>%
dplyr::select(
  L_ATTCORR, L_AUTGOV, S_NISB, PV1CIV, 
  S_CIVLRN, S_OPDISC, S_POLDISC, S_SOCMED
  ) %>%
r4sda::remove_labels() %>%
corrr::correlate() %>%
corrr::shave() %>%
knitr::kable(., digits = 2)
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

| term       | L\_ATTCORR | L\_AUTGOV | S\_NISB | PV1CIV | S\_CIVLRN | S\_OPDISC | S\_POLDISC | S\_SOCMED |
|:-----------|-----------:|----------:|--------:|-------:|----------:|----------:|-----------:|----------:|
| L\_ATTCORR |         NA |        NA |      NA |     NA |        NA |        NA |         NA |        NA |
| L\_AUTGOV  |       0.73 |        NA |      NA |     NA |        NA |        NA |         NA |        NA |
| S\_NISB    |      -0.18 |     -0.19 |      NA |     NA |        NA |        NA |         NA |        NA |
| PV1CIV     |      -0.56 |     -0.58 |    0.34 |     NA |        NA |        NA |         NA |        NA |
| S\_CIVLRN  |      -0.09 |     -0.10 |    0.15 |   0.18 |        NA |        NA |         NA |        NA |
| S\_OPDISC  |      -0.07 |      0.00 |    0.07 |   0.17 |      0.30 |        NA |         NA |        NA |
| S\_POLDISC |       0.00 |     -0.02 |    0.15 |   0.00 |      0.26 |      0.22 |         NA |        NA |
| S\_SOCMED  |       0.12 |      0.12 |    0.18 |  -0.06 |      0.18 |      0.17 |        0.5 |        NA |

``` r
#------------------------------------------------
# matriz general, pares de correlaciones
#------------------------------------------------

data_tol %>%
dplyr::select(
  L_ATTCORR, L_AUTGOV, S_NISB, PV1CIV, 
  S_CIVLRN, S_OPDISC, S_POLDISC, S_SOCMED
  ) %>%
r4sda::remove_labels() %>%
corrr::correlate() %>%
corrr::stretch() %>%
knitr::kable(., digits = 2)
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

| x          | y          |     r |
|:-----------|:-----------|------:|
| L\_ATTCORR | L\_ATTCORR |    NA |
| L\_ATTCORR | L\_AUTGOV  |  0.73 |
| L\_ATTCORR | S\_NISB    | -0.18 |
| L\_ATTCORR | PV1CIV     | -0.56 |
| L\_ATTCORR | S\_CIVLRN  | -0.09 |
| L\_ATTCORR | S\_OPDISC  | -0.07 |
| L\_ATTCORR | S\_POLDISC |  0.00 |
| L\_ATTCORR | S\_SOCMED  |  0.12 |
| L\_AUTGOV  | L\_ATTCORR |  0.73 |
| L\_AUTGOV  | L\_AUTGOV  |    NA |
| L\_AUTGOV  | S\_NISB    | -0.19 |
| L\_AUTGOV  | PV1CIV     | -0.58 |
| L\_AUTGOV  | S\_CIVLRN  | -0.10 |
| L\_AUTGOV  | S\_OPDISC  |  0.00 |
| L\_AUTGOV  | S\_POLDISC | -0.02 |
| L\_AUTGOV  | S\_SOCMED  |  0.12 |
| S\_NISB    | L\_ATTCORR | -0.18 |
| S\_NISB    | L\_AUTGOV  | -0.19 |
| S\_NISB    | S\_NISB    |    NA |
| S\_NISB    | PV1CIV     |  0.34 |
| S\_NISB    | S\_CIVLRN  |  0.15 |
| S\_NISB    | S\_OPDISC  |  0.07 |
| S\_NISB    | S\_POLDISC |  0.15 |
| S\_NISB    | S\_SOCMED  |  0.18 |
| PV1CIV     | L\_ATTCORR | -0.56 |
| PV1CIV     | L\_AUTGOV  | -0.58 |
| PV1CIV     | S\_NISB    |  0.34 |
| PV1CIV     | PV1CIV     |    NA |
| PV1CIV     | S\_CIVLRN  |  0.18 |
| PV1CIV     | S\_OPDISC  |  0.17 |
| PV1CIV     | S\_POLDISC |  0.00 |
| PV1CIV     | S\_SOCMED  | -0.06 |
| S\_CIVLRN  | L\_ATTCORR | -0.09 |
| S\_CIVLRN  | L\_AUTGOV  | -0.10 |
| S\_CIVLRN  | S\_NISB    |  0.15 |
| S\_CIVLRN  | PV1CIV     |  0.18 |
| S\_CIVLRN  | S\_CIVLRN  |    NA |
| S\_CIVLRN  | S\_OPDISC  |  0.30 |
| S\_CIVLRN  | S\_POLDISC |  0.26 |
| S\_CIVLRN  | S\_SOCMED  |  0.18 |
| S\_OPDISC  | L\_ATTCORR | -0.07 |
| S\_OPDISC  | L\_AUTGOV  |  0.00 |
| S\_OPDISC  | S\_NISB    |  0.07 |
| S\_OPDISC  | PV1CIV     |  0.17 |
| S\_OPDISC  | S\_CIVLRN  |  0.30 |
| S\_OPDISC  | S\_OPDISC  |    NA |
| S\_OPDISC  | S\_POLDISC |  0.22 |
| S\_OPDISC  | S\_SOCMED  |  0.17 |
| S\_POLDISC | L\_ATTCORR |  0.00 |
| S\_POLDISC | L\_AUTGOV  | -0.02 |
| S\_POLDISC | S\_NISB    |  0.15 |
| S\_POLDISC | PV1CIV     |  0.00 |
| S\_POLDISC | S\_CIVLRN  |  0.26 |
| S\_POLDISC | S\_OPDISC  |  0.22 |
| S\_POLDISC | S\_POLDISC |    NA |
| S\_POLDISC | S\_SOCMED  |  0.50 |
| S\_SOCMED  | L\_ATTCORR |  0.12 |
| S\_SOCMED  | L\_AUTGOV  |  0.12 |
| S\_SOCMED  | S\_NISB    |  0.18 |
| S\_SOCMED  | PV1CIV     | -0.06 |
| S\_SOCMED  | S\_CIVLRN  |  0.18 |
| S\_SOCMED  | S\_OPDISC  |  0.17 |
| S\_SOCMED  | S\_POLDISC |  0.50 |
| S\_SOCMED  | S\_SOCMED  |    NA |

``` r
#------------------------------------------------
# matriz general, pares de correlaciones
#------------------------------------------------

data_tol %>%
dplyr::select(
  L_ATTCORR, L_AUTGOV, S_NISB, PV1CIV, 
  S_CIVLRN, S_OPDISC, S_POLDISC, S_SOCMED
  ) %>%
r4sda::remove_labels() %>%
corrr::correlate() %>%
corrr::rplot()
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

    ## Don't know how to automatically pick scale for object of type noquote. Defaulting to continuous.

![](clase_13_correlacion_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
#------------------------------------------------
# matriz general, pares de correlaciones
#------------------------------------------------

data_tol %>%
dplyr::select(
  L_ATTCORR, L_AUTGOV, S_NISB, PV1CIV, 
  S_CIVLRN, S_OPDISC, S_POLDISC, S_SOCMED
  ) %>%
r4sda::remove_labels() %>%
corrr::correlate() %>%
corrr::network_plot()
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

![](clase_13_correlacion_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

# Anexos

## Ejemplo de relación No lineal

``` r
#------------------------------------------------------------------------------
# curve relation
#------------------------------------------------------------------------------


# -----------------------------------------------
# load data
# -----------------------------------------------

url_file <- 'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/curved_y_x.csv'
data_curved <- readr::read_csv(url_file)
```

    ## 
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ## cols(
    ##   x = col_double(),
    ##   y = col_double()
    ## )

``` r
# -----------------------------------------------
# scatter plot
# -----------------------------------------------

plot(data_curved$x, data_curved$y,
  ylab = 'y score',
  xlab = 'x score')
```

![](clase_13_correlacion_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
# -----------------------------------------------
# correlation
# -----------------------------------------------

cor(data_curved$x, data_curved$y)
```

    ## [1] 0.001739082

``` r
# -----------------------------------------------
# linear model
# -----------------------------------------------

# estimates
data_curved %>%
mutate(x1 = psi2301::z_score(x)) %>%
lm(y ~ x1, data = .) %>%
broom::tidy() %>%
knitr::kable(., digits = 2)
```

| term        | estimate | std.error | statistic | p.value |
|:------------|---------:|----------:|----------:|--------:|
| (Intercept) |   100.61 |       0.3 |    340.76 |    0.00 |
| x1          |     0.01 |       0.3 |      0.02 |    0.98 |

``` r
# model fit
data_curved %>%
mutate(x1 = psi2301::z_score(x)) %>%
lm(y ~ x1, data = .) %>%
broom::glance() %>%
knitr::kable(., digits = 2)
```

| r.squared | adj.r.squared | sigma | statistic | p.value |  df |  logLik |    AIC |    BIC | deviance | df.residual | nobs |
|----------:|--------------:|------:|----------:|--------:|----:|--------:|-------:|-------:|---------:|------------:|-----:|
|         0 |         -0.01 |  3.52 |         0 |    0.98 |   1 | -379.12 | 764.24 | 773.11 |  1733.14 |         140 |  142 |

``` r
# -----------------------------------------------
# linear model with quadratic and cubir effects
# -----------------------------------------------

# estimates
data_curved %>%
mutate(x1 = psi2301::z_score(x)) %>%
mutate(x2 = x1*x1) %>%
mutate(x3 = x1*x1*x1) %>%
lm(y ~ x1 + x2 + x3, data = .) %>%
broom::tidy() %>%
knitr::kable(., digits = 2)
```

| term        | estimate | std.error | statistic | p.value |
|:------------|---------:|----------:|----------:|--------:|
| (Intercept) |   103.95 |      0.27 |    389.01 |    0.00 |
| x1          |    -0.10 |      0.45 |     -0.23 |    0.82 |
| x2          |    -3.38 |      0.21 |    -16.15 |    0.00 |
| x3          |     0.25 |      0.24 |      1.04 |    0.30 |

``` r
# model fit
data_curved %>%
mutate(x1 = psi2301::z_score(x)) %>%
mutate(x2 = x1*x1) %>%
mutate(x3 = x1*x1*x1) %>%
lm(y ~ x1 + x2 + x3, data = .) %>%
broom::glance() %>%
knitr::kable(., digits = 2)
```

| r.squared | adj.r.squared | sigma | statistic | p.value |  df |  logLik |    AIC |    BIC | deviance | df.residual | nobs |
|----------:|--------------:|------:|----------:|--------:|----:|--------:|-------:|-------:|---------:|------------:|-----:|
|      0.66 |          0.65 |  2.06 |     90.02 |       0 |   3 | -302.15 | 614.29 | 629.07 |   586.13 |         138 |  142 |

# Referencias

Carrasco, D., & Pavón, A. (2021). Tolerance of corruption among students
in Latin America. In E. Treviño, D. Carrasco, E. Claes, & K. Kennedy
(Eds.), Good Citizenship for the Next Generation. A Global Perspective
Using IEA ICCS 2016 Data. Springer International.
