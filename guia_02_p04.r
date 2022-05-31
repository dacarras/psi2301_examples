




data_p4 <- data.frame(
index  = c(1, 2, 3, 4),     # filas
term_1 = c(5, 16, 10, 36),  # sigma y simga^2
term_2 = c(30, 20, 50, 50), # mu
term_3 = c(20, 30, 15, 50)  # n
)

library(dplyr)
data_p4 <- data_p4 %>%
           mutate(sigma = case_when(
           	index == 1 ~ term_1,
           	index == 2 ~ sqrt(term_1),
           	index == 3 ~ term_1,
           	index == 4 ~ sqrt(term_1)
           	)) %>%
           mutate(mu = term_2) %>%
           mutate(n = term_3) %>%
           mutate(sd_sample = sigma/sqrt(n)) %>%
           arrange(sd_sample)


knitr::kable(data_p4, digits = 2)