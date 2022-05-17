
# código original

# tabla3 <- table(data_ptsd$noe6)
# data_ptsd$noe6 [data_ptsd$noe6 >= 4 & data_ptsd$noe6 <= 5] = 4
# dplyr::count (data_ptsd,noe6)

# barplot(table(data_ptsd$noe6),col="orange",main = "No juzgo a un desconocido por su pasado como rebelde o no", names.arg = c("si", "no"),ylab = "Frecuencia", ylim= c(0,55),las=2,cex.names=.8,xlab="Sensación ante enunciado")


# código sugerido

## abrir datos ptsd
data_ptsd <- read.csv(
	url(
'https://raw.githubusercontent.com/dacarras/psi2301_examples/master/data/ptsd_data.csv'
	)
)

## frecuencia de respuestas
dplyr::count(data_ptsd, noe6)

## texto item noe6 
# frame: 
# "I think rebels are entirely to blame for what they have during the war"
#
# response categories:
# not at all - 1 2 3 4 5 - very much


# plots

## ejemplo con base
barplot(table(data_ptsd$noe6),
     main = 'Creo que los rebeldes son culpables\npor lo que pasó durante la guerra',
     ylab = '',                
     xlab = '',
     col = 'orange',    
     ylim = c(0, 100),
     names.arg = c("1\nNada", "2","3", "4","5\nMucho")
     )          