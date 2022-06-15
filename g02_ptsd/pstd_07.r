#--------------------------------------
# abrir datos ptsd
#--------------------------------------

data_ptsd <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
	)
)

#--------------------------------------
# grafico con recategorización
#--------------------------------------

dplyr::count(data_ptsd, fut2)

# variable 2: "Experiencia personal de trauma de guerra"
# fut2 = "What do you think; will there be another civil 
#         war in Sierra Leone within the next 10 years"
# grafico de barras recategorizado 4 categorias.

data_ptsd %>%
mutate(fut2_4_cat = case_when(
	fut2 == 1 ~ 1, # certainly -> probablemente
	fut2 == 2 ~ 1, # probably  -> probablemente
	fut2 == 3 ~ 2, # undecided -> no lo sé
	fut2 == 4 ~ 3, # probably not  -> probablemente no
	fut2 == 5 ~ 4  # certainly not -> no
	)) %>%
with(., table(fut2_4_cat)) %>%
barplot(.,
	col  = "#CAFF70", 
	main = "Reconstrucción del trauma por guerra",
	xlab = "Sensación de probabilidad de otra guerra civil dentro de 10 años",
	names.arg = 
	c("probablemente",
		"no lo sé",
		"probablemente no",
		"no"),
	ylab = "Frecuencia",
	ylim= c(0,75)
)

