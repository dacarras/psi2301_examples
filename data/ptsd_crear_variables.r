# -----------------------------------------------
# abir datos
# -----------------------------------------------

# data_ptsd <- psi2301::ptsd_data

data_ptsd <- read.csv(url('https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'))

# -----------------------------------------------
# creación de variables en el articulo
# -----------------------------------------------

data_ptsd <- data_ptsd %>%
              # PTSD
              mutate(ptsd = psi2301::mean_score(
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
              mutate(anx1_r = psi2301::reverse(anx1)) %>%
              mutate(anx4_r = psi2301::reverse(anx4)) %>%
              ## mean score
              mutate(anxi = psi2301::mean_score(
              anx1_r  ,  # [R] Relaxed
              anx2    ,  # Threatened
              anx3    ,  # Awkward
              anx4_r  ,  # [R] Safe
              anx5    ,  # Nervous
              anx6       # Anxious
              )) %>%
              # Out-group blame
              mutate(outb = psi2301::mean_score(
              noe6,      # I think that the rebels are entirely to blame for what they have done during the war 
              noe7       # I think that the rebels are responsible for everything they did
              )) %>%
              # Intergroup forgiveness
              mutate(ifor = psi2301::mean_score(
              for6,  # I think my group should reach out to the rebels and forgive them what they have done
              for5   # I should forgive the rebels their misdeeds              
              )) %>%
              # In-group (National) Identification
              mutate(iden = psi2301::mean_score(
              ide1,  # I am proud to be a Sierra Leonine
              ide2   # I have very strong ties with Sierra Leone
              )) %>%
              # Out-group contact
              mutate(cont = con) %>%
              # Personal War Trauma Experience
              mutate(wart = psi2301::mean_score(
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

# -----------------------------------------------
# incluir labels
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
