# abrir datos ptsd
data_ptsd <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
	)
)


# plot de respuesta de un item
barplot(table(data_ptsd$fut2),
    xaxt = "n")
axis(1, at = c(1, 2, 3, 4, 5),
labels = c(
'certainly',
'probably',
'undecided',
'probably not',
'certainly not '
))



