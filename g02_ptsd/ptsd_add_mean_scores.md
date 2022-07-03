Paper: Rehabilitating civilian victims of war
================

# Paper

-   Title: “Rehabilitating civilian victims of war through psychosocial
    intervention in Sierra Leone”

-   References

Mughal, U., Carrasco, D., Brown, R., & Ayers, S. (2015). Rehabilitating
civilian victims of war through psychosocial intervention in Sierra
Leone. Journal of Applied Social Psychology, 45(11), 593–601.
<https://doi.org/10.1111/jasp.12322>

# Agregar puntajes de escalas

``` r
# -----------------------------------------------------------------------------
# mean scores
# -----------------------------------------------------------------------------

# -----------------------------------------------
# mean_score functiion
# -----------------------------------------------

mean_score <- function (..., na.rm = TRUE) {
    rowMeans(cbind(...), na.rm = na.rm)
}


# -----------------------------------------------
# reverse function
# -----------------------------------------------

reverse <- function (var) {
    var <- labelled::remove_labels(var)
    var <- haven::zap_labels(var)
    max <- max(var, na.rm = TRUE)
    min <- min(var, na.rm = TRUE)
    return(max + min - var)
}

# -----------------------------------------------
# measures presented in the paper
# -----------------------------------------------

# ptsd
data_ptsd <- read.csv(
  url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
  )
)

# -----------------------------------------------
# measures presented in the paper
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
data_ptsd <- data_ptsd %>%
              # PTSD
              mutate(ptsd = mean_score(
              ie01, # Any reminder brought back feelings about it
              ie02, # I had trouble staying asleep
              ie03, # Other things kept making me think about it
              ie04, # I felt irritable and angry
              ie05, # I avoided letting myself get upset when I thought about it or was reminded of it
              ie06, # I thought about it when I didn't mean to
              ie07, # I felt as if it hadn't happened or wasn't real.
              ie08, # Pictures about it popped into my head
              ie09, # I was jumpy and easily startled
              ie10, # I was aware that I still had a lot of feelings about it, but I didn't deal with them
              ie11, # I found myself acting or feeling like I was back at that time
              ie12, # I had waves of strong feelings about it
              ie14, # I had trouble concentrating
              ie15, # Reminders of it caused me to have physical reactions such as sweating, trouble breathing, nausea or a pounding heart
              ie16  # I felt watchful and on-guard
                )) %>%
              # Intergroup anxiety
              ## create reverse scores
              mutate(anx1_r = reverse(anx1)) %>%
              mutate(anx4_r = reverse(anx4)) %>%
              ## mean score
              mutate(anxi = mean_score(
              anx1_r  ,  # [R] Relaxed
              anx2    ,  # Threatened
              anx3    ,  # Awkward
              anx4_r  ,  # [R] Safe
              anx5    ,  # Nervous
              anx6       # Anxious
              )) %>%
              # Out-group blame
              mutate(outb = mean_score(
              noe6,      # I think that the rebels are entirely to blame for what they have done during the war 
              noe7       # I think that the rebels are responsible for everything they did
              )) %>%
              # Intergroup forgiveness
              mutate(ifor = mean_score(
              for6,  # I think my group should reach out to the rebels and forgive them what they have done
              for5   # I should forgive the rebels their misdeeds              
              )) %>%
              # In-group (National) Identification
              mutate(iden = mean_score(
              ide1,  # I am proud to be a Sierra Leonine
              ide2   # I have very strong ties with Sierra Leone
              )) %>%
              # Out-group contact
              mutate(cont = con) %>%
              # Personal War Trauma Experience
              mutate(wart = mean_score(
              war2,  # I have seen dead people
              war3,  # I have lost people of my family in the war
              war4,  # I was attacked
              war5,  # I have seen how people were killed
              war6   # I have been fighting                
              )) %>%
              # dummy variables
              ## sex
              mutate(sex_original = sex) %>%
              dplyr::select(-sex) %>%
              mutate(sex = case_when(
                sex_original == 1 ~ 1, # male
                sex_original == 2 ~ 0  # female
                )) %>%
              ## employment
              mutate(emp_original = emp) %>%
              dplyr::select(-emp) %>%
              mutate(emp = case_when(
                emp_original == 1 ~ 0, # unemployed
                emp_original == 2 ~ 1  # employed
                )) %>%
              ## marital status
              mutate(mar_original = mar) %>%
              dplyr::select(-mar) %>%
              mutate(mar = case_when(
                mar_original == 1 ~ 1, # married
                mar_original == 2 ~ 0  # not married
                )) %>%
              ## religion
              mutate(rel_original = rel) %>%
              dplyr::select(-rel) %>%
              mutate(rel = case_when(
                rel_original == 1 ~ 0, # muslim
                TRUE ~ 1               # non-muslim
                )) %>%
              ## treated
              mutate(trt = case_when(
                cond == 'c1' ~ 0, # delayed control
                cond == 't1' ~ 1  # treated
                )) %>%
              dplyr::glimpse()
```

    ## Rows: 100
    ## Columns: 76
    ## $ id_i         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17…
    ## $ cond         <chr> "c1", "c1", "c1", "c1", "c1", "c1", "c1", "c1", "c1", "c1…
    ## $ ie01         <int> 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 3, 4, 5, 5, 5, 5, …
    ## $ ie02         <int> 5, 4, 2, 5, 5, 5, 1, 1, 4, 5, 1, 5, 3, 4, 4, 5, 1, 2, 4, …
    ## $ ie03         <int> 4, 3, 4, 5, 5, 5, 4, 4, 3, 5, 5, 5, 5, 3, 4, 5, 5, 5, 5, …
    ## $ ie04         <int> 5, 4, 4, 5, 3, 5, 3, 3, 4, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, …
    ## $ ie05         <int> 4, 4, 5, 5, 5, 5, 4, 4, 3, 5, 5, 1, 1, 2, 3, 4, 5, 5, 4, …
    ## $ ie06         <int> 4, 4, 5, 5, 5, 2, 3, 4, 4, 5, 4, 3, 5, 3, 5, 4, 3, 5, 4, …
    ## $ ie07         <int> 5, 4, 4, 1, 3, 4, 5, 3, 4, 5, 5, 3, 5, 1, 1, 1, 3, 1, 5, …
    ## $ ie08         <int> 5, 4, 1, 5, 5, 5, 4, 2, 3, 5, 5, 4, 3, 5, 5, 3, 5, 5, 4, …
    ## $ ie09         <int> 5, 5, 2, 5, 5, 5, 3, 3, 2, 5, 5, 4, 3, 5, 5, 1, 5, 3, 2, …
    ## $ ie10         <int> 4, 3, 2, 1, 4, 4, 1, 4, 4, 2, 1, 4, 3, 5, 5, 5, 5, 2, 3, …
    ## $ ie11         <int> 4, 4, 2, 5, 5, 4, 1, 2, 1, 5, 5, 4, 1, 2, 1, 3, 1, 4, 1, …
    ## $ ie12         <int> 5, 3, 2, 5, 3, 5, 5, 5, 4, 5, 5, 4, 5, 5, 5, 5, 5, 4, 3, …
    ## $ ie13         <int> 3, 4, 5, 3, 2, 5, 3, 4, 3, 1, 1, 2, 4, 4, 5, 4, 4, 4, 4, …
    ## $ ie14         <int> 4, 3, 1, 5, 3, 5, 1, 1, 1, 5, 5, 5, 4, 2, 1, 4, 2, 4, 3, …
    ## $ ie15         <int> 5, 3, 1, 5, 4, 5, 3, 2, 3, 1, 5, 4, 4, 2, 3, 3, 2, 5, 4, …
    ## $ ie16         <int> 4, 4, 1, 5, 4, 5, 2, 4, 4, 5, 5, 5, 4, 3, 5, 4, 2, 5, 3, …
    ## $ ie17         <int> 4, 3, 1, 1, 4, 5, 4, 5, 3, 1, 1, 2, 4, 5, 5, 5, 5, 5, 3, …
    ## $ ptc1         <int> 3, 3, 1, 2, 4, 1, 3, 3, 4, 4, 1, 4, 2, 5, 1, 2, 5, 2, 4, …
    ## $ ptc2         <int> 2, 4, 1, 1, 4, 2, 3, 4, 5, 1, 5, 4, 4, 1, 1, 1, 2, 2, 5, …
    ## $ ide1         <int> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 5, 5, 5, 1, 5, 5, 2, …
    ## $ ide2         <int> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 5, 4, …
    ## $ noe1         <int> 5, 5, 5, 5, 5, 2, 4, 5, 3, 1, 5, 5, 5, 5, 5, 5, 4, 5, 2, …
    ## $ noe2         <int> 5, 4, 5, 4, 5, 5, 3, 3, 1, 1, 5, 5, 5, 5, 5, 5, 3, 5, 1, …
    ## $ for1         <int> 4, 4, 5, 4, 3, 1, 4, 4, 3, 1, 1, 4, 4, 1, 3, 5, 3, 4, 3, …
    ## $ for2         <int> 3, 4, 5, 5, 3, 1, 2, 5, 4, 5, 1, 4, 2, 1, 3, 5, 4, 2, 5, …
    ## $ for3         <int> 3, 4, 2, 3, 3, 1, 4, 5, 3, 1, 5, 4, 4, 1, 3, 3, 4, 2, 4, …
    ## $ for4         <int> 3, 4, 1, 3, 4, 1, 4, 3, 4, 5, 2, 1, 2, 4, 4, 2, 4, 4, 3, …
    ## $ for5         <int> 3, 5, 1, 4, 4, 1, 4, 3, 4, 5, 2, 1, 4, 4, 4, 2, 4, 4, 2, …
    ## $ con          <int> 3, 5, 1, 3, 3, 1, 3, 3, 3, 5, 1, 1, 4, 1, 1, 2, 3, 1, 1, …
    ## $ noe3         <int> 3, 4, 1, 3, 4, 2, 3, 4, 3, 5, 5, 5, 4, 5, 1, 2, 1, 5, 3, …
    ## $ noe4         <int> 4, 3, 5, 4, 4, 5, 4, 2, 4, 5, 5, 5, 3, 2, 1, 1, 1, 4, 5, …
    ## $ noe5         <int> 4, 3, 1, 1, 5, 5, 3, 3, 1, 1, 5, 5, 4, 4, 5, 1, 3, 5, 5, …
    ## $ for6         <int> 4, 3, 1, 4, 5, 5, 2, 3, 3, 5, 5, 1, 4, 4, 4, 1, 4, 4, 3, …
    ## $ noe6         <int> 5, 5, 1, 5, 4, 1, 3, 5, 3, 5, 1, 5, 4, 4, 1, 1, 2, 4, 2, …
    ## $ noe7         <int> 5, 5, 1, 5, 5, 1, 2, 5, 4, 5, 1, 5, 4, 1, 1, 5, 4, 5, 4, …
    ## $ noe8         <int> 2, 3, 3, 4, 2, 4, 4, 2, 5, 1, 1, 5, 1, 1, 3, 2, 3, 1, 3, …
    ## $ anx1         <int> 2, 4, 5, 3, 4, 1, 4, 2, 1, 5, 1, 1, 4, 5, 3, 2, 5, 1, 4, …
    ## $ anx2         <int> 4, 2, 1, 1, 2, 5, 1, 5, 1, 1, 5, 5, 1, 1, 3, 4, 1, 5, 4, …
    ## $ anx3         <int> 4, 3, 3, 1, 4, 5, 3, 5, 2, 1, 5, 5, 1, 1, 1, 5, 1, 1, 2, …
    ## $ anx4         <int> 3, 4, 3, 5, 4, 1, 4, 2, 4, 5, 1, 1, 1, 1, 3, 1, 5, 5, 3, …
    ## $ anx5         <int> 4, 2, 4, 2, 4, 5, 1, 5, 1, 1, 5, 5, 5, 5, 1, 1, 1, 1, 5, …
    ## $ anx6         <int> 5, 1, 1, 4, 4, 5, 1, 2, 5, 1, 5, 1, 5, 1, 1, 5, 5, 1, 4, …
    ## $ war1         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ war2         <int> 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, …
    ## $ war3         <int> 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, …
    ## $ war4         <int> 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, …
    ## $ war5         <int> 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, …
    ## $ war6         <int> 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, …
    ## $ war7         <int> 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, …
    ## $ war8         <int> 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, …
    ## $ ie18         <int> 2, 1, 2, 4, 3, 4, 3, 5, 3, 1, 3, 3, 3, 2, 3, 1, 3, 2, 3, …
    ## $ fut1         <int> 2, 2, 1, 2, 2, 2, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, …
    ## $ fut2         <int> 3, 5, 5, 4, 2, 4, 5, 3, 5, 5, 5, 5, 4, 5, 5, 1, 5, 4, 2, …
    ## $ age          <int> 47, 38, 34, 65, 28, 37, 43, 45, 27, 22, 15, 18, 27, 25, 3…
    ## $ nat          <chr> "TAM", "MAK", "SLE", "MAP", "MAK", "MAK", "SLE", "MAK", "…
    ## $ ski          <int> 1, 1, 2, 1, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 2, 2, 2, …
    ## $ ptsd         <dbl> 4.466667, 3.733333, 2.666667, 4.466667, 4.266667, 4.60000…
    ## $ anx1_r       <int> 4, 2, 1, 3, 2, 5, 2, 4, 5, 1, 5, 5, 2, 1, 3, 4, 1, 5, 2, …
    ## $ anx4_r       <int> 3, 2, 3, 1, 2, 5, 2, 4, 2, 1, 5, 5, 5, 5, 3, 5, 1, 1, 3, …
    ## $ anxi         <dbl> 4.000000, 2.000000, 2.166667, 2.000000, 3.000000, 5.00000…
    ## $ outb         <dbl> 5.0, 5.0, 1.0, 5.0, 4.5, 1.0, 2.5, 5.0, 3.5, 5.0, 1.0, 5.…
    ## $ ifor         <dbl> 3.5, 4.0, 1.0, 4.0, 4.5, 3.0, 3.0, 3.0, 3.5, 5.0, 3.5, 1.…
    ## $ iden         <dbl> 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 3.0, 1.…
    ## $ cont         <int> 3, 5, 1, 3, 3, 1, 3, 3, 3, 5, 1, 1, 4, 1, 1, 2, 3, 1, 1, …
    ## $ wart         <dbl> 0.4, 1.0, 1.0, 0.8, 0.6, 0.2, 0.0, 0.4, 0.8, 0.0, 0.4, 0.…
    ## $ sex_original <int> 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 2, 1, 2, 2, 2, 1, 1, 2, …
    ## $ sex          <dbl> 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, …
    ## $ emp_original <int> 2, 2, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 2, 1, 2, 1, 1, …
    ## $ emp          <dbl> 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, …
    ## $ mar_original <int> 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 1, 1, …
    ## $ mar          <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, …
    ## $ rel_original <int> 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 1, 2, 1, 1, 1, 2, 1, 1, …
    ## $ rel          <dbl> 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, …
    ## $ trt          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …

``` r
# -----------------------------------------------
# add labels
# -----------------------------------------------

data_ptsd <- data_ptsd %>%
labelled::set_variable_labels(
ptsd   = 'post traumatic stress disorder',
anx1_r = '[R] Relaxed',
anx4_r = '[R] Safe',
anxi   = 'Anxiety',
outb   = 'Outgroup blame',
ifor   = 'Intergroup forgiveness',
iden   = 'Ingroup (national) identification',
cont   = 'Outgroup contact',
wart   = 'War trauma',
sex    = 'Sex (1 = male, 0 = female)',
emp    = 'Employment Status (1 = employed, 0 = unemployed)',
mar    = 'Marital Status (1 = married, 0 = not married',
rel    = 'Religion (1 = not muslim, 0 = muslim)',
trt    = 'Treated (1 = treated, 0 = not treated'
)


# -----------------------------------------------
# chequear value labels
# -----------------------------------------------

data_ptsd %>%
labelled::look_for() %>%
labelled::lookfor_to_long_format() %>%
tibble::as_tibble() %>%
knitr::kable()
```

| pos | variable     | label                                            | col_type | levels | value_labels |
|----:|:-------------|:-------------------------------------------------|:---------|:-------|:-------------|
|   1 | id_i         | NA                                               | int      | NA     | NA           |
|   2 | cond         | NA                                               | chr      | NA     | NA           |
|   3 | ie01         | NA                                               | int      | NA     | NA           |
|   4 | ie02         | NA                                               | int      | NA     | NA           |
|   5 | ie03         | NA                                               | int      | NA     | NA           |
|   6 | ie04         | NA                                               | int      | NA     | NA           |
|   7 | ie05         | NA                                               | int      | NA     | NA           |
|   8 | ie06         | NA                                               | int      | NA     | NA           |
|   9 | ie07         | NA                                               | int      | NA     | NA           |
|  10 | ie08         | NA                                               | int      | NA     | NA           |
|  11 | ie09         | NA                                               | int      | NA     | NA           |
|  12 | ie10         | NA                                               | int      | NA     | NA           |
|  13 | ie11         | NA                                               | int      | NA     | NA           |
|  14 | ie12         | NA                                               | int      | NA     | NA           |
|  15 | ie13         | NA                                               | int      | NA     | NA           |
|  16 | ie14         | NA                                               | int      | NA     | NA           |
|  17 | ie15         | NA                                               | int      | NA     | NA           |
|  18 | ie16         | NA                                               | int      | NA     | NA           |
|  19 | ie17         | NA                                               | int      | NA     | NA           |
|  20 | ptc1         | NA                                               | int      | NA     | NA           |
|  21 | ptc2         | NA                                               | int      | NA     | NA           |
|  22 | ide1         | NA                                               | int      | NA     | NA           |
|  23 | ide2         | NA                                               | int      | NA     | NA           |
|  24 | noe1         | NA                                               | int      | NA     | NA           |
|  25 | noe2         | NA                                               | int      | NA     | NA           |
|  26 | for1         | NA                                               | int      | NA     | NA           |
|  27 | for2         | NA                                               | int      | NA     | NA           |
|  28 | for3         | NA                                               | int      | NA     | NA           |
|  29 | for4         | NA                                               | int      | NA     | NA           |
|  30 | for5         | NA                                               | int      | NA     | NA           |
|  31 | con          | NA                                               | int      | NA     | NA           |
|  32 | noe3         | NA                                               | int      | NA     | NA           |
|  33 | noe4         | NA                                               | int      | NA     | NA           |
|  34 | noe5         | NA                                               | int      | NA     | NA           |
|  35 | for6         | NA                                               | int      | NA     | NA           |
|  36 | noe6         | NA                                               | int      | NA     | NA           |
|  37 | noe7         | NA                                               | int      | NA     | NA           |
|  38 | noe8         | NA                                               | int      | NA     | NA           |
|  39 | anx1         | NA                                               | int      | NA     | NA           |
|  40 | anx2         | NA                                               | int      | NA     | NA           |
|  41 | anx3         | NA                                               | int      | NA     | NA           |
|  42 | anx4         | NA                                               | int      | NA     | NA           |
|  43 | anx5         | NA                                               | int      | NA     | NA           |
|  44 | anx6         | NA                                               | int      | NA     | NA           |
|  45 | war1         | NA                                               | int      | NA     | NA           |
|  46 | war2         | NA                                               | int      | NA     | NA           |
|  47 | war3         | NA                                               | int      | NA     | NA           |
|  48 | war4         | NA                                               | int      | NA     | NA           |
|  49 | war5         | NA                                               | int      | NA     | NA           |
|  50 | war6         | NA                                               | int      | NA     | NA           |
|  51 | war7         | NA                                               | int      | NA     | NA           |
|  52 | war8         | NA                                               | int      | NA     | NA           |
|  53 | ie18         | NA                                               | int      | NA     | NA           |
|  54 | fut1         | NA                                               | int      | NA     | NA           |
|  55 | fut2         | NA                                               | int      | NA     | NA           |
|  56 | age          | NA                                               | int      | NA     | NA           |
|  57 | nat          | NA                                               | chr      | NA     | NA           |
|  58 | ski          | NA                                               | int      | NA     | NA           |
|  59 | ptsd         | post traumatic stress disorder                   | dbl      | NA     | NA           |
|  60 | anx1_r       | \[R\] Relaxed                                    | int      | NA     | NA           |
|  61 | anx4_r       | \[R\] Safe                                       | int      | NA     | NA           |
|  62 | anxi         | Anxiety                                          | dbl      | NA     | NA           |
|  63 | outb         | Outgroup blame                                   | dbl      | NA     | NA           |
|  64 | ifor         | Intergroup forgiveness                           | dbl      | NA     | NA           |
|  65 | iden         | Ingroup (national) identification                | dbl      | NA     | NA           |
|  66 | cont         | Outgroup contact                                 | int      | NA     | NA           |
|  67 | wart         | War trauma                                       | dbl      | NA     | NA           |
|  68 | sex_original | NA                                               | int      | NA     | NA           |
|  69 | sex          | Sex (1 = male, 0 = female)                       | dbl      | NA     | NA           |
|  70 | emp_original | NA                                               | int      | NA     | NA           |
|  71 | emp          | Employment Status (1 = employed, 0 = unemployed) | dbl      | NA     | NA           |
|  72 | mar_original | NA                                               | int      | NA     | NA           |
|  73 | mar          | Marital Status (1 = married, 0 = not married     | dbl      | NA     | NA           |
|  74 | rel_original | NA                                               | int      | NA     | NA           |
|  75 | rel          | Religion (1 = not muslim, 0 = muslim)            | dbl      | NA     | NA           |
|  76 | trt          | Treated (1 = treated, 0 = not treated            | dbl      | NA     | NA           |
