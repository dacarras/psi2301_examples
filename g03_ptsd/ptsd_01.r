# abrir datos ptsd
data_ptsd <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
	)
)

# que genera table para 3 items
table(data_ptsd$war2, data_ptsd$war3, data_ptsd$war5)


# plots

## ejemplo con base
barplot(table(data_ptsd$war2),        
     ylab = "Frecuencia",                
     xlab = "He visto cómo mataban a personas",
     col = 'red',    
     ylim = c(0, 100)
     )               

## ejemplo 1 con gglot2
library(ggplot2)
ggplot(data_ptsd, aes(war2)) +
  geom_bar(fill = "#0073C2FF") +
  theme_bw()

## ejemplo 2 con gglot2
library(dplyr)
data_ptsd %>%
summarize(
war2 = mean(war2, na.rm = TRUE),
war3 = mean(war3, na.rm = TRUE),
war4 = mean(war4, na.rm = TRUE)
) %>%
tidyr::pivot_longer(war2:war4) %>%
mutate(item_text = c(
"He visto cómo mataban a personas",
"He visto gente muerta",
"He perdido a personas de mi familia en la guerra"
	)
) %>%
ggplot(., aes(item_text, value)) +
  geom_col(fill = "#0073C2FF") +
  coord_flip() +
  ylim(0,1)+
  theme_bw()




