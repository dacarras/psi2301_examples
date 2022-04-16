# acciones colectivas
data_ac <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/accionescolestivas.csv'
	)
)

# ptsd
data_ptsd <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
	)
)

# homonegatividad
data_hom <- read.csv2(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/homonegatividad.csv'
	), na.strings = -99
)

# integracion universitaria
data_int <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/integracion_universitaria.csv'
	)
)

# desarollo psicomotor
data_psi <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/desarollo_psicomotor.csv'
	)
)

# terce
data_terce <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/terce_n.csv'
	)
)
