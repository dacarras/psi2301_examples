# abrir datos
data_hom <- read.csv2(
url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/homonegatividad.csv'
	), na = -99
)

# mostrar datos
dplyr::glimpse(data_hom)

# código original
# código que utilizamos para crear variable
# data_hom$afect_mujeres = with(data_hom, rowMeans(cbind(afe1les,afe2les,afe3les,afe4les), na.rm=TRUE))

# códigos que utilizamos para calcular media y mediana

# median(data_hom$afect_mujeres)
# mean(data_hom$afect_mujeres)

# código actualizado
# código que utilizamos para crear variable
data_hom$afect_mujeres = with(data_hom, rowMeans(cbind(afe1les,afe2les,afe3les,afe4les), na.rm=TRUE))

# códigos que utilizamos para calcular media y mediana

median(data_hom$afect_mujeres, na.rm = TRUE)
mean(data_hom$afect_mujeres, na.rm = TRUE)